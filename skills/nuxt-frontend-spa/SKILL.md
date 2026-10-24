---
name: nuxt-frontend-spa
description: Aplica os padrões obrigatórios do projeto ao criar, alterar ou revisar aplicações Nuxt SPA (ssr false, sem backend próprio) com Nuxt UI. Cobre estrutura de pastas, sufixos de arquivo, nomenclatura, componentes, composables, páginas, layouts, middleware de rota, types da API, schemas Zod, formulários, cliente HTTP $api e contrato com o backend, data fetching, config e variáveis de ambiente, toasts e feedback ao usuário, estados de UI, acessibilidade, responsividade, imagens, temas, dark mode e páginas de erro. Use SEMPRE que a tarefa envolver página, componente, composable, formulário, middleware, schema, type, chamada à API, toast, variável de ambiente ou estilo no frontend.
---

# Padrões Nuxt SPA + Nuxt UI

Estas regras se aplicam a qualquer tela, componente ou fluxo Nuxt novo ou alterado.

## Stack padrão

- Nuxt com Vue 3 e `<script setup lang="ts">`.
- SPA exclusivamente client-side (`ssr: false`); o backend é uma API externa.
- Nuxt UI como biblioteca padrão de componentes.
- TypeScript strict.
- Zod para validação de formulários e contratos de entrada.
- Tailwind CSS via Nuxt UI para estilização.
- Dark mode suportado por padrão.
- Gerenciador de pacotes: `npm`.
- Formatação segue o Prettier do projeto; o padrão é sem ponto e vírgula, aspas simples e sem trailing comma.

## Arquitetura

- Páginas apenas orquestram rota, layout e composables.
- Componentes reutilizáveis ficam em `components/`.
- Lógica, estado e acesso à API ficam em composables.
- O cliente HTTP é o `$api`, criado em `plugins/api.ts`; só composables o usam.
- Componentes e páginas nunca chamam a API diretamente.
- Contratos da API ficam em `types/`, schemas de formulário em `schemas/` e guards de rota em `middleware/`.
- Estado de servidor não é duplicado em estado cliente.
- Um componente tem uma responsabilidade clara.

## Estilo e componentes

- Nuxt UI é a fonte padrão de componentes.
- Prefira componente Nuxt UI antes de HTML puro.
- Identifique a categoria da UI antes de escolher o componente.
- Consulte a documentação do Nuxt UI quando houver dúvida sobre o componente adequado.
- Use props antes de slots, slots antes de `ui`, e `ui` antes de classes Tailwind.
- Use o menor número possível de classes Tailwind.
- Classes Tailwind são permitidas apenas para layout ou ajuste que o componente não cobre.
- Customização repetida fica em `app.config.ts`.
- Tokens de marca ficam em CSS variables.
- Não reconstrua controles interativos com HTML puro quando houver componente Nuxt UI equivalente.
- Não force um componente Nuxt UI quando ele não representar o padrão necessário.

## Hierarquia de decisão

1. Existe componente Nuxt UI para esse padrão de UI?
   - Sim: use o componente.
   - Não: use HTML semântico.

2. O componente precisa de customização?
   - Use props primeiro: `color`, `variant`, `size`, `loading`, `disabled`, `icon`.
   - Depois use slots.
   - Depois use a prop `ui` para ajuste local.
   - Para padrão repetido, mova para `app.config.ts`.

3. É necessário Tailwind?
   - Use o mínimo possível.
   - Use apenas para layout ou ajuste que o componente não cobre.
   - Não reconstrua visual, acessibilidade ou comportamento já entregues pelo Nuxt UI.

## HTML semântico

- Use tags semânticas para estrutura da página: `main`, `header`, `nav`, `section`, `article`, `footer`.
- Use headings em hierarquia coerente.
- Componentes Nuxt UI já entregam acessibilidade, ARIA, navegação por teclado e gerenciamento de foco; o HTML semântico os complementa, não os substitui.

## Regras universais

