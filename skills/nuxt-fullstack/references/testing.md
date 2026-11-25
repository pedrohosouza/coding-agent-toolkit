# Testes

## Regras

- Três camadas: Vitest com três projects (`unit`, `nuxt`, `e2e-api`) e Playwright para fluxos de navegador.
- Importe `describe`, `it`, `expect`, `vi` e hooks de `vitest`; não habilite `globals`.
- Todo service e validator novo ou alterado tem spec unitário (`test/unit/`); todo schema Zod, util, composable e formulário novo ou alterado tem spec.
- Toda rota nova ou alterada tem spec E2E de API (`test/e2e/api/<entity-names>.e2e-spec.ts`) com Postgres real e autenticação real.
- Toda página e todo fluxo crítico (login, CRUD) novo ou alterado tem teste E2E Playwright.
- Projects: `unit` (ambiente `node`, sem Nuxt) para `shared/` e `server/services|validators|utils`; `nuxt` (ambiente `nuxt`) para composables e componentes; `e2e-api` (Node + `@nuxt/test-utils/e2e`) para a API.
- No project `unit` não há auto-imports; importe tudo explicitamente e mocke `~~/server/utils/prisma` com `vi.mock`. Globais do Nitro usados pelo código (`createError`) são stubados com `vi.stubGlobal`.
- Service spec cobre regra de negócio, `userId` da sessão e erros; validator spec cobre existência e dono (IDOR).
- Composables: intercepte `/api/*` com `registerEndpoint`, sem mockar `$fetch` nem o composable; cubra dados, erro, `validationErrors` e os toasts do `useApiAction`.
- Toasts são verificados com `mockNuxtImport('useToast', ...)`; nunca por texto no DOM.
- Componentes: monte com `mountSuspended`; teste props, emits e estados loading, empty, error e success.
- Consulte elementos por role, label ou texto visível; nunca por classe CSS ou estrutura interna do Nuxt UI.
- Schemas: um caso válido e um inválido por regra, conferindo a mensagem em português.
- O Postgres do `e2e-api` e do Playwright é um container efêmero (`@testcontainers/postgresql`, `postgres:18-alpine`); exige Docker.
- Migrations são aplicadas no container com `prisma migrate deploy`; nunca use `db push` nem `migrate dev` em teste.
- O banco é limpo antes de cada teste de API com `TRUNCATE ... RESTART IDENTITY CASCADE`, exceto `_prisma_migrations`; arquivos `e2e-api` rodam em série (`fileParallelism: false`).
- Nunca desligue o middleware de autenticação em teste; o helper cria usuário e sessão reais pelo Better Auth.
- Playwright roda contra o app real (SSR + banco real): `page.route` não intercepta chamadas feitas no servidor, então não mocke a API; prepare dados pela API autenticada e use fixtures JSON como payloads.
- Seletores Playwright usam `getByRole`, `getByLabel` e `getByText`; nunca `locator('.classe')`.
- Cada teste cria os próprios dados (factories ou fixtures) e é independente de ordem; no Playwright, cada teste usa um usuário novo.
- Variáveis de teste ficam em `.env.test`, versionado e sem segredo real, seguindo `references/configuration.md`; `NUXT_DATABASE_URL` é injetada pelo setup. `process.env` só é permitido em `test/` e em configs de teste.
- Não faça commit de `.only`, `.skip` nem `.todo`.
- Teste comportamento observável (resposta, efeito no banco, o que o usuário vê), não detalhes de implementação.
- Cobertura é reportada por `npm run test:cov`; não há threshold mínimo.

## Estrutura

```text
test/
├── unit/
│   ├── schemas/order.validation.spec.ts
│   ├── services/create-order.service.spec.ts
│   └── validators/order-exists.validator.spec.ts
├── nuxt/
│   ├── composables/useOrders.spec.ts
│   └── components/OrderFormPanel.spec.ts
├── e2e/
│   ├── api/orders.e2e-spec.ts
│   ├── orders.spec.ts
│   ├── fixtures/orders.json
│   └── support/
│       ├── fixtures.ts
│       └── start-server.ts
├── factories/order.factory.ts
├── helpers/
│   ├── create-authenticated-client.ts
│   ├── prisma.ts
│   └── reset-database.ts
└── setup/global-setup.ts
.env.test
vitest.config.ts
playwright.config.ts
```

## Comandos

| Comando              | Função                                                  |
| -------------------- | ------------------------------------------------------- |
| `npm run test`       | `vitest run --project unit --project nuxt`              |
| `npm run test:watch` | `vitest --project unit --project nuxt`                  |
| `npm run test:cov`   | `vitest run --project unit --project nuxt --coverage`   |
| `npm run test:e2e`   | `vitest run --project e2e-api && playwright test`       |

