---
name: nuxt-fullstack
description: Aplica os padrões obrigatórios do projeto ao criar, alterar ou revisar aplicações Nuxt full stack (SSR, Nitro como backend no mesmo app) com Prisma, Better Auth e Nuxt UI. Cobre estrutura de pastas, nomenclatura, rotas Nitro em server/api, services por use case, validators, validação Zod, respostas padronizadas, autenticação, autorização por recurso e por organização, Prisma (UUID v7, migrations, paginação, seeds, busca normalizada), rate limiting, health checks, graceful shutdown, config e variáveis de ambiente, páginas, componentes, composables, formulários, data fetching SSR, toasts, estados de UI, acessibilidade, responsividade, temas, páginas de erro, formatação, lint, testes (Vitest, @nuxt/test-utils, Playwright) e Docker. Use SEMPRE que a tarefa envolver rota de API, service, schema Prisma, migration, seed, Better Auth, página, componente, composable, formulário, middleware, teste, variável de ambiente ou deploy em um app Nuxt full stack.
---

# Padrões Nuxt Full Stack + Prisma + Better Auth + Nuxt UI

Estas regras se aplicam a qualquer rota, service, tela, componente ou fluxo novo ou alterado em um app Nuxt que serve frontend e API no mesmo projeto.

## Stack padrão

- Nuxt com Vue 3 e `<script setup lang="ts">`; SSR ligado (padrão do Nuxt).
- Nitro como backend, em `server/`.
- Prisma com PostgreSQL.
- Better Auth para autenticação (e-mail e senha, Google e plugin Organization quando aplicável).
- Nuxt UI como biblioteca de componentes; Tailwind CSS via Nuxt UI.
- Zod para validação de entrada (servidor) e de formulários (cliente), com schemas compartilhados.
- TypeScript strict; dark mode suportado por padrão.
- Gerenciador de pacotes: `npm`.
- Testes: Vitest (unit e services), `@nuxt/test-utils` (componentes e composables) e Playwright (E2E).
- Formatação segue o Prettier do projeto; o padrão é sem ponto e vírgula, aspas simples e sem trailing comma.

## Arquitetura

- Rotas em `server/api/` são finas: validam entrada com Zod, exigem sessão, chamam um service e devolvem o envelope.
- Cada responsabilidade de negócio é um service isolado em `server/services/<domain>/`, que representa um use case com uma única responsabilidade.
- O método público principal de um service é `execute()`.
- Existência de recurso é verificada em validators reutilizáveis (`server/validators/<entity>-exists.validator.ts`).
- Services usam o cliente Prisma único de `server/utils/prisma.ts`.
- Não crie services genéricos que acumulem responsabilidades; divida-os.
- Código transversal do servidor fica em `server/utils/`, `server/plugins/` e `server/middleware/`.
- Schemas Zod e types usados pelos dois lados ficam em `shared/`.
- Páginas apenas orquestram rota, layout e composables.
- Componentes reutilizáveis ficam em `app/components/`.
- Lógica, estado e acesso à API ficam em composables (`app/composables/`); componentes e páginas nunca chamam `$fetch` nem `useFetch` diretamente.
- Leitura de dados usa `useFetch`/`useAsyncData` dentro de composables; mutação usa `useApiAction`.
- Estado de servidor não é duplicado em estado cliente.

## Regras universais (servidor)

- Use Better Auth para autenticação.
- Nunca acesse `process.env` no código de aplicação; use `useRuntimeConfig()`.
- Toda variável de ambiente é validada no boot por um plugin Nitro com Zod.
- Segredos ficam apenas em `runtimeConfig` privado; nunca em `runtimeConfig.public`.
- `.env` e `.env.example`: variáveis do app primeiro (`NODE_ENV`, `PORT`), depois grupos por prefixo, com linha em branco entre os grupos; veja `references/configuration.md`.
- Toda rota `/api/*` é autenticada por padrão por um middleware de servidor; rotas públicas entram explicitamente na allowlist.
- Autorização é verificada por recurso, prevenindo IDOR/BOLA; nunca aceite `userId` do body.
- Valide toda entrada externa (body, query, params e headers) pela camada `server/utils/validation.ts`, com schemas Zod estritos que rejeitam campos desconhecidos.
- Use respostas consistentes para recurso, lista paginada e erro (envelope `{ data }`, `{ data, pagination }`, `{ error }`).
- Nunca retorne `200` para erro.
- Sanitize e restrinja a saída com `select`; nunca exponha modelos Prisma, hashes, tokens ou segredos.
- Toda PK e FK é UUID v7 gerado pelo banco (`@db.Uuid`, `uuidv7()`); todo `:id` de rota é validado como UUID.
- Listagens usam paginação padronizada com `page`/`perPage` (máximo `100`), `search`, `sort` e `order`.
- Busca textual que deve ignorar acentos usa coluna `normalized*` e `normalizeText()`; veja `references/search.md`.
- Seeds ficam em `prisma/seeds/`, são idempotentes e têm um arquivo por entidade.
- Health check expõe `liveness` e `readiness`; todo serviço de que o app depende tem indicador no readiness.
- Toda mudança de schema passa por migration versionada.
- O código deve ser explicativo por si só: nomes claros e funções pequenas; não escreva comentários.

