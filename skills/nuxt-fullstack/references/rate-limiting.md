# Rate limiting

## Regras

- O limite é aplicado pelo middleware `server/middleware/rate-limit.ts` (template `rate-limit.middleware.ts.tpl`); ele roda depois de `auth.ts` (ordem alfabética), então já enxerga `event.context.session`.
- Aplique limite global e limites mais restritos em rotas sensíveis.
- Autenticado: identifica por `session.user.id`; público: por IP (`getRequestIP(event, { xForwardedFor: true })`).
- Use `xForwardedFor` apenas atrás de proxy confiável; caso contrário o IP pode ser forjado.
- `/api/auth/*` tem rate limit próprio do Better Auth (`rateLimit.customRules` para login, cadastro e reset de senha); o middleware as ignora.
- Webhooks e demais rotas sensíveis entram em `SENSITIVE_PATH_PREFIXES`.
- Ao exceder, responda `429` com `Retry-After`.
- Janela e limites vêm de `runtimeConfig` (`rateLimitWindowMs`, `rateLimitPublicLimit`, `rateLimitAuthenticatedLimit`, `rateLimitSensitiveLimit`).
- O armazenamento em memória do template vale para uma instância; com várias réplicas use `useStorage` com driver Redis.

## Defaults

- Público: 60 requisições por minuto por IP.
- Autenticado: 1000 requisições por minuto por usuário.
- Sensível: 5 a 10 requisições por minuto por IP.

## Headers

- `X-RateLimit-Limit`
- `X-RateLimit-Remaining`
- `X-RateLimit-Reset`
- `Retry-After` no `429`
