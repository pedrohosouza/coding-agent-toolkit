# Autenticação e autorização

## Implementação padrão

- Integração NestJS: Better Auth.
- Sessões e usuários: Better Auth.
- Autorização por organização, quando aplicável: plugin Organization.
- Autorização por recurso: service/use case.

## Regras de autenticação

- Todas as rotas são autenticadas por padrão.
- O guard de autenticação do Better Auth é global.
- Rotas públicas usam `@AllowAnonymous()` explicitamente.
- Rotas com autenticação opcional usam `@OptionalAuth()`.
- Use `@Session()` para acessar a sessão autenticada.
- Sempre valide a sessão no servidor para operações protegidas.
- Nunca confie apenas na existência do cookie de sessão.

## Regras de autorização

- Autenticação identifica quem está chamando.
- Autorização define o que essa identidade pode fazer.
- Services recebem o actor/userId/session explicitamente.
- Nunca aceite `userId` do body para identificar o dono do recurso.
- Verifique ownership ou permissão por recurso antes de ler, atualizar ou remover.
- Aplique o menor privilégio.
- Permissões e roles são validadas no servidor.

## IDOR/BOLA

Ao acessar um recurso:

1. Valide o formato do identificador.
2. Carregue o recurso.
3. Verifique se o recurso pertence ao usuário ou se ele tem permissão.
4. Retorne `403` ou `404` conforme a política do projeto.

```ts
const order = await this.prisma.order.findUnique({
  where: { id: input.id },
});

if (!order || order.userId !== session.user.id) {
  throw new NotFoundException('Order not found');
}
```

## Regras de segurança

- Nunca exponha tokens, hashes, segredos ou dados sensíveis da sessão.
- Aplique rate limit em rotas de login, reset de senha e webhooks.
- Secrets ficam apenas na camada de configuração.

## Configuração do Better Auth

A instância é criada em `src/common/modules/auth/factories/auth.factory.ts` (`createAuth`) e registrada em `AuthModule` com `BetterAuthModule.forRootAsync({ isGlobal: true })`, injetando `PrismaService` e `ConfigService`.

- Desative o body parser do Nest: `NestFactory.create(AppModule, { bodyParser: false })`. O Better Auth lê o body da requisição por conta própria; o integration package reativa o parsing das demais rotas.
- Passe `disableTrustedOriginsCors: true` ao módulo: o CORS é responsabilidade do `app.enableCors()` (veja `references/cors.md`).
- `trustedOrigins` vem de `CORS_ALLOWED_ORIGINS`, convertido por `parseAllowedOrigins`, a mesma função usada no CORS; nunca duplique a lista.
- Use `advanced: { database: { generateId: false } }` para que o banco gere o UUID v7 (`uuidv7()`) de `User`, `Session`, `Account` e `Verification`.
- `database` usa `prismaAdapter(prismaService, { provider: 'postgresql' })`.
- `secret` (`BETTER_AUTH_SECRET`, mínimo 32 caracteres) e `baseURL` (`BETTER_AUTH_URL`) vêm de `ConfigService`.
- Provedores: e-mail e senha (`emailAndPassword.enabled`) e Google (`GOOGLE_CLIENT_ID` e `GOOGLE_CLIENT_SECRET`, obrigatórios no schema de env).
- O rate limit do Better Auth fica ativo (`rateLimit.enabled`), com `window` derivada de `THROTTLE_TTL_MS`, `max` de `THROTTLE_ANONYMOUS_LIMIT` e `customRules` com `THROTTLE_SENSITIVE_LIMIT` para `SENSITIVE_ROUTES`: `/sign-in/*`, `/sign-up/*`, `/forget-password` e `/reset-password`.
- Models `User`, `Session`, `Account` e `Verification` seguem o schema do Better Auth com `@@map` em snake_case plural, ids `@db.Uuid` e `onDelete: Cascade` nas relações com `User`.

```ts
export function createAuth(
  prismaService: PrismaService,
  configService: ConfigService,
) {
  return betterAuth({
    database: prismaAdapter(prismaService, { provider: 'postgresql' }),
    secret: configService.getOrThrow<string>('BETTER_AUTH_SECRET'),
    baseURL: configService.getOrThrow<string>('BETTER_AUTH_URL'),
    trustedOrigins: parseAllowedOrigins(
      configService.getOrThrow<string>('CORS_ALLOWED_ORIGINS'),
    ),
    emailAndPassword: { enabled: true },
    socialProviders: {
      google: {
        clientId: configService.getOrThrow<string>('GOOGLE_CLIENT_ID'),
        clientSecret: configService.getOrThrow<string>('GOOGLE_CLIENT_SECRET'),
      },
    },
    advanced: { database: { generateId: false } },
    rateLimit: {
      enabled: true,
      window: windowInSeconds,
      max: configService.getOrThrow<number>('THROTTLE_ANONYMOUS_LIMIT'),
      customRules: Object.fromEntries(
        SENSITIVE_ROUTES.map((route) => [route, sensitiveRule]),
      ),
    },
  });
}
```
