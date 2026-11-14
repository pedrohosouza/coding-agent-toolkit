# Docker e deploy

## Regras

- O backend roda em container com `Dockerfile` multi-stage na raiz do projeto.
- Use imagem base `node` alpine na mesma major usada no desenvolvimento.
- Separe os estágios: `base`, `build`, `production-dependencies` e `runtime`.
- Instale com `npm ci`; dependências de produção com `npm ci --omit=dev`.
- O estágio `build` executa `npm run prisma:generate` antes de `npm run build`.
- O `runtime` copia apenas `node_modules` de produção, `dist/`, `package.json`, `prisma.config.ts` e `prisma/`; nunca copie `src/`, `.env` nem `node_modules` de desenvolvimento.
- O `runtime` define `NODE_ENV=production`, instala `openssl` (exigido pelo Prisma no alpine) e roda como `USER node`.
- O container aplica migrations no start com `npx prisma migrate deploy` antes de iniciar a aplicação; nunca use `migrate dev` nem `migrate reset` no container.
- Segredos e variáveis são injetados pelo ambiente; nunca entram na imagem.
- Mantenha `.dockerignore` com `node_modules`, `dist` e `.env`.
- A porta exposta é a mesma de `PORT`.
- Postgres local é provido por `docker-compose.yml`, com a mesma major usada em produção (18, por causa do `uuidv7()`), `healthcheck` com `pg_isready` e volume nomeado.
- Credenciais do compose servem apenas para desenvolvimento local.

## Dockerfile

```dockerfile
FROM node:24-alpine AS base
WORKDIR /app

FROM base AS build
COPY package.json package-lock.json ./
RUN npm ci
COPY tsconfig.json tsconfig.build.json nest-cli.json prisma.config.ts ./
COPY prisma ./prisma
RUN npm run prisma:generate
COPY src ./src
RUN npm run build

FROM base AS production-dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

FROM base AS runtime
RUN apk add --no-cache openssl
ENV NODE_ENV=production
COPY --from=production-dependencies /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package.json prisma.config.ts ./
COPY prisma ./prisma
USER node
EXPOSE 8000
CMD ["sh", "-c", "npx prisma migrate deploy && node ."]
```

## docker-compose.yml

```yaml
services:
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

- `docker compose up -d`: sobe o Postgres local.
- `npm run build`: compila para `dist/`.
- `npm run start:prod`: executa `node .`.
