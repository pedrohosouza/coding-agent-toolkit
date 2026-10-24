# Estrutura de pastas

## Princípios

- A aplicação é uma SPA (`ssr: false`); não existe `server/`, Nitro nem `server/api/`.
- Organize por domínio/feature.
- Componentes reutilizáveis ficam em `components/`.
- Lógica, estado e acesso à API ficam em `composables/`.
- Páginas ficam em `pages/`; layouts em `layouts/`.
- Guards de rota ficam em `middleware/`.
- Instâncias globais (cliente HTTP, auth client) ficam em `plugins/`.
- Contratos da API ficam em `types/`; schemas de formulário em `schemas/`.
- Funções puras ficam em `utils/`.
- Configuração global fica em `app.config.ts` e `nuxt.config.ts`.

## Estrutura base

```text
app/
├── assets/
│   └── css/
│       └── main.css
├── components/
│   ├── app/
│   └── order/
├── composables/
│   ├── useApiAction.ts
│   ├── useAuth.ts
│   ├── useListQuery.ts
│   └── useOrders.ts
├── layouts/
│   ├── default.vue
│   └── session.vue
├── middleware/
│   ├── auth.ts
│   └── guest.ts
├── pages/
│   ├── index.vue
│   ├── auth/
│   │   └── login.vue
│   └── orders/
│       ├── index.vue
│       └── [id].vue
├── plugins/
│   ├── api.ts
│   └── auth-client.ts
├── schemas/
│   └── order.validation.ts
├── types/
│   ├── api.types.ts
│   └── order.types.ts
├── utils/
│   ├── api-error.util.ts
│   └── order.util.ts
├── app.config.ts
├── app.vue
└── error.vue
```

## Sufixos

| Pasta | Arquivo | Exemplo |
|---|---|---|
| `components/` | `PascalCase.vue` | `OrderFormModal.vue` |
| `composables/` | `use*.ts` | `useOrders.ts` |
| `middleware/` | `kebab-case.ts` | `auth.ts` |
| `plugins/` | `kebab-case.ts` | `api.ts` |
| `schemas/` | `*.validation.ts` | `order.validation.ts` |
| `types/` | `*.types.ts` | `order.types.ts` |
| `utils/` | `*.util.ts` | `order.util.ts` |
| `pages/` | `kebab-case.vue` | `orders/index.vue` |

## Regras

- Componentes de domínio ficam em uma pasta do domínio, no singular: `components/order/`.
- Componentes genéricos ficam em `components/app/`.
- Um domínio tem no máximo um arquivo por pasta de contrato: `types/order.types.ts`, `schemas/order.validation.ts`, `utils/order.util.ts`.
- Composables em subpasta precisam ser cobertos por `imports.dirs` ou reexportados.
- Plugins só instanciam clientes; não contêm chamadas de domínio.
- Não coloque regra de negócio do backend no frontend.
- Não coloque regra complexa dentro de componentes.
- Não duplique lógica entre páginas e componentes.
- Não crie pastas vazias por precaução.

## Dependências

- `page` → `composable` → `$api`
- `page` e `component` não usam `$api` diretamente
- `component` recebe props e emite eventos; quem chama a API é o composable da página
- `composable` usa `useAsyncData` para leitura e `$api` com `useApiAction` para mutação
- `middleware` usa composables de sessão, nunca `$api` direto
- `types/` não importa de `schemas/`
- `common` ou `shared` não é o padrão deste projeto; use `app/` e pastas por responsabilidade
