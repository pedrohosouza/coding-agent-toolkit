# Autenticação e autorização

## Implementação padrão

- Autenticação, sessões e usuários: Better Auth, montado no Nitro em `server/api/auth/[...all].ts`.
- Autorização por organização, quando aplicável: plugin Organization.
- Autorização por recurso: service/use case.

## Regras de autenticação

- Toda rota `/api/*` é autenticada por padrão pelo middleware `server/middleware/auth.ts`.
- Rotas públicas entram explicitamente na allowlist `PUBLIC_PATH_PREFIXES` (`/api/auth/`, `/api/health/`).
- Toda rota chama `requireSession(event)` depois de validar a entrada; ele devolve a sessão ou lança `401`.
- Nunca confie apenas na existência do cookie; sempre valide a sessão no servidor.
- Rotas de login, reset de senha e webhooks têm rate limit próprio (`references/rate-limiting.md`).

## Regras de autorização

- Services recebem `userId` (ou `organizationId`) explicitamente: `execute(userId, id, input)`.
- Nunca aceite `userId` ou `organizationId` do body, query ou header como identidade; use `session.user.id`.
- Verifique ownership ou permissão por recurso antes de ler, atualizar ou remover.
- Aplique o menor privilégio; roles e permissões são validados no servidor.

## IDOR/BOLA

1. Valide o `:id` como UUID (`z.uuid()`).
2. Carregue o recurso já filtrando pelo dono, no validator.
3. Sem resultado, lance `404` (ou `403`, conforme a política do projeto).
4. Só então opere.

```ts
const order = await this.db.order.findFirst({
  where: { id, userId },
  select: { id: true }
})

if (!order) {
  throw createError({ statusCode: 404, message: 'Order not found' })
}
```

## Better Auth no servidor

Instância em `server/utils/auth.ts` (template `auth.util.ts.tpl`).

- `database`: `prismaAdapter(prisma, { provider: 'postgresql' })`.
- `secret` (`betterAuthSecret`, mínimo 32 caracteres) e `baseURL` (`betterAuthUrl`) vêm de `useRuntimeConfig()`.
- `trustedOrigins: [betterAuthUrl]`; o app é de mesma origem.
- `advanced: { database: { generateId: false } }` para o banco gerar o UUID v7 (`uuidv7()`) de `User`, `Session`, `Account` e `Verification`.
- Provedores: `emailAndPassword.enabled` e Google (`googleClientId`, `googleClientSecret`).
- `rateLimit.enabled` com `customRules` para `/sign-in/*`, `/sign-up/*`, `/forget-password` e `/reset-password`.
- Models `User`, `Session`, `Account` e `Verification` seguem o schema do Better Auth com `@@map` em snake_case plural, ids `@db.Uuid` e `onDelete: Cascade` nas relações com `User`.
- Handler: `defineEventHandler((event) => auth.handler(toWebRequest(event)))`.
- Sessão: `auth.api.getSession({ headers: event.headers })`.

## Plugin Organization

- Adicione `organization()` (de `better-auth/plugins`) em `plugins` da instância e `organizationClient()` no cliente.
- Gere o schema com a CLI do Better Auth e crie a migration; os models `Organization`, `Member` e `Invitation` também usam UUID v7 do banco.
- A organização ativa fica em `session.session.activeOrganizationId`; services recebem esse `organizationId` explicitamente.
- Recursos do tenant têm coluna `organizationId`; todo `where` inclui `organizationId` vindo da sessão.
- O validator de existência filtra por `{ id, organizationId }`, evitando acesso entre organizações.
- Confirme a role do membro no servidor antes de ações privilegiadas: `auth.api.hasPermission({ headers: event.headers, body: { permissions: { ... } } })`, ou `auth.api.getActiveMember`.
- Nunca confie em role vinda do navegador; nunca aceite `organizationId` do body para definir o escopo.

## Regras de segurança

- Nunca exponha tokens, hashes, segredos ou dados sensíveis da sessão na resposta nem no payload SSR.
- Segredos ficam apenas em `runtimeConfig` privado.
