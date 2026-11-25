# Convenções de nomenclatura

## Princípios

- Use nomes em inglês.
- Prefira nomes descritivos a abreviações; evite siglas, exceto `API`, `URL`, `ID`, `JWT`, `HTTP`.
- Um nome revela intenção, não tipo ou implementação.
- Evite nomes genéricos: `data`, `temp`, `obj`, `handleStuff`.

## Formato por tipo

| Item | Formato | Exemplo |
|---|---|---|
| Variável, função, propriedade | `camelCase` | `currentUser` |
| Classe, interface, type, enum | `PascalCase`, sem `I` | `CreateOrderService` |
| Constante global | `UPPER_SNAKE_CASE` | `MAX_PER_PAGE` |
| Arquivo e pasta | `kebab-case` | `create-order.service.ts` |
| Componente `.vue` | `PascalCase` | `OrderFormPanel.vue` |
| Composable | `useX.ts` | `useOrders.ts` |
| Variável de ambiente | `UPPER_SNAKE_CASE` | `NUXT_DATABASE_URL` |
| Chave de `runtimeConfig` | `camelCase` | `databaseUrl` |

## Arquivos do servidor

```text
server/api/orders/index.get.ts
server/api/orders/[id].patch.ts
server/services/orders/create-order.service.ts
server/validators/order-exists.validator.ts
server/constants/order-select.constant.ts
server/utils/require-session.ts
shared/schemas/order.validation.ts
```

- Rotas Nitro seguem `<nome>.<método>.ts`; o método é o sufixo (`get`, `post`, `patch`, `delete`).
- Pastas ficam no plural por responsabilidade; o nome de domínio em `api/` e `services/` é o plural da entidade.

## Services / use cases

- Um service representa um use case, com uma única responsabilidade; método público principal `execute()`.
- Nomeie com verbo + entidade + `Service`.

| Responsabilidade | Classe | Arquivo |
|---|---|---|
| Criar pedido | `CreateOrderService` | `create-order.service.ts` |
| Obter pedido | `GetOrderService` | `get-order.service.ts` |
| Listar pedidos | `ListOrdersService` | `list-orders.service.ts` |
| Atualizar pedido | `UpdateOrderService` | `update-order.service.ts` |
| Excluir pedido | `DeleteOrderService` | `delete-order.service.ts` |
| Cancelar pedido | `CancelOrderService` | `cancel-order.service.ts` |

- Evite `OrderService`, `OrderHelper`, `OrderManager`, `ProcessData`.

## Validators, constantes e schemas

- Validator: `<Entity>ExistsValidator` em `<entity>-exists.validator.ts`.
- Constantes: `ORDER_SELECT`, `ORDER_SEARCHABLE_FIELDS`, `ORDER_SORTABLE_FIELDS`.
- Schemas Zod: `createOrderSchema`, `updateOrderSchema`, `listOrdersQuerySchema`.
- Types inferidos: `CreateOrderInput`, `UpdateOrderInput`, `ListOrdersQuery`.

## Funções e booleanos

- Funções começam com verbo: `calculateOrderTotal()`, `resolveLimit()`.
- Booleanos usam `is`, `has`, `can`: `isLoading`, `hasPermission`, `canCancel`.
- Rotas e handlers não levam nome ligado ao HTTP dentro dos services (`postOrder`); use a operação (`create`).
