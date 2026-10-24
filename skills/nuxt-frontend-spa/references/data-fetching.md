# Data fetching

A aplicação é SPA: toda requisição roda no navegador, contra a API externa, via `$api`.

## Escolha da API

| Cenário | Como |
|---|---|
| Leitura ligada à página (listagem, detalhe) | `useAsyncData` + `$api`, dentro de um composable |
| Múltiplas chamadas, transformação ou controle fino | `useAsyncData` compondo `$api` |
| Ação disparada pelo usuário (criar, editar, excluir, enviar) | `$api` dentro de `useApiAction` |

## Regras

- Leituras e mutações vivem em composables; páginas e componentes só consomem o retorno.
- Use sempre `$api`; nunca `$fetch` cru nem `useFetch('/api/...')`.
- Use uma chave estável e única em `useAsyncData`.
- Reaja a mudanças de filtro com `watch: [query]`.
- Sempre trate `pending`, `error` e dados vazios.
- Após mutação, atualize com `refresh()` via `useApiAction(refresh)`.
- Não copie dados de servidor para estado cliente sem necessidade.
- Para paginação, envie `page` e `perPage` e guarde-os na query da rota com `useListQuery`.
- Tipifique a resposta com `ApiListResponse<T>` ou `ApiResponse<T>`.
- Não use `import.meta.server`, `process.server` nem lógica de SSR.

## Exemplo

Composable:

```ts
import type { ApiListResponse } from '~/types/api.types'
import type { OrderPayload } from '~/schemas/order.validation'
import type { Order } from '~/types/order.types'

export function useOrders() {
  const { $api } = useNuxtApp()
  const { query, searchInput, setPage } = useListQuery([], {
    defaults: { sort: 'createdAt', order: 'desc' }
  })

  const { data, error, pending, refresh } = useAsyncData(
    'orders',
    () => $api<ApiListResponse<Order>>('/orders', { query: query.value }),
    { watch: [query] }
  )

  const items = computed(() => data.value?.data ?? [])
  const pagination = computed(() => data.value?.pagination)
  const { run, running, validationErrors } = useApiAction(refresh)

  function create(input: OrderPayload) {
    return run(() => $api('/orders', { method: 'POST', body: input }), {
      success: 'Pedido criado',
      failure: 'Não foi possível criar o pedido'
    })
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

Página:

```vue
<script setup lang="ts">
const { error, items, pending, refresh } = useOrders()
</script>

<template>
  <main>
    <USkeleton v-if="pending" class="h-64 w-full" />

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
