# Cliente HTTP e contrato com o backend

## Princípios

- Existe um único cliente HTTP: o `$api`, criado em `app/plugins/api.ts` com `$fetch.create` e provido via `provide`.
- Toda comunicação com a API passa por `$api`.
- Componentes e páginas não usam `$api`; o acesso fica em composables.
- O plugin só cria o cliente; chamadas de domínio (`/orders`) ficam nos composables, nunca em `plugins/`.
- Não existe `server/`, Nitro nem `/api/*` interno: a API é externa.

## Plugin `$api`

```ts
import type { $Fetch } from 'ofetch'
import type { ApiErrorBody } from '~/types/api.types'

export default defineNuxtPlugin(() => {
  const config = useRuntimeConfig()
  const api = $fetch.create({
    baseURL: `${config.public.apiBaseUrl}/api`,
    credentials: 'include',
    onResponseError({ response }) {
      const body = response._data as ApiErrorBody | undefined
      const route = useRoute()

      if (response.status === 401 && !route.path.startsWith('/auth')) {
        void navigateTo({
          path: '/auth/login',
          query: { redirect: route.fullPath }
        })
      }

      throw createError({
        statusCode: response.status,
        statusMessage:
          body?.error?.message ?? 'Não foi possível comunicar com a API.',
        data: body?.error
      })
    }
  })

  return {
    provide: {
      api: api as $Fetch
    }
  }
})
```

O plugin centraliza:

- `baseURL`: `apiBaseUrl` do `runtimeConfig` + `/api` (o backend usa `setGlobalPrefix('api')`).
- `credentials: 'include'`: o backend autentica por cookie e o CORS dele libera apenas a origem do frontend com credenciais.
- Headers comuns de contexto, quando a API exigir.
- Redirecionamento para login no `401`.
- Normalização de erro: todo erro vira `createError` com `statusCode` e `data` igual ao objeto `error` do envelope.

## Contrato com o backend

O backend responde sempre com um envelope. Os tipos ficam em `app/types/api.types.ts`:

```ts
export interface Pagination {
  page: number
  perPage: number
  totalItems: number
  totalPages: number
  hasNextPage: boolean
  hasPreviousPage: boolean
}

export interface ApiResponse<T> {
  data: T
}

export interface ApiListResponse<T> {
  data: T[]
  pagination: Pagination
}

export interface ApiValidationDetail {
  field: string
  issue: string
}

export interface ApiErrorBody {
  error?: {
    code?: string
    message?: string
    details?: ApiValidationDetail[]
  }
}

export interface ListQuery {
  page: number
  perPage: number
  search?: string
  sort?: string
  order?: 'asc' | 'desc'
  [filter: string]: string | number | boolean | undefined
}
```

| Backend | Frontend |
|---|---|
| `{ data }` | `$api<ApiResponse<T>>` |
| `{ data: [], pagination }` | `$api<ApiListResponse<T>>` |
| `{ error: { code, message, details? } }` | `ApiErrorBody`, lido via `getApiErrorCode`, `getApiErrorMessage` e `mapValidationDetails` |
| Query `page`, `perPage`, `search`, `sort`, `order` | `ListQuery`, gerenciado por `useListQuery` |
| IDs UUID | `string` |
| `204` sem corpo | `$api(...)` sem tipo de retorno |

- Tipifique toda chamada com o tipo do envelope.
- Datas chegam como string ISO; decimais chegam como string.
- `perPage` máximo é `100`; nunca peça mais.
- O frontend não valida regra de negócio; o backend é a fonte final.

## Tratamento de erro

Os utilitários ficam em `app/utils/api-error.util.ts`:

- `getApiErrorCode(error)`: lê `error.data.code`.
- `getApiErrorMessage(error, fallback?)`: devolve mensagem em português por código (`ERROR_MESSAGES`), depois `data.message` e por fim o fallback.
- `mapValidationDetails(error)`: converte `details` (`{ field, issue }`) em `{ name, message }` para `UForm`.

| Status | Código | Comportamento |
|---|---|---|
| `400` | `VALIDATION_ERROR` | Erros por campo no formulário via `mapValidationDetails` |
| `401` | `UNAUTHORIZED` | Redirect para login (plugin) |
| `403` | `FORBIDDEN` | Toast de permissão |
| `404` | `NOT_FOUND` | Estado de erro ou toast |
| `409` | `CONFLICT` | Toast com mensagem específica do contexto |
| `422` | `UNPROCESSABLE_ENTITY` | Toast com a mensagem da API |
| `429` | `TOO_MANY_REQUESTS` | Toast pedindo para aguardar; respeite `Retry-After` |
| `500` | `INTERNAL_SERVER_ERROR` | Toast genérico, sem detalhes internos |
| `503` | `SERVICE_UNAVAILABLE` | Toast de indisponibilidade |

## Regras

- Mapeie todo código de erro novo da API em `ERROR_MESSAGES`, em português.
- Nunca trate erro de API como erro silencioso (ver `feedback.md`).
- Use retry com backoff apenas para leituras idempotentes e erros transitórios; nunca para mutações.
- Trate `429` respeitando `Retry-After`.
- Não exponha detalhes internos da API ao usuário.
- Não declare URL da API no código; ela vem de `runtimeConfig.public.apiBaseUrl` (ver `configuration.md`).
