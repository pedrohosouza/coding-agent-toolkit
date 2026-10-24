# Graceful shutdown

## Regras

- Ao receber `SIGTERM` ou `SIGINT`, pare de aceitar novas requisições.
- Finalize requisições em andamento.
- Feche conexões de banco, cache e filas.
- Use timeout máximo configurável.
- Readiness deve mudar para indisponível antes do encerramento.
- Chame `app.enableShutdownHooks()` no `main.ts`.
- Feche recursos em `onModuleDestroy` (ex.: `PrismaModule` executa `$disconnect()`).