## Regras universais (frontend)

- Use `<script setup lang="ts">` em todos os componentes e tipifique props, emits, modelos e retornos de composables.
- Nuxt UI é a fonte padrão de componentes; use props antes de slots, slots antes de `ui`, e `ui` antes de classes Tailwind.
- Customização repetida fica em `app.config.ts`; tokens de marca ficam em CSS variables.
- Trate sempre loading, empty, error e success; use skeletons em vez de spinners para conteúdo.
- Toda ação tem feedback visível (loading, toast de sucesso e toast de erro); nenhuma falha é silenciosa.
- Toda mutação passa por `useApiAction`; erros por campo vêm de `validationErrors`.
- Previna double-submit em ações assíncronas.
- Garanta navegação por teclado, foco visível e contraste adequado.
- Derive cores, espaçamento e tipografia de design tokens; nada de valores hardcoded.
- Middleware de rota melhora a navegação; a autorização real é sempre do servidor.
- Código compatível com SSR: nada de `window`/`document` fora de `onMounted` ou `import.meta.client`; estado compartilhado via `useState`.
- Textos exibidos ao usuário em português; código, nomes e comentários em inglês.

## Regras universais (qualidade)

- Todo service e validator novo ou alterado tem spec unitário (Vitest); toda rota nova ou alterada tem spec E2E de API com Postgres real; todo schema, util, composable e formulário novo ou alterado tem spec; toda página ou fluxo crítico novo ou alterado tem teste E2E (Playwright); veja `references/testing.md`.
- Antes de concluir, `npm run format`, `npm run lint`, `npm run typecheck` e `npm run test` devem passar sem erro ou warning; rode também `npm run test:e2e` quando a mudança tocar rota, DTO/schema Zod, schema Prisma, migration, página, layout, middleware ou autenticação; veja `references/formatting-linting.md` e `references/testing.md`.
- Use `camelCase` para variáveis, funções e propriedades; `PascalCase` para classes, interfaces, types, enums e componentes; `kebab-case` para arquivos e pastas (exceto componentes `.vue` em PascalCase e composables `useX.ts`); `UPPER_SNAKE_CASE` para constantes globais e variáveis de ambiente.

## Roteamento de referências

Leia apenas a referência necessária para a tarefa:

- Estrutura de pastas: `references/folder-structure.md`
- Nomenclatura e sufixos: `references/naming-conventions.md`
- Configuração, `runtimeConfig` e variáveis de ambiente: `references/configuration.md`
- Autenticação, autorização, Better Auth no servidor, middleware de sessão, Organization e IDOR: `references/authentication-authorization.md`
- Better Auth no cliente, `useAuth`, middleware de rota e redirects SSR: `references/auth-client.md`
- Rotas Nitro (`server/api/`), validação de entrada e services: `references/api-routes.md`
- Respostas padronizadas, erros e error handler: `references/responses.md`
- Camada de validação de entrada (helpers, schemas Zod estritos, params, query, headers): `references/validation.md`
- Validação de relacionamentos e FKs: `references/relationships.md`
- Sanitização e `select`: `references/sanitization.md`
- Prisma, UUIDs, migrations, queries, paginação e transações: `references/prisma.md`
- Busca sem acento (`normalizedName`, `normalizeText`): `references/search.md`
- Seeds (`prisma/seeds/`, `prisma db seed`): `references/seeds.md`
- Rate limiting: `references/rate-limiting.md`
- Health checks e readiness: `references/health-checks.md`
- Graceful shutdown: `references/graceful-shutdown.md`
- Leitura de dados SSR (`useFetch`, `useAsyncData`) e mutações: `references/data-fetching.md`
- Formulários e validação no cliente: `references/forms.md`
- Componentes Vue e Nuxt UI: `references/components.md`
- Composables e estado: `references/composables.md`
- Loading, empty, error e success: `references/ui-states.md`
- Toasts e feedback ao usuário: `references/feedback.md`
- Middleware de rota: `references/middleware.md`
- Acessibilidade: `references/accessibility.md`
- Responsividade: `references/responsive-design.md`
- Imagens, vídeos e assets: `references/assets.md`
- Tema, tokens e dark mode: `references/theming.md`
- Páginas de erro: `references/error-pages.md`
- Formatação, lint e typecheck (portão de qualidade): `references/formatting-linting.md`
- Testes (Vitest, `@nuxt/test-utils`, Testcontainers, Playwright, factories): `references/testing.md`
- Docker, Dockerfile, docker-compose e deploy: `references/docker-deployment.md`

