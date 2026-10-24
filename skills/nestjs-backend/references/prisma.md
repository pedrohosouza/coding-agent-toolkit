# Prisma

## Responsabilidades

- `PrismaService` expõe o Prisma Client estendido com `paginationExtension`.
- Services injetam `PrismaService` e executam queries.
- Controllers não conhecem Prisma.
- Não existe camada de repository.

## Estrutura

```text
prisma/
├── schema.prisma
├── migrations/
└── seeds/
src/common/modules/prisma/
├── prisma.module.ts
├── services/
│   └── prisma.service.ts
├── extensions/
│   └── pagination.extension.ts
├── factories/
│   └── extended-prisma-client.factory.ts
├── interfaces/
│   └── paginate-options.interface.ts
└── types/
    └── extended-prisma-client.type.ts
src/generated/prisma/
```

- O client é gerado em `src/generated/prisma` (`provider = "prisma-client"`, `moduleFormat = "esm"`) e importado de lá.
- Use o adapter `@prisma/adapter-pg` com `DATABASE_URL` lida via `ConfigService`.

## Regras

- Use `PrismaService` apenas em services e validators.
- Use `select` por padrão; extraia para uma constante `<ENTITY>_SELECT` com `satisfies Prisma.<Entity>Select`.
- Use `include` apenas quando a relação for necessária.
- Evite N+1.
- Use `prisma.$transaction` apenas para múltiplas escritas dependentes.
- Nunca retorne o model Prisma diretamente na resposta HTTP.
- Nunca exponha campos sensíveis.
- Traduza erros do Prisma para exceções NestJS (ex.: `P2002` → `ConflictException`).

## Identificadores (UUID)

Todo model usa UUID v7 gerado pelo banco como chave primária.

```prisma
model Order {
  id         String   @id @default(dbgenerated("uuidv7()")) @db.Uuid
  customerId String   @db.Uuid
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt

  customer Customer @relation(fields: [customerId], references: [id])

  @@map("orders")
}
```

- Toda PK e toda FK usam `String @db.Uuid`.
- Toda PK usa `@default(dbgenerated("uuidv7()"))`; requer PostgreSQL 18+.
- Não use autoincrement nem `cuid()` para ids de domínio.
- Todo `id` recebido em rota passa por `ParseUUIDPipe`.
- Todo id em body ou query passa por `@IsUUID()` no DTO.
- UUID v7 é ordenável por criação, mas não use `id` como fonte de data; use `createdAt`.

## Migrations

### Regras

- Toda mudança de schema passa por migration versionada.
- Nunca altere o banco manualmente.
- Nunca edite uma migration já aplicada em ambiente compartilhado.
- Para corrigir uma migration aplicada, crie uma nova migration.
- `migrate dev` é apenas para desenvolvimento.
- `migrate deploy` é usado em CI/CD, staging e produção.
- Nunca use `migrate reset` em banco com dados reais.
- Commite `schema.prisma`, `migrations/` e `migration_lock.toml`.

### Comandos

O projeto usa `npm`. Os scripts `prisma:migrate:dev`, `prisma:migrate:deploy` e `prisma:generate` ficam no `package.json`.

```bash
npm run prisma:migrate:dev -- --name <migration_name>
npm run prisma:migrate:dev -- --create-only --name <migration_name>
npm run prisma:migrate:deploy
npx prisma migrate status
```

## Paginação

### Extensão padrão

A extensão `paginationExtension` é definida em `src/common/modules/prisma/extensions/pagination.extension.ts` e aplicada em `createExtendedPrismaClient`. Ela adiciona `paginate()` a todos os models.