- Use `<script setup lang="ts">` em todos os componentes.
- Tipifique props, emits, modelos e retornos de composables.
- Garanta navegação por teclado, foco visível e contraste adequado.
- Trate sempre loading, empty, error e success.
- Toda ação tem feedback visível (loading, toast de sucesso e toast de erro); nenhuma falha é silenciosa.
- Toda mutação passa por `useApiAction`, sem exceção; erros por campo vêm de `validationErrors`.
- Textos exibidos ao usuário em português; código, nomes e comentários em inglês.
- Nunca acesse `process.env`; configuração vem de `runtimeConfig.public` com `NUXT_PUBLIC_*`.
- Nunca guarde segredo no frontend.
- Use skeletons em vez de spinners para carregamento de conteúdo.
- Previna double-submit em ações assíncronas.
- Use unidades relativas e breakpoints derivados de design tokens.
- Prefira imagens responsivas, lazy loading e dimensões explícitas.
- Derive cores, espaçamento e tipografia de design tokens.
- Não use cores, espaçamentos, raios ou fontes hardcoded.

## Roteamento de referências

Leia apenas a referência necessária:

- Estrutura de pastas e sufixos: `references/folder-structure.md`
- Nomenclatura: `references/naming-conventions.md`
- Types, schemas e utils: `references/types-schemas.md`
- Middleware de rota e autenticação na navegação: `references/middleware.md`
- Config e variáveis de ambiente: `references/configuration.md`
- Toasts e feedback ao usuário: `references/feedback.md`
- Componentes Vue e Nuxt UI: `references/components.md`
- Composables e estado: `references/composables.md`
- Leitura e mutação de dados (`useAsyncData`, `$api`): `references/data-fetching.md`
- Formulários e validação: `references/forms.md`
- Loading, empty, error e success: `references/ui-states.md`
- Cliente HTTP `$api` e contrato com o backend: `references/api-client.md`
- Acessibilidade: `references/accessibility.md`
- Responsividade: `references/responsive-design.md`
- Imagens, vídeos e assets: `references/assets.md`
- Tema, tokens e dark mode: `references/theming.md`
- Páginas de erro: `references/error-pages.md`

## Não fazer (SPA)

- Não crie o diretório `server/`, Server Routes, Server Middleware nem Nitro plugins.
- Não crie endpoints em `server/api/` nem chame `/api/*` interno.
- Não use `import.meta.server`, `process.server` nem lógica dependente de SSR.
- Não altere `ssr: false`.
- Não use `useFetch` nem `$fetch` cru para a API; use `$api` em composables.
- Não dispare mutação sem feedback.
- Não trate role, permissão ou dado do navegador como autorização; a validação real é do backend.

## Templates

Ao criar telas, composables, formulários e contratos, use os templates em `templates/` e adapte-os ao domínio. Cada template vira um arquivo na pasta indicada:

| Template | Destino |
|---|---|
| `api.plugin.ts.tpl` | `plugins/api.ts` |
| `api.types.ts.tpl` | `types/api.types.ts` |
| `api-error.util.ts.tpl` | `utils/api-error.util.ts` |
| `use-api-action.ts.tpl` | `composables/useApiAction.ts` |
| `use-list-query.ts.tpl` | `composables/useListQuery.ts` |
| `auth-client.plugin.ts.tpl` | `plugins/auth-client.ts` |
| `use-auth.ts.tpl` | `composables/useAuth.ts` |
| `auth-error.util.ts.tpl` | `utils/auth-error.util.ts` |
| `middleware.ts.tpl` | `middleware/<name>.ts` |
| `types.ts.tpl` | `types/<entity-name>.types.ts` |
| `validation.ts.tpl` | `schemas/<entity-name>.validation.ts` |
| `composable.ts.tpl` | `composables/use<EntityNames>.ts` |
| `form.vue.tpl` | `components/<entity-name>/<EntityName>FormPanel.vue` |
| `component.vue.tpl` | `components/<entity-name>/<Component>.vue` |
| `page.vue.tpl` | `pages/<entity-names>/index.vue` |

Os oito primeiros são a infraestrutura compartilhada; crie-os uma vez, se o projeto ainda não os tiver.

Substitua os placeholders (exemplo para a entidade `Order`):

| Placeholder | Formato | Exemplo |
|---|---|---|
| `{{EntityName}}` | PascalCase, singular | `Order` |
| `{{entityName}}` | camelCase, singular | `order` |
| `{{entity-name}}` | kebab-case, singular | `order` |
| `{{EntityNames}}` | PascalCase, plural | `Orders` |
| `{{entity-names}}` | kebab-case, plural (também é a rota da API) | `orders` |

Não crie arquivos ou métodos vazios. Remova o que não for necessário.