## Não fazer

- Não desligue o SSR (`ssr: false`) nem use `import.meta.server`/`process.server` para contornar problema de hidratação; corrija a causa.
- Não crie lógica de negócio dentro de rota ou componente.
- Não chame `$fetch`/`useFetch` em componentes ou páginas; use composables.
- Não exponha modelo Prisma, hash, token ou segredo na resposta nem no payload SSR (`useState`, `useFetch`).
- Não aceite `userId` ou `organizationId` do body como identidade; use a sessão.
- Não confie em role, permissão ou dado do navegador como autorização.
- Não use `$queryRawUnsafe` nem concatene SQL; use Prisma ou `Prisma.sql`.
- Não guarde segredo em `runtimeConfig.public`.
- Não dispare mutação sem feedback.

## Templates

Ao criar rotas, services, telas e contratos, use os templates em `templates/` e adapte-os ao domínio. Cada template vira um arquivo no destino indicado.

Infraestrutura compartilhada (crie uma vez, se o projeto ainda não tiver):

| Template                         | Destino                              |
| -------------------------------- | ------------------------------------ |
| `prisma.util.ts.tpl`             | `server/utils/prisma.ts`             |
| `response.util.ts.tpl`           | `server/utils/response.ts`           |
| `pagination.util.ts.tpl`         | `server/utils/pagination.ts`         |
| `normalize-text.util.ts.tpl`     | `server/utils/normalize-text.ts`     |
| `validation.util.ts.tpl`         | `server/utils/validation.ts`         |
| `common.validation.ts.tpl`       | `shared/schemas/common.validation.ts` |
| `auth.util.ts.tpl`               | `server/utils/auth.ts`               |
| `require-session.util.ts.tpl`    | `server/utils/require-session.ts`    |
| `auth.handler.ts.tpl`            | `server/api/auth/[...all].ts`        |
| `auth.middleware.ts.tpl`         | `server/middleware/auth.ts`          |
| `rate-limit.middleware.ts.tpl`   | `server/middleware/rate-limit.ts`    |
| `env.plugin.ts.tpl`              | `server/plugins/env.ts`              |
| `error-handler.plugin.ts.tpl`    | `server/plugins/error-handler.ts`    |
| `shutdown.plugin.ts.tpl`         | `server/plugins/shutdown.ts`         |
| `health-liveness.get.ts.tpl`     | `server/api/health/liveness.get.ts`  |
| `health-readiness.get.ts.tpl`    | `server/api/health/readiness.get.ts` |
| `api.types.ts.tpl`               | `shared/types/api.types.ts`          |
| `api-error.util.ts.tpl`          | `app/utils/api-error.util.ts`        |
| `auth-error.util.ts.tpl`         | `app/utils/auth-error.util.ts`       |
| `auth-client.plugin.ts.tpl`      | `app/plugins/auth-client.ts`         |
| `use-auth.ts.tpl`                | `app/composables/useAuth.ts`         |
| `use-api-action.ts.tpl`          | `app/composables/useApiAction.ts`    |
| `use-list-query.ts.tpl`          | `app/composables/useListQuery.ts`    |
| `middleware.ts.tpl`              | `app/middleware/<name>.ts`           |

Por entidade:

