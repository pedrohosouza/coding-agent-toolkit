# Testes

## Regras

- Testes unitários e de componentes usam Vitest com `@nuxt/test-utils`; testes E2E usam Playwright.
- Importe `describe`, `it`, `expect`, `vi` e hooks de `vitest`; não habilite `globals`.
- Todo schema Zod, util, composable e componente de formulário novo ou alterado tem spec.
- Toda página de listagem e todo fluxo crítico (login, CRUD) novo ou alterado tem teste E2E.
- Dois projects do Vitest: `unit` (ambiente `node`, `test/unit/`) para `schemas/` e `utils/`; `nuxt` (ambiente `nuxt`, `test/nuxt/`) para composables e componentes.
- Composables: o `$api` é interceptado com `registerEndpoint`, sem mockar o `$api` em si; cubra dados, erro, `validationErrors` e os toasts do `useApiAction`.
- Em testes, `runtimeConfig.public.apiBaseUrl` é vazio, para que o `$api` chame `/api/*` no app h3 em memória do `registerEndpoint`.
- Toasts são verificados com `mockNuxtImport('useToast', ...)`; nunca por texto no DOM.
- Componentes: monte com `mountSuspended`; teste props, emits e estados loading, empty, error e success.
- Consulte elementos por role, label ou texto visível; nunca por classe CSS, id gerado ou estrutura interna do Nuxt UI.
- Schemas: um caso válido e um inválido por regra, conferindo a mensagem em português.
- E2E mocka a API com `page.route('**/api/**')`, com fixtures em `test/e2e/fixtures/`; nenhum E2E depende de backend real.
- Seletores E2E usam `getByRole`, `getByLabel` e `getByText`; nunca `locator('.classe')`.
- Cada teste é independente e prepara os próprios mocks; nenhum depende de ordem.
- Não faça commit de `.only`, `.skip` nem `.todo`.
- Teste comportamento observável (o que o usuário vê e faz), não detalhes de implementação.
- Cobertura é reportada por `npm run test:cov`; não há threshold mínimo.

## Estrutura

```text
test/
├── unit/
│   ├── schemas/
│   │   └── order.validation.spec.ts
│   └── utils/
│       └── order.util.spec.ts
├── nuxt/
│   ├── composables/
│   │   └── useOrders.spec.ts
│   └── components/
│       └── OrderFormPanel.spec.ts
└── e2e/
    ├── orders.spec.ts
    └── fixtures/
        └── orders.json
vitest.config.ts
playwright.config.ts
```

## Comandos

| Comando              | Função                  |
| -------------------- | ----------------------- |
| `npm run test`       | `vitest run`            |
| `npm run test:watch` | `vitest`                |
| `npm run test:cov`   | `vitest run --coverage` |
| `npm run test:e2e`   | `playwright test`       |

- `npm run test` não abre navegador nem sobe servidor.
- Rode `npm run test:e2e` quando a mudança tocar página, layout, middleware, fluxo de autenticação ou formulário.
- Na primeira execução do E2E, instale o navegador com `npx playwright install chromium`.

Dependências de desenvolvimento: `vitest`, `@vitest/coverage-v8`, `@nuxt/test-utils`, `@vue/test-utils`, `happy-dom` e `@playwright/test`.

## Configuração

`vitest.config.ts`:

```ts
import { fileURLToPath } from 'node:url'
import { defineVitestProject } from '@nuxt/test-utils/config'
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      include: ['app/**/*.{ts,vue}'],
      exclude: ['app/types/**']
    },
    projects: [
      {
        resolve: {
          alias: { '~': fileURLToPath(new URL('./app', import.meta.url)) }
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
          environment: 'nuxt',
          environmentOptions: {
            nuxt: {
              overrides: {
                runtimeConfig: { public: { apiBaseUrl: '' } }
              }
            }
          }
        }
      })
    ]
  }
})
```

- Não use `defineVitestConfig` com `projects`; ele rejeita essa opção.
- `defineVitestProject` já carrega o `nuxt.config.ts`, os auto-imports e os módulos (incluindo Nuxt UI).
- Registre `@nuxt/test-utils/module` em `modules` no `nuxt.config.ts`.
- O project `unit` não carrega o Nuxt: ele não tem auto-imports e resolve `~` pelo `alias` acima; importe tudo explicitamente (`import { orderSchema } from '~/schemas/order.validation'`).

`playwright.config.ts`:

```ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './test/e2e',
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
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI
  }
})
```

- Só Chromium por padrão; novos navegadores entram por decisão explícita.
- `process.env` é permitido apenas em `playwright.config.ts` e em `test/`.
- `.prettierignore` e `.gitignore` incluem `coverage`, `playwright-report` e `test-results`; o ESLint ignora os mesmos diretórios.
- Confirme que o `npm run typecheck` cobre os specs. Se não cobrir, inclua `../test/**/*` em `typescript.tsConfig.include` no `nuxt.config.ts`; não desative a checagem.

## Spec de schema e util

- Funções puras em `test/unit/`; sem Nuxt, sem DOM.
- Um `it` por regra, nomeado em inglês pelo resultado (`rejects a name shorter than 3 characters`).
- Veja `templates/validation.spec.ts.tpl`.

## Spec de composable

- Registre os endpoints antes de chamar o composable: `registerEndpoint('/api/orders', ...)`.
- Aguarde a leitura com `vi.waitFor` ou `flushPromises`.
- Para mutação, registre o endpoint com `method` e verifique o corpo recebido, o toast de sucesso e a recarga da lista.
- Para erro, responda com o envelope de erro da API (`{ error: { code, message, details } }`) e um status 4xx; verifique o toast de erro e `validationErrors`.
- Veja `templates/composable.spec.ts.tpl`.

## Spec de componente

- Use `mountSuspended`; passe props reais e verifique `wrapper.emitted()`.
- Formulários: preencha os campos, dispare o submit e confira o payload emitido; campos inválidos não emitem e exibem a mensagem do schema.
- Estados: monte com `loading`, lista vazia e erro, e confira o que o usuário vê (skeleton, mensagem de vazio, alerta).
- Veja `templates/form.spec.ts.tpl`.

## Teste E2E

- Textos e roles verificados (vazio, erro, títulos) devem ser os da página real; ajuste os do template ao que a tela exibe.
- Cada teste registra os mocks da API no início: sessão (`**/api/auth/get-session`) e dados da tela.
- Cubra o caminho feliz, o estado vazio e um erro de API por tela.
- Mutações verificam o toast de sucesso e a nova requisição da lista.
- Veja `templates/e2e.spec.ts.tpl`.
