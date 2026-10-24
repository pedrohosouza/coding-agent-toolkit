# Convenções de nomenclatura

## Princípios

- Use nomes em inglês.
- Prefira nomes descritivos a abreviações.
- Um nome deve revelar intenção.
- Evite siglas, exceto as amplamente conhecidas: `API`, `URL`, `ID`, `HTTP`.
- Evite nomes genéricos: `data`, `temp`, `obj`, `handleStuff`.

## Componentes

- Use `PascalCase` para nome do componente.
- Use `PascalCase` para nome do arquivo.
- Prefixe componentes genéricos de UI com `App`, `Base` ou outro prefixo do projeto.
- Componentes de domínio podem usar o domínio como prefixo.

```text
AppButton.vue
BaseModal.vue
OrderCard.vue
OrderFilters.vue
UserProfileHeader.vue
```

## Composables

- Use `use` + domínio + ação/entidade.
- Arquivo em `camelCase`.

```text
useOrders.ts
useAuth.ts
useApiAction.ts
useListQuery.ts
useCurrentUser.ts
```

## Arquivos de contrato

| Tipo | Sufixo | Exemplo |
|---|---|---|
| Util | `*.util.ts` | `order.util.ts` |
| Types da API | `*.types.ts` | `order.types.ts` |
| Schema Zod | `*.validation.ts` | `order.validation.ts` |
| Middleware | sem sufixo | `auth.ts`, `org-admin.ts` |
| Plugin | sem sufixo | `api.ts` |

- O arquivo de middleware não leva sufixo `.middleware`: o nome do arquivo é o nome usado em `definePageMeta`.

## Páginas

- Use `kebab-case` para arquivos e pastas.
- Rotas dinâmicas usam colchetes.

```text
pages/index.vue
pages/orders/index.vue
pages/orders/[id].vue
pages/orders/new.vue
```

## Variáveis e funções

- Variáveis: `camelCase`
- Funções: `camelCase` com verbo
- Constantes globais: `UPPER_SNAKE_CASE`
- Booleanos: `is`, `has` ou `can`

```ts
const isLoading = ref(false)
const hasPermission = computed(() => Boolean(user.value))
const canSubmit = computed(() => !isLoading.value && formValid.value)

function submitForm() {}
function resetFilters() {}
```

## Tipos

- Props: `PascalCase` + `Props`
- Emits: `PascalCase` + `Emits`
- Schema Zod: `camelCase` + `Schema`
- Tipo do formulário: `PascalCase` + `Form`
- Payload enviado à API: `PascalCase` + `Payload`
- Entidade da API: nome do domínio, sem sufixo

```ts
interface OrderCardProps {}

export const orderSchema = z.object({})

export type OrderForm = z.output<typeof orderSchema>

export interface OrderPayload {}
```

## Testes

- Mesmo nome do arquivo testado + `.spec.ts` ou `.test.ts`.
- Nomeie pelo comportamento, não pela implementação.
