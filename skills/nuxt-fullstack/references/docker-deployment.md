# Docker e deploy

## Regras

- O app roda em um único container com `Dockerfile` multi-stage na raiz; o Nitro serve frontend SSR e API.
- Use imagem base `node` alpine na mesma major usada no desenvolvimento.
- Separe os estágios: `base`, `build`, `production-dependencies` e `runtime`.
- Instale com `npm ci --ignore-scripts` (o `postinstall` do Nuxt precisa do código-fonte) e rode `npx nuxt prepare` depois de copiar o código.
- O estágio `build` executa `npm run prisma:generate` antes de `npm run build`; o build gera `.output/`.
- O `runtime` copia `.output/`, `node_modules` de produção, `package.json`, `prisma.config.ts` e `prisma/`; nunca copie `app/`, `server/`, `.env` nem `node_modules` de desenvolvimento.
- A CLI `prisma` precisa estar em `dependencies` para o `migrate deploy` funcionar no runtime.
- O `runtime` define `NODE_ENV=production`, `HOST=0.0.0.0` e `PORT`, instala `openssl` e roda como `USER node`.
- O container aplica migrations no start com `npx prisma migrate deploy` antes de iniciar o servidor; nunca use `migrate dev` nem `migrate reset` no container.
- Variáveis `NUXT_*` e demais segredos são injetados pelo ambiente em runtime; nunca entram na imagem nem no build.
- `HEALTHCHECK` e o healthcheck do compose usam `/api/health/readiness`; orquestradores usam `/api/health/liveness` para reinício.
- Mantenha `.dockerignore` com `node_modules`, `.nuxt`, `.output`, `coverage`, `test`, `playwright-report`, `test-results`, `.env` e `.env.test`.
- Postgres local é provido por `docker-compose.yml`, com a mesma major de produção (18, por causa do `uuidv7()`), `healthcheck` com `pg_isready` e volume nomeado.
- Credenciais do compose servem apenas para desenvolvimento local.
- O encerramento gracioso do Nitro (`SIGTERM`) está em `references/graceful-shutdown.md`.

## Dockerfile

```dockerfile
FROM node:24-alpine AS base
WORKDIR /app

FROM base AS build
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npx nuxt prepare && npm run prisma:generate && npm run build

FROM base AS production-dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

FROM base AS runtime
RUN apk add --no-cache openssl
ENV NODE_ENV=production HOST=0.0.0.0 PORT=3000
COPY --from=production-dependencies /app/node_modules ./node_modules
COPY --from=build /app/.output ./.output
COPY package.json prisma.config.ts ./
COPY prisma ./prisma
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/api/health/readiness || exit 1
CMD ["sh", "-c", "npx prisma migrate deploy && node .output/server/index.mjs"]
```

## docker-compose.yml

```yaml
services:
  app:
    build: .
    restart: unless-stopped
    env_file: .env
    environment:
      NUXT_DATABASE_URL: postgresql://postgres:postgres@postgres:5432/postgres
    ports:
      - '3000:3000'
    depends_on:
      postgres:
        condition: service_healthy
    healthcheck:
      test: ['CMD-SHELL', 'wget -qO- http://127.0.0.1:3000/api/health/readiness || exit 1']
      interval: 10s
      timeout: 5s
      retries: 5

  postgres:
    image: postgres:18-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    ports:
      - '5432:5432'
    volumes:
      - postgres-data:/var/lib/postgresql
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U postgres -d postgres']
      interval: 5s
      timeout: 5s
      retries: 10

volumes:
  postgres-data:
```

## Comandos

- `docker compose up -d postgres`: sobe só o Postgres para desenvolvimento com `npm run dev`.
- `docker compose up -d --build`: sobe app e Postgres.
- `npm run build`: gera `.output/`.
- `node .output/server/index.mjs`: executa o build localmente.
