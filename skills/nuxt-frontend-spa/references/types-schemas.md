# Types, schemas e utils

## Onde fica cada coisa

| Pasta | Sufixo | Conteúdo |
|---|---|---|
| `app/types/` | `*.types.ts` | Contratos que espelham a API (entidades, envelope, queries) |
| `app/schemas/` | `*.validation.ts` | Schemas Zod de formulário, tipo do formulário e payload enviado |
| `app/utils/` | `*.util.ts` | Funções puras, auto-importadas, sem estado |
| `app/composables/` | `use*.ts` | Lógica, estado e acesso à API |
| `app/middleware/` | sem sufixo (`auth.ts`) | Guards de rota (ver `middleware.md`) |
| `app/plugins/` | sem sufixo (`api.ts`) | Instâncias globais (cliente HTTP, auth client) |

- Um domínio tem um arquivo em cada pasta: `types/order.types.ts`, `schemas/order.validation.ts`, `utils/order.util.ts`.
- Um arquivo por domínio; não crie `types.ts` genérico.

## Types

- Descrevem exatamente o que a API devolve; não inclua campos calculados no cliente.
- Use `interface` para objetos e `type` para uniões e utilitários.
- IDs são `string`; datas e decimais são `string`, como chegam da API.
- Reaproveite com `Pick` e `Omit` em vez de duplicar campos.
- Envelope, paginação e erro ficam em `api.types.ts`.
- Não importe de `schemas/` em `types/`.

```ts
import type { OrderStatus } from '~/utils/order.util'

export interface Order {
  id: string
  status: OrderStatus
  totalAmount: string
  customer: { id: string; name: string }
  createdAt: string
  updatedAt: string
}
```

## Schemas

- Todo formulário tem um schema Zod em `schemas/<domain>.validation.ts`.
- Mensagens de erro em português.
- Aplique `trim()` em strings e limites que espelham o backend (`max`, `regex`).
- Exporte três coisas por schema: `<entity>Schema`, `<Entity>Form` e `<Entity>Payload`.
- `<Entity>Form` é `z.output<typeof schema>`.
- `<Entity>Payload` é o corpo enviado à API; pode diferir do formulário.
- O schema valida a experiência do usuário; a validação final é do backend.

```ts
import { z } from 'zod'

export const orderSchema = z.object({
  name: z.string().trim().min(3, 'Use ao menos 3 caracteres.')
})

export type OrderForm = z.output<typeof orderSchema>

export interface OrderPayload {
  name: string
}
```

## Utils

- Funções puras, sem `ref` nem acesso a `useNuxtApp`.
- Constantes de domínio (status, rótulos) ficam no util do domínio.
- Nomes com verbo: `formatCurrency`, `getOrderStatusLabel`.
- `api-error.util.ts` concentra a leitura de erros da API.
