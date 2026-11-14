# Seeds

## Regras

- Seeds ficam em `prisma/seeds/`, na raiz do projeto; nunca em `src/`.
- Um arquivo por entidade: `<entity-names>.seed.ts`, exportando `seed<EntityNames>` do tipo `Seed`.
- `prisma/seeds/index.ts` é o único entrypoint: cria o `PrismaClient` com `@prisma/adapter-pg`, executa os seeds em ordem e faz `$disconnect()` em `finally`.
- Seeds são idempotentes: rodar duas vezes não duplica nem falha (`createMany` com `skipDuplicates: true` ou `upsert`).
- Dados volumosos ficam versionados em `prisma/seeds/data/<entity-names>.json`; não busque dados em serviços externos durante o seed.
- O seed carrega o `.env` com `process.loadEnvFile()` nativo do Node, apenas se o arquivo existir; não use `dotenv`.
- O seed lê `DATABASE_URL` e falha explicitamente se ela não existir; é a única exceção à regra de não acessar `process.env`, pois roda fora do Nest.
- O seed pode importar `src/utils/` (funções puras, como `normalizeText`) para garantir o mesmo tratamento dos dados que a aplicação aplica.
- Seed não importa services, módulos Nest nem `ConfigService`.
- Colunas derivadas (ex.: `normalizedName`) são calculadas no seed com a mesma função usada pela aplicação.
- Migration que adiciona coluna `NOT NULL` em tabela populada por seed pode usar `TRUNCATE`, desde que o seed seja reexecutado depois; registre isso no commit.

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
    seed: 'tsx prisma/seeds/index.ts',
  },
});
```

`package.json`:

```json
"prisma:seed": "prisma db seed"
```

## Tipo

```ts
import type { PrismaClient } from '../../../src/generated/prisma/client.js';

export type Seed = (prisma: PrismaClient) => Promise<void>;
```

## Seed de entidade

```ts
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { normalizeText } from '../../src/utils/normalize-text.util.js';
import type { Seed } from './types/seed.type.js';

interface CitySeedRecord {
  ibgeCode: number;
  name: string;
  stateCode: string;
  latitude: number;
  longitude: number;
}

const CITIES_DATA_PATH = join(import.meta.dirname, 'data', 'cities.json');

function readCities(): CitySeedRecord[] {
  return JSON.parse(
    readFileSync(CITIES_DATA_PATH, 'utf-8'),
  ) as CitySeedRecord[];
}

export const seedCities: Seed = async (prisma) => {
  const data = readCities().map((city) => ({
    ...city,
    normalizedName: normalizeText(city.name),
  }));

  const { count } = await prisma.city.createMany({
    data,
    skipDuplicates: true,
  });

  console.log(`cities: ${count} inserted, ${data.length - count} skipped`);
};
```

## Entrypoint

```ts
import { existsSync } from 'node:fs';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../../src/generated/prisma/client.js';
import { seedCities } from './cities.seed.js';
import type { Seed } from './types/seed.type.js';

if (existsSync('.env')) {
  process.loadEnvFile();
}

interface NamedSeed {
  name: string;
  run: Seed;
}

const SEEDS: NamedSeed[] = [{ name: 'cities', run: seedCities }];

async function main(): Promise<void> {
  const connectionString = process.env.DATABASE_URL;

  if (!connectionString) {
    throw new Error('DATABASE_URL is not set');
  }

  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString }),
  });

  try {
    for (const seed of SEEDS) {
      console.log(`seeding ${seed.name}...`);
      await seed.run(prisma);
    }
    console.log('seeding finished');
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
```

- Ao criar um seed novo, adicione-o à lista `SEEDS` respeitando a ordem de dependência entre entidades (FK).
- `tsx` deve estar declarado no `package.json`; `dotenv` não é usado.
