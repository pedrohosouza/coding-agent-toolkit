# Data fetching

A aplicação é SSR: a primeira renderização busca os dados no servidor, serializa no payload e hidrata no cliente. A API é o Nitro do próprio app, em `/api/*`, na mesma origem.

## Escolha da API

| Cenário | Como |
|---|---|
| Leitura ligada à página (listagem, detalhe) | `useFetch` dentro de um composable |
| Múltiplas chamadas, transformação ou controle fino | `useAsyncData` compondo `$fetch` |
| Ação do usuário (criar, editar, excluir, enviar) | `$fetch` dentro de `useApiAction` |

## Regras

- Leituras e mutações vivem em composables; páginas e componentes só consomem o retorno.
- Leitura usa `useFetch`/`useAsyncData`; mutação usa `$fetch` executado por `useApiAction`. Nunca use `$fetch` para ler dados de renderização: ele busca duas vezes (servidor e cliente).
- Use URL relativa `/api/...`; não há `baseURL`, `credentials` nem plugin de cliente HTTP.
- Use chave estável e única (`key: 'orders-list'`).
- Passe `query` como `computed`/`ref`: o `useFetch` observa e refaz a busca quando muda; use `watch` em `useAsyncData`.
- Durante o SSR, o `useFetch` repassa os cookies da requisição às rotas internas; um `$fetch` direto no servidor não repassa, então use `useRequestFetch()` nesse caso.
- Não precisa de `await` no `useFetch` dentro do composable; o Nuxt espera os dados antes de renderizar no servidor.
- Sempre trate `pending`, `error` e dados vazios; no SSR o `pending` já vem resolvido, então o skeleton aparece em navegações no cliente.
- Após mutação, atualize com `refresh()` via `useApiAction(refresh)`.
- Não copie dados de servidor para estado cliente; não retorne modelo Prisma nem segredo, pois tudo vai para o payload SSR.
- Para paginação, envie `page` e `perPage` e guarde-os na query da rota com `useListQuery`.
- Tipifique a resposta com `PaginatedApiResponse<T>` ou `ApiResponse<T>` (`shared/types/api.types.ts`).
- Datas chegam como string ISO; `perPage` máximo é `100`.
- Erros chegam como `{ data: { error: { code, message, details } } }`; leia-os com `getApiErrorCode`, `getApiErrorMessage` e `mapValidationDetails`.

## Exemplo

Composable:

```ts
import type { CreateOrderInput } from '#shared/schemas/order.validation'
import type { PaginatedApiResponse } from '#shared/types/api.types'
import type { Order } from '#shared/types/order.types'

export function useOrders() {
  const { query, searchInput, setPage } = useListQuery([], {
    defaults: { sort: 'createdAt', order: 'desc' }
  })

  const { data, error, pending, refresh } = useFetch<
    PaginatedApiResponse<Order>
  >('/api/orders', { key: 'orders-list', query })

  const items = computed(() => data.value?.data ?? [])
  const pagination = computed(() => data.value?.pagination)
  const { run, running, validationErrors } = useApiAction(refresh)

  function create(input: CreateOrderInput) {
    return run(
      () => $fetch('/api/orders', { method: 'POST', body: input }),
      {
        success: 'Pedido criado',
        failure: 'Não foi possível criar o pedido'
      }
    )
  }

  return {
    create,
    error,
    items,
    pagination,
    pending,
    refresh,
    running,
    searchInput,
    setPage,
    validationErrors
  }
}
```

Detalhe por id (chave depende do parâmetro):

```ts
export function useOrder(id: MaybeRefOrGetter<string>) {
  return useFetch<ApiResponse<Order>>(() => `/api/orders/${toValue(id)}`, {
    key: () => `order-${toValue(id)}`
  })
}
```

Página:

```vue
<script setup lang="ts">
const { error, items, pending, refresh } = useOrders()
</script>

<template>
  <main>
    <USkeleton v-if="pending && items.length === 0" class="h-64 w-full" />

    <UAlert
      v-else-if="error"
      color="error"
      title="Não foi possível carregar os pedidos"
      :actions="[{ label: 'Tentar novamente', onClick: () => refresh() }]"
    />

    <UAlert
      v-else-if="items.length === 0"
      color="neutral"
      title="Nenhum pedido encontrado"
    />

    <OrderTable v-else :orders="items" />
  </main>
</template>
```
