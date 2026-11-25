# Respostas padronizadas

Toda resposta da API segue um envelope único. Services retornam o dado puro; a rota aplica o envelope com `respond()` e `respondPaginated()`.

## Recurso específico

```json
{ "data": { "id": "0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77", "name": "Example" } }
```

## Lista paginada

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "perPage": 10,
    "totalItems": 1543,
    "totalPages": 155,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
```

## Erro

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [{ "field": "email", "issue": "Invalid email address" }]
  }
}
```

## Componentes

```text
shared/types/api.types.ts
server/utils/response.ts
server/plugins/error-handler.ts
```

- `shared/types/api.types.ts`: `ApiResponse<T>`, `PaginatedApiResponse<T>`, `Pagination`, `ApiErrorDetail` e `ApiErrorResponse`; usados pelo servidor e pelo cliente.
- `server/utils/response.ts`: `respond(data)` retorna `{ data }`; `respondPaginated(result)` retorna `{ data, pagination }`.
- `server/plugins/error-handler.ts`: converte todo erro de `/api/*` em `ApiErrorResponse`.

## Error handler

- O plugin substitui `nitroApp.h3App.options.onError` apenas para `/api/*`; as demais rotas mantêm o handler padrão do Nuxt (páginas de erro SSR).
- Erro de validação (`error.data.details`, gerado por `server/utils/validation.ts`): `400`, `code: 'VALIDATION_ERROR'`, `message: 'Validation failed'` e `details` em `{ field, issue }`; campos aninhados usam caminho com ponto (`items.0.quantity`).
- Erro com `createError`: usa `statusCode` e `message`; `code` vem de `HTTP_ERROR_CODES[status]`.
- Erro do Prisma: `P2002` vira `409 CONFLICT`; `P2025` vira `404 NOT_FOUND`; outros viram `500`.
- Erro `5xx` (exceto `503`): mensagem fixa `Internal server error`, sem stack trace nem detalhe do banco.
- Todo status novo usado pela API entra em `HTTP_ERROR_CODES`.

## Regras

- Rotas e services nunca montam `{ data }` manualmente; use os helpers.
- Listagens retornam o resultado de `paginate()` e nunca montam `pagination` à mão.
- Nunca retorne `200` com erro no corpo.
- Lance `createError`; nunca `new Error()` para erro esperado.
- `200` leitura e atualização; `201` criação; `204` deleção sem corpo.
- `400` requisição malformada e validação; `401` não autenticado; `403` sem permissão; `404` inexistente; `409` conflito; `413` payload grande; `422` regra semântica violada; `429` rate limit; `500` erro interno; `503` readiness indisponível.
