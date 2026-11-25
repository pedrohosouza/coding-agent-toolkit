# Prisma

## Responsabilidades

- `server/utils/prisma.ts` exporta o único cliente Prisma (`prisma`) estendido com `paginationExtension`, e o type `ExtendedPrismaClient`.
- Services e validators usam o cliente e executam as queries.
- Rotas não conhecem Prisma; não existe camada de repository.

## Estrutura

```text
prisma/
├── schema.prisma
├── migrations/
└── seeds/
prisma.config.ts
server/generated/prisma/
server/utils/prisma.ts
server/utils/pagination.ts
```

- O client é gerado em `server/generated/prisma` (`provider = "prisma-client"`, `output = "../server/generated/prisma"`) e importado de `~~/server/generated/prisma/client`.
- Use o adapter `@prisma/adapter-pg` com `databaseUrl` lido de `useRuntimeConfig()`.
- O cliente é singleton; em dev, guarde-o em `globalThis` para sobreviver ao hot reload (já feito no template).
- `prisma.config.ts` lê `NUXT_DATABASE_URL`.

## Regras

- Use `select` por padrão; extraia para `<ENTITY>_SELECT` com `satisfies Prisma.<Entity>Select`.
- Use `include` apenas quando a relação for necessária; evite N+1.
- Use `prisma.$transaction` apenas para múltiplas escritas dependentes.
- Nunca retorne o model Prisma na resposta HTTP nem no payload SSR.
- Nunca exponha campos sensíveis.
- Erros do Prisma (`P2002`, `P2025`) são traduzidos pelo error handler.
- Desconecte no `close` do Nitro (`server/plugins/shutdown.ts`).

## Identificadores (UUID)

```prisma
model Order {
  id         String   @id @default(dbgenerated("uuidv7()")) @db.Uuid
  userId     String   @db.Uuid
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("orders")
}
```

- Toda PK e FK usam `String @db.Uuid`; toda PK usa `@default(dbgenerated("uuidv7()"))` (PostgreSQL 18+).
- Não use autoincrement nem `cuid()` para ids de domínio.
- Todo `:id` de rota passa por `z.uuid()`; todo id em body ou query também.
- Não use `id` como fonte de data; use `createdAt`.

## Migrations

- Toda mudança de schema passa por migration versionada; nunca altere o banco manualmente.
- Nunca edite migration já aplicada em ambiente compartilhado; crie outra.
- `migrate dev` apenas em desenvolvimento; `migrate deploy` em CI/CD, staging e produção.
- Nunca use `migrate reset` em banco com dados reais.
- Commite `schema.prisma`, `migrations/` e `migration_lock.toml`.

```bash
npm run prisma:migrate:dev -- --name <migration_name>
npm run prisma:migrate:dev -- --create-only --name <migration_name>
npm run prisma:migrate:deploy
npx prisma migrate status
```

## Paginação

- `paginationExtension` (`server/utils/pagination.ts`) adiciona `paginate()` a todos os models.
- `paginate(args, { page, perPage, search, searchFields })` aceita o mesmo `args` de `findMany`, exceto `skip` e `take`.
- Retorna `{ data, pagination }` (`PaginatedApiResponse`), que a rota devolve com `respondPaginated`.
- `page` começa em `1`; `perPage` padrão `10`, máximo `100`.
- Use `search` apenas com `searchFields` vindos de `<ENTITY>_SEARCHABLE_FIELDS`; busca sem acento em `references/search.md`.
- Ordenação usa `sort` e `order` validados contra `<ENTITY>_SORTABLE_FIELDS`; nunca aceite campo arbitrário.
- Use `paginate()` em toda listagem potencialmente crescente; não monte `skip`/`take` à mão.

```ts
return this.db.order.paginate(
  {
    where: { userId, status: query.status },
    orderBy: { [query.sort]: query.order },
    select: ORDER_SELECT
  },
  {
    page: query.page,
    perPage: query.perPage,
    search: query.search,
    searchFields: ORDER_SEARCHABLE_FIELDS
  }
)
```

## Templates

`prisma.util.ts.tpl`, `pagination.util.ts.tpl`, `select.constant.ts.tpl`.
