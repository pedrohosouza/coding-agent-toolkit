# Rate limiting

## Regras

- Use `@nestjs/throttler`.
- Aplique limite global e limites mais restritos em rotas sensíveis.
- Rotas de login, reset de senha e webhooks têm limite próprio.
- Identifique por token quando autenticado; por IP em rotas públicas.
- Ao exceder, retorne `429` com `Retry-After`.
- Limites são configuráveis por ambiente.

## Defaults

- Público: 60 requisições por minuto por IP.
- Autenticado: 1000 requisições por minuto por token.
- Sensível: 5 a 10 requisições por minuto por IP.

## Headers

- `X-RateLimit-Limit`
- `X-RateLimit-Remaining`
- `X-RateLimit-Reset`
- `Retry-After` no `429`
