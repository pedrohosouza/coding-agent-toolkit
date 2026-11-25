# Seeds

## Regras

- Seeds ficam em `prisma/seeds/`, na raiz do projeto; nunca em `server/`.
- Um arquivo por entidade: `<entity-names>.seed.ts`, exportando `seed<EntityNames>` do tipo `Seed`.
- `prisma/seeds/index.ts` é o único entrypoint: cria o `PrismaClient` com `@prisma/adapter-pg`, executa os seeds em ordem e faz `$disconnect()` em `finally`.
- Seeds são idempotentes: `createMany` com `skipDuplicates: true` ou `upsert`.
- Dados volumosos ficam em `prisma/seeds/data/<entity-names>.json`; não busque dados externos durante o seed.
- O seed carrega o `.env` com `process.loadEnvFile()` do Node, só se o arquivo existir; não use `dotenv`.
- O seed lê `NUXT_DATABASE_URL` e falha explicitamente se ela não existir; roda fora do Nitro, então não usa `useRuntimeConfig()`.
- O seed pode importar funções puras de `server/utils/` (como `normalizeText`), pelo caminho relativo; nunca importa services nem utils que dependam do Nitro.
- Colunas derivadas (ex.: `normalizedName`) são calculadas no seed com a mesma função da aplicação.
- Entidades com dono (`userId`) precisam de um usuário existente; semeie o usuário antes ou receba o id por parâmetro.

## Estrutura

```text
prisma/seeds/
├── index.ts
├── <entity-names>.seed.ts
├── data/
│   └── <entity-names>.json
└── types/
    └── seed.type.ts
```

## Configuração

`prisma.config.ts`:

```ts
export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
    seed: 'tsx prisma/seeds/index.ts'
  }
})
```

`package.json`: `"prisma:seed": "prisma db seed"`.

## Tipo

```ts
import type { PrismaClient } from '../../server/generated/prisma/client'

export type Seed = (prisma: PrismaClient) => Promise<void>
```

## Entrypoint

```ts
import { existsSync } from 'node:fs'
import { PrismaPg } from '@prisma/adapter-pg'
import { PrismaClient } from '../../server/generated/prisma/client'
import { seedOrders } from './orders.seed'
import type { Seed } from './types/seed.type'

if (existsSync('.env')) {
  process.loadEnvFile()
}

const SEEDS: { name: string; run: Seed }[] = [{ name: 'orders', run: seedOrders }]

async function main(): Promise<void> {
  const connectionString = process.env.NUXT_DATABASE_URL

  if (!connectionString) {
    throw new Error('NUXT_DATABASE_URL is not set')
  }

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) })

  try {
    for (const seed of SEEDS) {
      console.log(`seeding ${seed.name}...`)
      await seed.run(prisma)
    }
  } finally {
    await prisma.$disconnect()
  }
}

main().catch((error: unknown) => {
  console.error(error)
  process.exitCode = 1
})
```

- Ao criar um seed novo, adicione-o a `SEEDS` respeitando a ordem de dependência (FK).
- `tsx` deve estar no `package.json`.

## Template

`seed.ts.tpl`.