```ts
import { InternalServerErrorException } from '@nestjs/common';
import { Prisma } from '../../../../generated/prisma/client.js';
import { PaginatedResult } from '../../../classes/paginated-result.class.js';
import type { PaginateOptions } from '../interfaces/paginate-options.interface.js';

interface PaginatableDelegate<TRecord> {
  findMany(args: unknown): Promise<TRecord[]>;
  count(args: unknown): Promise<number>;
}

interface WhereHolder {
  where?: unknown;
}

function isPaginatableDelegate<TRecord>(
  value: unknown,
): value is PaginatableDelegate<TRecord> {
  return (
    typeof value === 'object' &&
    value !== null &&
    'findMany' in value &&
    'count' in value
  );
}

function isWhereHolder(value: unknown): value is WhereHolder {
  return typeof value === 'object' && value !== null;
}

function buildWhere(
  where: unknown,
  search: string | undefined,
  searchFields: readonly string[] | undefined,
): unknown {
  if (!search || !searchFields?.length) {
    return where;
  }

  return {
    AND: [
      where ?? {},
      {
        OR: searchFields.map((field) => ({
          [field]: { contains: search, mode: 'insensitive' },
        })),
      },
    ],
  };
}

export const paginationExtension = Prisma.defineExtension({
  name: 'pagination',
  model: {
    $allModels: {
      async paginate<T, A>(
        this: T,
        args: Prisma.Exact<
          A,
          Omit<Prisma.Args<T, 'findMany'>, 'skip' | 'take'>
        >,
        options: PaginateOptions,
      ): Promise<PaginatedResult<Prisma.Result<T, A, 'findMany'>[number]>> {
        const { page, perPage, search, searchFields } = options;
        const delegate: unknown = Prisma.getExtensionContext(this);

        if (
          !isPaginatableDelegate<Prisma.Result<T, A, 'findMany'>[number]>(
            delegate,
          )
        ) {
          throw new InternalServerErrorException(
            'Model does not support pagination',
          );
        }

        const baseArgs: WhereHolder = isWhereHolder(args) ? args : {};
        const where = buildWhere(baseArgs.where, search, searchFields);

        const [data, totalItems] = await Promise.all([
          delegate.findMany({
            ...baseArgs,
            where,
            skip: (page - 1) * perPage,
            take: perPage,
          }),
          delegate.count({ where }),
        ]);

        const totalPages = Math.ceil(totalItems / perPage);

        return new PaginatedResult(data, {
          page,
          perPage,
          totalItems,
          totalPages,
          hasNextPage: page < totalPages,
          hasPreviousPage: page > 1,
        });
      },
    },
  },
});
```

Peças de apoio:

```ts
export interface PaginateOptions {
  page: number;
  perPage: number;
  search?: string;
  searchFields?: readonly string[];
}

export class PaginatedResult<T> {
  constructor(
    readonly data: T[],
    readonly pagination: PaginationMeta,
  ) {}
}

export function createExtendedPrismaClient(
  options: Prisma.PrismaClientOptions,
) {
  return new PrismaClient(options).$extends(paginationExtension);
}

export type ExtendedPrismaClient = ReturnType<
  typeof createExtendedPrismaClient
>;
```

`PaginationMeta` contém `page`, `perPage`, `totalItems`, `totalPages`, `hasNextPage` e `hasPreviousPage`.

### PrismaService e PrismaModule

```ts
@Injectable()
export class PrismaService extends ExtendedPrismaClientBase {
  constructor(configService: ConfigService) {
    const adapter = new PrismaPg({
      connectionString: configService.getOrThrow<string>('DATABASE_URL'),
    });

    super({ adapter });
  }
}
```

`PrismaModule` é `@Global()`, exporta `PrismaService`, executa `$connect()` e `SELECT 1` em `onModuleInit` e `$disconnect()` em `onModuleDestroy`.

### Regras

- Use `paginate()` em qualquer listagem potencialmente crescente.
- Não use `findMany` com `skip` e `take` manualmente quando `paginate()` for aplicável.
- `paginate()` aceita o mesmo `args` de `findMany`, exceto `skip` e `take`.
- `page` começa em `1`.
- `perPage` padrão é `10`; máximo é `100`.
- Use `search` apenas com `searchFields` vindos de uma constante `<ENTITY>_SEARCHABLE_FIELDS`.
- Ordenação usa `sort` e `order`, validados contra `<ENTITY>_SORTABLE_FIELDS` e `SORT_ORDERS`.
- Nunca aceite campos de busca, filtro ou ordenação arbitrários.
- O retorno é um `PaginatedResult`; o `ResponseEnvelopeInterceptor` o converte em `{ data, pagination }`.
- Para mapear os itens, retorne `new PaginatedResult(result.data.map(toResponse), result.pagination)`.

### DTO padrão

Todo DTO de listagem estende `PaginationQueryDto` (`page` e `perPage` já validados):

```ts
export class ListOrdersQueryDto extends PaginationQueryDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  search?: string;

  @IsOptional()
  @IsIn(ORDER_SORTABLE_FIELDS)
  sort: (typeof ORDER_SORTABLE_FIELDS)[number] = 'createdAt';

  @IsOptional()
  @IsIn(SORT_ORDERS)
  order: SortOrder = 'desc';
}
```

### Uso no service

```ts
return this.prismaService.order.paginate(
  {
    where: { status: query.status },
    orderBy: { [query.sort]: query.order },
    select: ORDER_SELECT,
  },
  {
    page: query.page,
    perPage: query.perPage,
    search: query.search,
    searchFields: ORDER_SEARCHABLE_FIELDS,
  },
);
```

### Resposta

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "perPage": 10,
    "totalItems": 1543,
    "totalPages": 155,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
```
