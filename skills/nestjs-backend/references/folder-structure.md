# Estrutura de pastas

## Princípios

- Organize por domínio/feature em `src/modules/`.
- Código reutilizável e transversal fica em `src/common/`.
- Módulos transversais com providers próprios ficam em `src/common/modules/` (ex.: `prisma`, `environment`, `storage`, `mailer`).
- Funções puras sem dependência de NestJS ficam em `src/utils/`.
- Prisma schema, migrations e seeds ficam em `prisma/`, na raiz do projeto.
- Agrupe arquivos por responsabilidade em pastas no plural.
- Nomeie cada arquivo no singular, com o sufixo do artefato: `controllers/user.controller.ts`, `services/create-user.service.ts`.
- Um artefato principal por arquivo.
- Cada service tem uma única responsabilidade.

## Estrutura base

```text
prisma/
├── schema.prisma
├── migrations/
└── seeds/
src/
├── main.ts
├── app.module.ts
├── generated/prisma/
├── common/
├── utils/
└── modules/
```

## common/

`common/` contém apenas código genérico, reutilizável e sem conhecimento de domínio.

```text
src/common/
├── classes/
├── constants/
├── decorators/
├── dtos/
├── factories/
├── filters/
├── guards/
├── interceptors/
├── interfaces/
├── types/
└── modules/
    ├── environment/
    ├── prisma/
    └── auth/
```

### Regras do `common/`

- `classes/`: classes genéricas, como `PaginatedResult`.
- `constants/`: constantes genéricas, como `SORT_ORDERS` e limites de paginação.
- `dtos/`: DTOs genéricos, como `PaginationQueryDto`.
- `decorators/`: decorators genéricos, como `@CurrentUser()`.
- `filters/`: exception filters globais.
- `guards/`: guards reutilizáveis, como autenticação e permissões.
- `interceptors/`: interceptors globais de transformação, como o envelope de resposta.
- `modules/prisma`: `PrismaService`, `PrismaModule` e extensões do Prisma Client.
- `modules/environment`: `ConfigModule` e schema de validação das variáveis de ambiente.

### Proibições

- `common/` não importa módulos de domínio.
- `common/` não contém regra de negócio.
- `common/` não contém DTO específico de um módulo.
- `common/` não conhece entidades como `Order`, `User` ou `Payment`.

## Módulos

```text
src/modules/<domain>/
├── <domain>.module.ts
├── controllers/
├── dtos/
├── services/
├── validators/
├── constants/
├── mappers/
└── types/
```

Crie apenas as pastas necessárias; não crie pastas vazias.

- `controllers/`: um controller por recurso, no plural (`orders.controller.ts`).
- `dtos/`: um DTO por arquivo (`create-order.dto.ts`, `update-order.dto.ts`, `list-orders-query.dto.ts`).
- `services/`: um service por operação, direto na pasta (`create-order.service.ts`).
- `validators/`: validators de existência e regras reutilizáveis (`order-exists.validator.ts`).
- `constants/`: `select`, campos pesquisáveis e ordenáveis (`order-select.constant.ts`).
- `mappers/`: conversão de registro Prisma para resposta (`order-response.mapper.ts`).

### Exemplo

```text
src/modules/orders/
├── orders.module.ts
├── controllers/
│   └── orders.controller.ts
├── dtos/
│   ├── create-order.dto.ts
│   ├── update-order.dto.ts
│   └── list-orders-query.dto.ts
├── constants/
│   ├── order-select.constant.ts
│   ├── order-searchable-fields.constant.ts
│   └── order-sortable-fields.constant.ts
├── validators/
│   └── order-exists.validator.ts
└── services/
    ├── create-order.service.ts
    ├── get-order.service.ts
    ├── list-orders.service.ts
    ├── update-order.service.ts
    ├── delete-order.service.ts
    └── cancel-order.service.ts
```

## Dependências

```text
controller → service → PrismaService → banco
service → validator → PrismaService
```

- Service e validator podem importar `common/`.
- Módulo pode importar `common/`.
- `PrismaModule` é global; não precisa ser importado nos módulos de domínio.
- `common/` não importa módulo.
- Módulo não importa outro módulo de domínio diretamente sem necessidade explícita; compartilhe via `exports` do módulo.
