# Graceful shutdown

## Regras

- Ao receber `SIGTERM` ou `SIGINT`, o servidor Node do Nitro (`node-server`) para de aceitar conexões e fecha o app; não registre outro `server.close()`.
- O plugin `server/plugins/shutdown.ts` (template `shutdown.plugin.ts.tpl`) cuida do restante.
- Readiness muda para `503` assim que o sinal chega: o plugin marca `event.context.isShuttingDown` no hook `request`.
- Recursos são fechados no hook `close` do Nitro (`nitroApp.hooks.hook('close', ...)`): `prisma.$disconnect()` e, se existirem, cache e filas.
- Timeout máximo configurável por `runtimeConfig.shutdownTimeoutMs` (`NUXT_SHUTDOWN_TIMEOUT_MS`); ao estourar, o processo sai com código `1`.
- O Nitro também respeita `NITRO_SHUTDOWN_TIMEOUT` e `NITRO_SHUTDOWN_SIGNALS`; mantenha os dois valores coerentes.
- No Docker, rode o servidor como PID 1 sem shell intermediário (`CMD ["node", ".output/server/index.mjs"]`) para receber o sinal.
- Defina `terminationGracePeriodSeconds`/`stop_grace_period` maior que o timeout.