| Template                            | Destino                                                  |
| ----------------------------------- | -------------------------------------------------------- |
| `route-list.get.ts.tpl`             | `server/api/<entity-names>/index.get.ts`                 |
| `route-create.post.ts.tpl`          | `server/api/<entity-names>/index.post.ts`                |
| `route-get.get.ts.tpl`              | `server/api/<entity-names>/[id].get.ts`                  |
| `route-update.patch.ts.tpl`         | `server/api/<entity-names>/[id].patch.ts`                |
| `route-delete.delete.ts.tpl`        | `server/api/<entity-names>/[id].delete.ts`               |
| `create-service.ts.tpl`             | `server/services/<entity-names>/create-<entity-name>.service.ts` |
| `get-service.ts.tpl`                | `server/services/<entity-names>/get-<entity-name>.service.ts`    |
| `list-service.ts.tpl`               | `server/services/<entity-names>/list-<entity-names>.service.ts`  |
| `update-service.ts.tpl`             | `server/services/<entity-names>/update-<entity-name>.service.ts` |
| `delete-service.ts.tpl`             | `server/services/<entity-names>/delete-<entity-name>.service.ts` |
| `exists-validator.ts.tpl`           | `server/validators/<entity-name>-exists.validator.ts`    |
| `select.constant.ts.tpl`            | `server/constants/<entity-name>-select.constant.ts`      |
| `searchable-fields.constant.ts.tpl` | `server/constants/<entity-name>-searchable-fields.constant.ts` |
| `sortable-fields.constant.ts.tpl`   | `server/constants/<entity-name>-sortable-fields.constant.ts`   |
| `validation.ts.tpl`                 | `shared/schemas/<entity-name>.validation.ts`             |
| `types.ts.tpl`                      | `shared/types/<entity-name>.types.ts`                    |
| `composable.ts.tpl`                 | `app/composables/use<EntityNames>.ts`                    |
| `form.vue.tpl`                      | `app/components/<entity-name>/<EntityName>FormPanel.vue` |
| `component.vue.tpl`                 | `app/components/<entity-name>/<Component>.vue`           |
| `page.vue.tpl`                      | `app/pages/<entity-names>/index.vue`                     |
| `seed.ts.tpl`                       | `prisma/seeds/<entity-names>.seed.ts`                    |
| `validation.spec.ts.tpl`            | `test/unit/schemas/<entity-name>.validation.spec.ts`     |
| `validation.util.spec.ts.tpl`       | `test/unit/utils/validation.spec.ts` (uma vez)           |
| `create-service.spec.ts.tpl`        | `test/unit/services/create-<entity-name>.service.spec.ts` |
| `exists-validator.spec.ts.tpl`      | `test/unit/validators/<entity-name>-exists.validator.spec.ts` |
| `composable.spec.ts.tpl`            | `test/nuxt/composables/use<EntityNames>.spec.ts`         |
| `form.spec.ts.tpl`                  | `test/nuxt/components/<EntityName>FormPanel.spec.ts`     |
| `api.e2e-spec.ts.tpl`               | `test/e2e/api/<entity-names>.e2e-spec.ts`                |
| `factory.ts.tpl`                    | `test/factories/<entity-name>.factory.ts`                |
| `e2e.spec.ts.tpl`                   | `test/e2e/<entity-names>.spec.ts`                        |
| `e2e-fixture.json.tpl`              | `test/e2e/fixtures/<entity-names>.json`                  |

Substitua os placeholders (exemplo para a entidade `Order`):

| Placeholder        | Formato                                                             | Exemplo  |
| ------------------ | ------------------------------------------------------------------- | -------- |
| `{{EntityName}}`   | PascalCase, singular                                                | `Order`  |
| `{{entityName}}`   | camelCase, singular; também é o delegate do Prisma (`prisma.order`) | `order`  |
| `{{entity-name}}`  | kebab-case, singular                                                | `order`  |
| `{{ENTITY_NAME}}`  | UPPER_SNAKE_CASE, singular                                          | `ORDER`  |
| `{{EntityNames}}`  | PascalCase, plural                                                  | `Orders` |
| `{{entity-names}}` | kebab-case, plural (também é a rota da API)                         | `orders` |

- O model Prisma deve se chamar `{{EntityName}}`, para que `prisma.{{entityName}}` exista.
- O plural é usado na rota, no service de listagem, no composable e na página; o singular, no restante.
- O `list-service.ts.tpl` não normaliza a busca; quando a entidade exigir busca sem acento, siga `references/search.md`.
- Os demais services (`get`, `list`, `update`, `delete`) seguem o formato do `create-service.spec.ts.tpl`; escreva um spec para cada um.

Não crie arquivos ou métodos vazios. Remova o que não for necessário.
