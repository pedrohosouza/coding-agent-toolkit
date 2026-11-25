# Rotas Nitro e services

## Regras

- Rotas ficam em `server/api/`, um arquivo por método: `index.get.ts`, `index.post.ts`, `[id].get.ts`, `[id].patch.ts`, `[id].delete.ts`.
- A rota é fina e segue sempre a mesma ordem: validar com Zod, `requireSession(event)`, `service.execute()`, helper de envelope.
- Nenhuma regra de negócio, query Prisma ou verificação de ownership na rota.
- Valide com `validateQuery`, `validateBody`, `validateParams` e `validateHeaders` de `~~/server/utils/validation`; nunca use `getQuery`, `readBody` ou `getRouterParam` sem validar (veja `references/validation.md`).
- Schemas do body e da query vêm de `~~/shared/schemas/<entity-name>.validation`; o `:id` usa `idParamsSchema` de `~~/shared/schemas/common.validation`.
- A identidade vem de `session.user.id`; nunca do body.
- Erros usam `createError({ statusCode, message })`; nunca `new Error()` nem `return` com status de erro.
- Importe os próprios arquivos explicitamente; os helpers do h3 e do Nitro são auto-importados.

## Rota

```ts
export default defineEventHandler(async (event) => {
  const { id } = validateParams(event, idParamsSchema)
  const body = await validateBody(event, updateOrderSchema)
  const session = await requireSession(event)

  const order = await new UpdateOrderService().execute(session.user.id, id, body)

  return respond(order)
})
```

## Status

- `200` leitura e atualização; `201` criação com `setResponseStatus(event, 201)`; `204` deleção com `sendNoContent(event)`.

## Services

- Classe em `server/services/<entity-names>/<verb>-<entity-name>.service.ts`, com `execute()`.
- O construtor recebe o Prisma e os validators com default (`db = prisma`), o que permite substituí-los em testes.
- `execute()` recebe `userId` e os dados já validados.
- Retorna o dado puro, sempre com `select`; o envelope é montado só na rota.
- Services não leem `event`, headers nem `useRuntimeConfig()`; recebem o que precisam por parâmetro.
- Traduza erros de domínio com `createError`; erros do Prisma (`P2002`, `P2025`) são mapeados pelo error handler.
- Use `prisma.$transaction` apenas para múltiplas escritas dependentes.

## Listagem

- Query validada com `page`, `perPage` (máximo `100`), `search`, `sort`, `order`; veja `references/validation.md`.
- O service usa `prisma.<entity>.paginate()` e retorna `{ data, pagination }`; a rota usa `respondPaginated`.

## Template

`route-*.ts.tpl` e `*-service.ts.tpl`.
