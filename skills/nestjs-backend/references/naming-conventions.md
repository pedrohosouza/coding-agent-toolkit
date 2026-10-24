# Convenções de nomenclatura

## Princípios

- Use nomes em inglês.
- Prefira nomes descritivos a abreviações.
- Evite siglas, exceto as amplamente conhecidas: `API`, `URL`, `ID`, `JWT`, `HTTP`.
- Um nome deve revelar intenção, não tipo ou implementação.
- Evite prefixos técnicos desnecessários, como `IUser`, `UserData` ou `DataUser`.
- Evite nomes genéricos: `data`, `temp`, `obj`, `result2`, `handleStuff`.

## Formato por tipo

| Item | Formato | Exemplo |
|---|---|---|
| Variável | `camelCase` | `currentUser` |
| Função/método | `camelCase` com verbo | `createOrder` |
| Classe | `PascalCase` | `CreateOrderService` |
| Interface | `PascalCase`, sem `I` | `PaginateOptions` |
| Validator | `PascalCase` + `Validator` | `OrderExistsValidator` |
| Type | `PascalCase` | `OrderStatus` |
| Enum | `PascalCase` | `OrderStatus` |
| Constante global | `UPPER_SNAKE_CASE` | `MAX_PAGE_LIMIT` |
| Arquivo/pasta | `kebab-case` | `create-order.service.ts` |
| Variável de ambiente | `UPPER_SNAKE_CASE` | `DATABASE_URL` |

## Arquivos

Use sufixo de camada no nome do arquivo:

```text
orders.module.ts
orders.controller.ts
create-order.service.ts
create-order.dto.ts
jwt-auth.guard.ts
http-exception.filter.ts
response-envelope.interceptor.ts
order-exists.validator.ts
```

Pastas usam `kebab-case` e ficam no plural por responsabilidade:

```text
controllers/
dtos/
services/
validators/
```

## Services / use cases

- Um service representa um use case.
- Um service tem uma única responsabilidade.
- O método público principal é `execute()`.
- Nomeie pelo verbo + entidade + `Service`.

| Responsabilidade | Classe | Arquivo |
|---|---|---|
| Criar pedido | `CreateOrderService` | `create-order.service.ts` |
| Obter pedido (deve existir) | `GetOrderService` | `get-order.service.ts` |
| Listar pedidos | `ListOrdersService` | `list-orders.service.ts` |
| Atualizar pedido | `UpdateOrderService` | `update-order.service.ts` |
| Excluir pedido | `DeleteOrderService` | `delete-order.service.ts` |
| Cancelar pedido | `CancelOrderService` | `cancel-order.service.ts` |
| Aprovar pagamento | `ApprovePaymentService` | `approve-payment.service.ts` |

Evite:

```text
OrderService
OrderHelper
OrderManager
HandleOrder
ProcessData
```

## Controllers

Nomeie pelo recurso no plural:

```text
OrdersController
UsersController
PaymentsController
```

Métodos devem expressar a operação:

```ts
list()
get()
create()
update()
delete()
cancel()
```

Evite nomes ligados ao HTTP:

```ts
postOrder()
getOrders()
deleteOrder()
```

## DTOs

Use a operação + entidade + `Dto`:

```text
CreateOrderDto
UpdateOrderDto
ListOrdersQueryDto
LoginDto
RefreshTokenDto
```

Propriedades usam `camelCase`:

```ts
export class CreateOrderDto {
  customerId!: string;
  totalAmount!: number;
  items!: CreateOrderItemDto[];
}
```

## Variáveis

Use substantivos claros:

```ts
const currentUser = await this.findCurrentUser.execute(userId);
const activeOrders = await this.prisma.order.findMany({
  where: { status: 'ACTIVE' },
});
const orderTotal = items.reduce((total, item) => total + item.price, 0);
```

Evite:

```ts
const u = await getUser();
const arr = await getOrders();
const x = calculate();
```

## Funções e métodos

Comece com verbo:

```ts
calculateOrderTotal()
validateCustomerExists()
mapOrderToResponse()
sendPaymentConfirmation()
```

Para funções que retornam booleano, use:

```ts
isActive()
hasPermission()
canCancelOrder()
isEmailAvailable()
```

## Booleanos

Use prefixos semânticos:

```ts
const isLoading = false;
const hasPermission = true;
const canCancel = order.status === 'PENDING';
const isEmailVerified = user.emailVerifiedAt !== null;
```

## Constantes

Use `UPPER_SNAKE_CASE` para constantes globais ou de módulo:

```ts
const MAX_PAGE_LIMIT = 100;
const DEFAULT_PAGE_LIMIT = 10;
const JWT_EXPIRES_IN = '15m';
```

## Enums

Use `PascalCase` para o enum e valores descritivos:

```ts
export enum OrderStatus {
  Pending = 'PENDING',
  Paid = 'PAID',
  Canceled = 'CANCELED',
}
```
