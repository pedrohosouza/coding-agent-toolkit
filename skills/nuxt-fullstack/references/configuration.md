# Configuração

## Regras

- Nenhum código de aplicação acessa `process.env`; use `useRuntimeConfig()`.
- Exceções: `nuxt.config.ts`, `prisma.config.ts` e os seeds, que rodam fora do Nitro.
- Toda chave nova entra em `runtimeConfig` e no schema Zod do plugin `server/plugins/env.ts` antes do primeiro uso.
- O app falha no boot se uma variável obrigatória estiver ausente ou inválida.
- Segredos ficam em `runtimeConfig` privado; nunca em `runtimeConfig.public`.
- Mantenha `.env.example` atualizado, sem valores reais.
- Nunca exponha segredos em respostas, payload SSR ou repositório.

## runtimeConfig

O Nuxt sobrescreve as chaves de `runtimeConfig` com variáveis `NUXT_` + chave em `UPPER_SNAKE_CASE`, em runtime (sem inlinar o valor no build). Declare a chave com valor vazio e defina a variável de ambiente.

```ts
export default defineNuxtConfig({
  runtimeConfig: {
    databaseUrl: '',
    betterAuthSecret: '',
    betterAuthUrl: '',
    googleClientId: '',
    googleClientSecret: '',
    rateLimitWindowMs: '',
    rateLimitPublicLimit: '',
    rateLimitAuthenticatedLimit: '',
    rateLimitSensitiveLimit: '',
    shutdownTimeoutMs: '',
    public: {}
  }
})
```

- `databaseUrl` vira `NUXT_DATABASE_URL`; `betterAuthSecret` vira `NUXT_BETTER_AUTH_SECRET`.
- Valores chegam como string; o schema usa `z.coerce.number()` para numéricos.
- `prisma.config.ts` e os seeds leem `NUXT_DATABASE_URL`; não crie uma segunda variável para o mesmo valor.
- O mesmo app serve frontend e API: não há CORS; `trustedOrigins` do Better Auth usa `betterAuthUrl`.

## Validação no boot

Plugin `server/plugins/env.ts` (template `env.plugin.ts.tpl`): `envSchema.safeParse(useRuntimeConfig())` e `throw` com a lista de problemas.

- Todo `useRuntimeConfig()` dentro de `server/` lê o valor já validado.
- Valores públicos do cliente entram em `runtimeConfig.public` e são lidos com `useRuntimeConfig().public`.

## Organização do `.env`

- Variáveis do app vêm primeiro, sem agrupamento por prefixo: `NODE_ENV`, `PORT`.
- As demais são agrupadas por prefixo (`NUXT_DATABASE_`, `NUXT_BETTER_AUTH_`).
- Uma linha em branco separa o bloco do app e cada grupo.
- `.env` e `.env.example` usam a mesma ordem e os mesmos grupos; o `.env.example` não tem valores reais.

```text
NODE_ENV=development
PORT=3000

NUXT_DATABASE_URL=

NUXT_BETTER_AUTH_SECRET=
NUXT_BETTER_AUTH_URL=

NUXT_GOOGLE_CLIENT_ID=
NUXT_GOOGLE_CLIENT_SECRET=

NUXT_RATE_LIMIT_WINDOW_MS=60000
NUXT_RATE_LIMIT_PUBLIC_LIMIT=60
NUXT_RATE_LIMIT_AUTHENTICATED_LIMIT=1000
NUXT_RATE_LIMIT_SENSITIVE_LIMIT=10

NUXT_SHUTDOWN_TIMEOUT_MS=30000
```
