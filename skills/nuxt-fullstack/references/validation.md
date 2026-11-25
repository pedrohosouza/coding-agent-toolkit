# Validação de entrada

Equivale ao `ValidationPipe` global + DTOs do NestJS: toda entrada externa passa por uma camada única, na borda, antes de qualquer lógica.

## Camadas

| NestJS                                   | Nuxt full stack                                                          |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| DTO com `class-validator`                | Schema Zod em `shared/schemas/<entity-name>.validation.ts`               |
| `ValidationPipe` (`whitelist`, `forbidNonWhitelisted`, `transform`) | `server/utils/validation.ts` + `z.strictObject` + `z.coerce`/`trim` |
| `ParseUUIDPipe`                          | `idParamsSchema` (`z.uuid()`) em `shared/schemas/common.validation.ts`   |
| `PaginationQueryDto`                     | `paginationQueryShape` em `common.validation.ts`                         |
| Filtro de exceção                        | `server/plugins/error-handler.ts` (`400 VALIDATION_ERROR`)               |

## Regras

- Todo input externo passa por schema Zod: body, query, params e headers.
- Valide somente com os helpers de `server/utils/validation.ts`: `validateBody`, `validateQuery`, `validateParams` e `validateHeaders`.
- Nunca use `getQuery`, `readBody`, `getRouterParam` nem `getHeader` sem validar.
- Não valide na rota com `schema.parse` direto; o helper garante o formato do erro.
- Valide na borda, antes de `requireSession` e do service; não valide dentro do service.
- Body, query e params usam `z.strictObject`: campo desconhecido é rejeitado (`whitelist` + `forbidNonWhitelisted`), e allowlist, nunca blocklist.
- Headers usam `z.object` (não estrito), pois o request sempre traz headers que você não controla; declare apenas os que a rota exige.
- Todo `:id` de rota usa `idParamsSchema`; todo identificador em body, query ou header usa `z.uuid()`.
- Normalize no schema (`trim`, `toLowerCase`, `z.coerce`) antes do service; o service recebe o dado já limpo e tipado.
- Tipos de entrada vêm do schema (`z.output`), nunca escritos à mão.
- Schemas de entidade ficam em `shared/` e são os mesmos usados nos formulários; schemas só do servidor (por exemplo, headers) ficam em `server/schemas/`.
- Mensagens de validação dos schemas compartilhados são em português, pois chegam à UI.
- Erro de validação vira `400`, `code: 'VALIDATION_ERROR'` e `details` em `{ field, issue }`.
- Rotas do próprio Better Auth (`/api/auth/*`) validam por conta própria.

## Helper

`validation.util.ts.tpl` lança `createError({ statusCode: 400, data: { details } })`. O error handler lê `error.data.details` diretamente, sem depender de como o h3 embrulha `ZodError`.

```ts
const { id } = validateParams(event, idParamsSchema)
const body = await validateBody(event, updateOrderSchema)
const query = validateQuery(event, listOrdersQuerySchema)
```

## Listagem

- `page` começa em `1`; `perPage` padrão `10` e máximo `100`; `order` é `asc` ou `desc`.
- Query string chega como texto: `z.coerce.number()`.
- O schema da entidade compõe `paginationQueryShape` e acrescenta `sort`, como o DTO de listagem estende `PaginationQueryDto`.

```ts
export const listOrdersQuerySchema = z.strictObject({
  ...paginationQueryShape,
  sort: z.enum(['name', 'createdAt', 'updatedAt']).default('createdAt')
})
```

- `shared/` não importa `server/`: os campos de `sort` do schema e `<ENTITY>_SORTABLE_FIELDS` (`server/constants/`) devem ser os mesmos; o servidor pode reexportar a lista do schema.

## Exemplo

```ts
export const createOrderSchema = z.strictObject({
  customerId: z.uuid(),
  items: z.array(createOrderItemSchema).min(1)
})

export type CreateOrderInput = z.output<typeof createOrderSchema>
```

## Testes

- Todo schema tem spec: caso válido, normalização, limites e campo desconhecido rejeitado.
- A camada em si tem `validation.util.spec.ts.tpl`.
- O E2E de API cobre `400 VALIDATION_ERROR` para body, query e `:id` inválidos.

## Templates

`validation.util.ts.tpl`, `common.validation.ts.tpl`, `validation.ts.tpl`, `validation.util.spec.ts.tpl`, `validation.spec.ts.tpl`; as rotas (`route-*.ts.tpl`) aplicam os helpers.