- `npm run test` não sobe Docker nem navegador.
- Rode `npm run test:e2e` quando a mudança tocar rota, schema Zod, schema Prisma, migration, página, layout, middleware ou autenticação.
- Na primeira execução do Playwright, instale o navegador com `npx playwright install chromium`.

Dependências de desenvolvimento: `vitest`, `@vitest/coverage-v8`, `@nuxt/test-utils`, `@vue/test-utils`, `happy-dom`, `@playwright/test`, `@testcontainers/postgresql` e `dotenv`.

## Configuração

Registre `@nuxt/test-utils/module` em `modules` no `nuxt.config.ts`.

`vitest.config.ts`:

```ts
import { fileURLToPath } from 'node:url'
import { defineVitestProject } from '@nuxt/test-utils/config'
import { defineConfig } from 'vitest/config'

const root = fileURLToPath(new URL('.', import.meta.url))

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      include: ['app/**/*.{ts,vue}', 'server/**/*.ts', 'shared/**/*.ts'],
      exclude: ['server/generated/**', 'shared/types/**']
    },
    projects: [
      {
        resolve: {
          alias: {
            '~': `${root}app`,
            '~~': root,
            '#shared': `${root}shared`
          }
        },
        test: {
          name: 'unit',
          include: ['test/unit/**/*.spec.ts'],
          environment: 'node'
        }
      },
      await defineVitestProject({
        test: {
          name: 'nuxt',
          include: ['test/nuxt/**/*.spec.ts'],
          environment: 'nuxt'
        }
      }),
      {
        test: {
          name: 'e2e-api',
          include: ['test/e2e/api/**/*.e2e-spec.ts'],
          globalSetup: ['test/setup/global-setup.ts'],
          setupFiles: ['dotenv/config'],
          env: { DOTENV_CONFIG_PATH: '.env.test' },
          fileParallelism: false,
          testTimeout: 30_000,
          hookTimeout: 180_000
        }
      }
    ]
  }
})
```

- Não use `defineVitestConfig` com `projects`; ele rejeita essa opção.
- `defineVitestProject` carrega `nuxt.config.ts`, auto-imports e módulos (incluindo Nuxt UI).
- `globalSetup` fica dentro do project `e2e-api`, para que `npm run test` não suba o container.
- Specs de `e2e-api` chamam `setup({ rootDir, server: true })` do `@nuxt/test-utils/e2e` (ver `templates/api.e2e-spec.ts.tpl`); isso builda e sobe o Nitro apontando para o Postgres do container.

`test/setup/global-setup.ts`:

```ts
import { execSync } from 'node:child_process'
import { PostgreSqlContainer } from '@testcontainers/postgresql'

export default async function setup() {
  const container = await new PostgreSqlContainer('postgres:18-alpine').start()
  const databaseUrl = container.getConnectionUri()

  execSync('npx prisma migrate deploy', {
    env: { ...process.env, NUXT_DATABASE_URL: databaseUrl },
    stdio: 'inherit'
  })

  process.env.NUXT_DATABASE_URL = databaseUrl

  return async () => {
    await container.stop()
  }
}
```

## Helpers e factories

`test/helpers/prisma.ts` (cliente próprio dos testes, mesmo adapter da aplicação):

```ts
import { PrismaPg } from '@prisma/adapter-pg'
import { PrismaClient } from '../../server/generated/prisma/client'

export const testPrisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: process.env.NUXT_DATABASE_URL })
})
```

`test/helpers/reset-database.ts`:

```ts
import { testPrisma } from './prisma'

export async function resetDatabase() {
  const tables = await testPrisma.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public' AND tablename <> '_prisma_migrations'
  `

  if (tables.length === 0) {
    return
  }

  const names = tables.map(({ tablename }) => `"public"."${tablename}"`)

  await testPrisma.$executeRawUnsafe(
    `TRUNCATE TABLE ${names.join(', ')} RESTART IDENTITY CASCADE`
  )
}
```

`test/helpers/create-authenticated-client.ts`:

```ts
import { fetch } from '@nuxt/test-utils/e2e'

interface RequestOptions {
  method?: string
  body?: unknown
}

