---
name: nestjs-backend
description: Aplica os padrões obrigatórios do projeto ao criar, alterar ou revisar APIs NestJS. Cobre estrutura de pastas, nomenclatura, configuração por ambiente, autenticação, autorização, DTOs, validação, integridade referencial, sanitização, respostas padronizadas, paginação, filtros, ordenação, UUIDs, rate limiting, CORS, health checks, graceful shutdown e migrations. Use para rota, endpoint, controller, service, DTO, guard, schema Prisma, migration, env ou health check de backend.
---

# Padrões NestJS + Prisma

## Arquitetura

- Organize o código por módulo de domínio em `src/modules/<domain>/`, com `controllers/`, `dtos/`, `services/` e `validators/`.
- Código reutilizável e transversal fica em `src/common/`.
- Cada responsabilidade de negócio é um service isolado que representa um use case e possui uma única responsabilidade.
- O método público principal de um service é `execute()`.
- Controllers injetam services.
- Existência de recurso é verificada em validators reutilizáveis (`<entity>-exists.validator.ts`).
- Services injetam `PrismaService` diretamente.
- Não crie services genéricos que acumulem múltiplas responsabilidades.
- Se um service começar a acumular operações, divida-o em novos services.

## Regras universais

- Use Better Auth para autenticação.
- Nunca acesse `process.env` diretamente no código de aplicação.
- Toda variável de ambiente é validada no boot pela camada de configuração.
- Toda rota é autenticada por padrão; rotas públicas usam `@AllowAnonymous()`.
- Autorização é verificada por recurso, prevenindo IDOR/BOLA.
- Valide toda entrada externa: body, query, params e headers.
- Use respostas consistentes para recurso específico, lista paginada e erro.
- Nunca retorne `200` para erro.
- Sanitize e restrinja a saída; nunca exponha modelos Prisma, hashes, tokens ou segredos.
- Toda PK e FK é UUID v7 gerado pelo banco (`@db.Uuid`, `uuidv7()`); toda rota com `:id` usa `ParseUUIDPipe` e todo id em DTO usa `@IsUUID()`.
- Listagens usam `prisma.<model>.paginate()` e DTOs que estendem `PaginationQueryDto`.
- Health check usa `@nestjs/terminus`, com `liveness` e `readiness`; todo serviço de que a API depende tem indicador no readiness.
- Toda mudança de schema passa por migration versionada.
- Use `camelCase` para variáveis, funções e propriedades.
- Use `PascalCase` para classes, interfaces, types e enums.
- Use `kebab-case` para arquivos e pastas.
- Use `UPPER_SNAKE_CASE` para constantes globais e variáveis de ambiente.

## Roteamento de referências

Leia apenas a referência necessária para a tarefa:

- Estrutura de pastas: `references/folder-structure.md`
- Nomenclatura: `references/naming-conventions.md`
- Configuração e variáveis de ambiente: `references/configuration.md`
- Autenticação, autorização, Better Auth, guards, sessão e IDOR: `references/authentication-authorization.md`
- Respostas padronizadas: `references/responses.md`
- DTOs e validação de entrada: `references/validation.md`
- Validação de relacionamentos: `references/relationships.md`
- Sanitização: `references/sanitization.md`
- Rate limiting: `references/rate-limiting.md`
- CORS: `references/cors.md`
- Graceful shutdown: `references/graceful-shutdown.md`
- Prisma, UUIDs, migrations, queries, `paginate()` e transações: `references/prisma.md`
- Health checks, Terminus e readiness de dependências: `references/health-checks.md`

## Templates

Ao criar um módulo novo, use os templates em `templates/` e adapte-os ao domínio. Cada template vira um arquivo na pasta indicada:

| Template | Destino |
|---|---|
| `module.ts.tpl` | `<entity-names>.module.ts` |
| `controller.ts.tpl` | `controllers/<entity-names>.controller.ts` |
| `create-dto.ts.tpl` | `dtos/create-<entity-name>.dto.ts` |
| `update-dto.ts.tpl` | `dtos/update-<entity-name>.dto.ts` |
| `list-query-dto.ts.tpl` | `dtos/list-<entity-names>-query.dto.ts` |
| `create-service.ts.tpl` | `services/create-<entity-name>.service.ts` |
| `get-service.ts.tpl` | `services/get-<entity-name>.service.ts` |
| `list-service.ts.tpl` | `services/list-<entity-names>.service.ts` |
| `update-service.ts.tpl` | `services/update-<entity-name>.service.ts` |
| `delete-service.ts.tpl` | `services/delete-<entity-name>.service.ts` |
| `exists-validator.ts.tpl` | `validators/<entity-name>-exists.validator.ts` |
| `select.constant.ts.tpl` | `constants/<entity-name>-select.constant.ts` |
| `searchable-fields.constant.ts.tpl` | `constants/<entity-name>-searchable-fields.constant.ts` |
| `sortable-fields.constant.ts.tpl` | `constants/<entity-name>-sortable-fields.constant.ts` |

Substitua os placeholders (exemplo para a entidade `Order`):

| Placeholder | Formato | Exemplo |
|---|---|---|
| `{{EntityName}}` | PascalCase, singular | `Order` |
| `{{entityName}}` | camelCase, singular; também é o delegate do Prisma (`prisma.order`) | `order` |
| `{{entity-name}}` | kebab-case, singular | `order` |
| `{{ENTITY_NAME}}` | UPPER_SNAKE_CASE, singular | `ORDER` |
| `{{EntityNames}}` | PascalCase, plural | `Orders` |
| `{{entity-names}}` | kebab-case, plural | `orders` |

- O model Prisma deve se chamar `{{EntityName}}`, para que `prisma.{{entityName}}` exista.
- O plural é usado no module, no controller, na rota, no service de listagem e no DTO de listagem; o singular, no restante.

Não crie arquivos ou métodos vazios. Remova o que não for necessário.
