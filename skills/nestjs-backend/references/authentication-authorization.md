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