export async function createAuthenticatedClient() {
  const response = await fetch('/api/auth/sign-up/email', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      name: 'Test User',
      email: `user-${crypto.randomUUID()}@example.com`,
      password: 'Test-password-123'
    })
  })
  const signUp = await response.json()
  const cookie = response.headers
    .getSetCookie()
    .map((value) => value.split(';')[0])
    .join('; ')

  async function request(path: string, options: RequestOptions = {}) {
    const result = await fetch(path, {
      method: options.method,
      headers: { cookie, 'content-type': 'application/json' },
      body: options.body ? JSON.stringify(options.body) : undefined
    })
    const text = await result.text()

    return { status: result.status, body: text ? JSON.parse(text) : null }
  }

  return { userId: signUp.user.id as string, request }
}
```

- O `request` guarda o cookie de sessão; para testar IDOR, crie dois clients e acesse, com o segundo, um recurso do primeiro (espera `404`).
- Se o projeto exigir verificação de e-mail, conclua-a pelo banco antes de usar o client.
- Em `.env.test`, use limites altos de rate limit para não bloquear sign-ups seguidos.
- Factories (`test/factories/<entity-name>.factory.ts`) criam o registro direto pelo `testPrisma`, recebem `userId` e `overrides` parciais; dados únicos usam `crypto.randomUUID()`.

## Spec de schema, service e validator

- Funções puras e classes em `test/unit/`; sem Nuxt, sem DOM, sem banco.
- Um `it` por regra ou comportamento, nomeado em inglês pelo resultado (`rejects a name shorter than 3 characters`).
- Valide a chamada ao Prisma (`where`, `data`) apenas quando ela for o comportamento relevante, como filtro por `userId`.
- Veja `templates/validation.spec.ts.tpl`, `templates/create-service.spec.ts.tpl` e `templates/exists-validator.spec.ts.tpl`.

## Spec de composable e componente

- Registre os endpoints antes de chamar o composable: `registerEndpoint('/api/orders', ...)`.
- Aguarde a leitura com `vi.waitFor` ou `flushPromises`.
- Mutação: registre o endpoint com `method`, verifique o corpo recebido, o toast de sucesso e a recarga da lista.
- Erro: responda com o envelope `{ error: { code, message, details } }` e status 4xx; verifique o toast de erro e `validationErrors`.
- Componentes: preencha os campos, dispare o submit e confira o payload emitido; campos inválidos não emitem e exibem a mensagem do schema.
- Veja `templates/composable.spec.ts.tpl` e `templates/form.spec.ts.tpl`.

## Spec E2E de API

- Um `describe` por rota (`GET /api/orders`), com os casos de sucesso e de erro.
- Cubra status code, envelope, `400` de validação com `details`, `401` sem sessão, `404` de IDOR (recurso de outro usuário) e paginação.
- Veja `templates/api.e2e-spec.ts.tpl` e `templates/factory.ts.tpl`.

## Playwright

`playwright.config.ts`:

```ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './test/e2e',
  testMatch: '*.spec.ts',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  reporter: process.env.CI ? 'github' : 'list',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry'
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  webServer: {
    command: 'node test/e2e/support/start-server.ts',
    url: 'http://localhost:3000/api/health/liveness',
    reuseExistingServer: !process.env.CI,
    timeout: 240_000
  }
})
```

`test/e2e/support/start-server.ts` sobe o Postgres efêmero, aplica as migrations e inicia o app com o banco de teste; encerra ambos no `SIGTERM`/`SIGINT`:

```ts
import { execSync, spawn } from 'node:child_process'
import { PostgreSqlContainer } from '@testcontainers/postgresql'

const container = await new PostgreSqlContainer('postgres:18-alpine').start()
const env = {
  ...process.env,
  NUXT_DATABASE_URL: container.getConnectionUri()
}

execSync('npx prisma migrate deploy', { env, stdio: 'inherit' })

const server = spawn('npm', ['run', 'dev'], { env, stdio: 'inherit' })

async function stop() {
  server.kill()
  await container.stop()
  process.exit(0)
}

process.on('SIGTERM', stop)
process.on('SIGINT', stop)
```

`test/e2e/support/fixtures.ts` (fixture de página autenticada, com usuário novo por teste):

```ts
import { test as base, type Page } from '@playwright/test'

export const test = base.extend<{ authenticatedPage: Page }>({
  authenticatedPage: async ({ page }, use) => {
    await page.request.post('/api/auth/sign-up/email', {
      data: {
        name: 'Test User',
        email: `user-${crypto.randomUUID()}@example.com`,
        password: 'Test-password-123'
      }
    })

    await use(page)
  }
})

export { expect } from '@playwright/test'
```

- `page.request` compartilha os cookies do contexto: depois do sign-up, o navegador já navega autenticado.
- Só Chromium por padrão; novos navegadores entram por decisão explícita.
- Textos e roles verificados devem ser os da página real; ajuste os do template ao que a tela exibe.
- Cubra por tela o caminho feliz, o estado vazio e o redirect sem sessão; mutações verificam o toast de sucesso e o dado na lista.
- `.prettierignore`, `.gitignore` e o ESLint ignoram `coverage`, `playwright-report` e `test-results`.
- Veja `templates/e2e.spec.ts.tpl` e `templates/e2e-fixture.json.tpl`.
