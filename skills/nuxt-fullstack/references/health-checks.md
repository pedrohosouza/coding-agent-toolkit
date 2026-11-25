# Health checks

## Rotas

- `GET /api/health/liveness`
- `GET /api/health/readiness`

## Regras

- Rotas em `server/api/health/liveness.get.ts` e `readiness.get.ts`, públicas (na allowlist do middleware de auth e fora do rate limit).
- Liveness indica apenas que o processo está vivo; não verifica dependências.
- Readiness verifica toda dependência externa de que o app precisa para atender requisições.
- Não exponha detalhes sensíveis (URLs, credenciais, mensagens internas de erro).
- Falha de qualquer indicador retorna `503` no envelope de erro.
- Durante o graceful shutdown, readiness responde `503` (`event.context.isShuttingDown`, definido por `server/plugins/shutdown.ts`).
- Cada verificação tem timeout curto, para que um serviço lento não trave o probe.

## Resposta

```json
{ "data": { "status": "ok", "checks": { "database": "up" } } }
```

## Readiness: toda dependência é verificada

- Banco de dados: `SELECT 1` via `prisma.$queryRaw`.
- Cache e filas (Redis): ping.
- Storage de objetos (S3 ou equivalente): chamada leve, como `HeadBucket`.
- APIs externas críticas e SMTP: chamada leve com timeout.

Regras:

- Ao adicionar uma dependência nova, adicione o indicador no mesmo PR.
- Cada indicador é uma função `check<Name>()` que retorna `'up' | 'down'` e entra em `checks` com chave estável (`database`, `redis`, `storage`).
- Dependência opcional ou degradável não entra no readiness.

## Exemplo

```ts
const checks = {
  database: await checkDatabase(),
  redis: await checkRedis()
}
const isReady = Object.values(checks).every((status) => status === 'up')

if (!isReady) {
  throw createError({ statusCode: 503, message: 'Service unavailable' })
}

return respond({ status: 'ok', checks })
```

## Templates

`health-liveness.get.ts.tpl` e `health-readiness.get.ts.tpl`.
