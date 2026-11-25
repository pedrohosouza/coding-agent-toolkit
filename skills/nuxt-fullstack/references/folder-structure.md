# Estrutura de pastas

## Princípios

- Frontend em `app/` (Nuxt 4); backend Nitro em `server/`; código compartilhado em `shared/`.
- Prisma schema, migrations e seeds ficam em `prisma/`, na raiz do projeto.
- Nitro só auto-importa `server/utils/`; plugins, middleware e rotas são registrados por convenção de pasta.
- Agrupe arquivos por responsabilidade em pastas no plural; nomeie cada arquivo no singular, com o sufixo do artefato.
- Um artefato principal por arquivo; cada service tem uma única responsabilidade.
- Specs unitários e E2E ficam em `test/`; veja `references/testing.md`.

## Estrutura base

```text
prisma/
├── schema.prisma
├── migrations/
└── seeds/
shared/
├── schemas/
└── types/
server/
├── api/
├── constants/
├── generated/prisma/
├── middleware/
├── plugins/
├── schemas/
├── services/
├── utils/
└── validators/
app/
test/
```

## server/

```text
server/
├── api/
│   ├── auth/[...all].ts
│   ├── health/
│   │   ├── liveness.get.ts
│   │   └── readiness.get.ts
│   └── orders/
│       ├── index.get.ts
│       ├── index.post.ts
│       ├── [id].get.ts
│       ├── [id].patch.ts
│       └── [id].delete.ts
├── constants/
│   ├── order-select.constant.ts
│   ├── order-searchable-fields.constant.ts
│   └── order-sortable-fields.constant.ts
├── middleware/
│   ├── auth.ts
│   └── rate-limit.ts
├── plugins/
│   ├── env.ts
│   ├── error-handler.ts
│   └── shutdown.ts
├── services/orders/
│   ├── create-order.service.ts
│   ├── get-order.service.ts
│   ├── list-orders.service.ts
│   ├── update-order.service.ts
│   ├── delete-order.service.ts
│   └── cancel-order.service.ts
├── utils/
│   ├── auth.ts
│   ├── normalize-text.ts
│   ├── pagination.ts
│   ├── prisma.ts
│   ├── validation.ts
│   ├── require-session.ts
│   └── response.ts
└── validators/
    └── order-exists.validator.ts
```

- `api/`: rotas finas, um arquivo por método HTTP (`index.get.ts`, `[id].patch.ts`); sem regra de negócio.
- `services/<entity-names>/`: um service por use case, com `execute()`.
- `validators/`: validators de existência e regras reutilizáveis.
- `constants/`: `select`, campos pesquisáveis e ordenáveis.
- `utils/`: código transversal sem conhecimento de domínio (Prisma, auth, resposta, paginação).
- `plugins/`: boot (validação de env, error handler, shutdown).
- `middleware/`: executa em toda requisição, em ordem alfabética (`auth` antes de `rate-limit`).
- `generated/prisma/`: client gerado; não edite nem versione se o projeto ignorar a pasta.

## shared/

- `shared/schemas/<entity-name>.validation.ts`: schemas Zod usados por servidor e cliente.
- `shared/schemas/common.validation.ts`: `idParamsSchema` e `paginationQueryShape`.
- `server/schemas/`: schemas só do servidor (por exemplo, headers).
- `server/utils/validation.ts`: camada de validação (`validateBody`, `validateQuery`, `validateParams`, `validateHeaders`).
- `shared/types/`: types de contrato (`api.types.ts`, `<entity-name>.types.ts`).
- `shared/` não importa `server/` nem `app/`.

## Dependências

```text
route → service → prisma → banco
service → validator → prisma
route → shared/schemas
```

- Rotas importam services, `require-session` e `response`; nunca Prisma.
- `utils/` não importa services nem validators.
- Importe arquivos próprios explicitamente com `~~/server/...` e `~~/shared/...`.
