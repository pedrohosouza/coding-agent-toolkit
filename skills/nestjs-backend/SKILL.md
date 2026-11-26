---
name: nestjs-backend
description: Aplica os padrões obrigatórios do projeto ao criar, alterar ou revisar APIs NestJS. Cobre estrutura de pastas, nomenclatura, configuração por ambiente, autenticação, autorização, DTOs, validação, integridade referencial, sanitização, respostas padronizadas, paginação, filtros, ordenação, UUIDs, rate limiting, CORS, health checks, graceful shutdown, migrations, seeds, busca normalizada, formatação, lint, testes unitários e E2E, Docker e Better Auth. Use para rota, endpoint, controller, service, DTO, guard, schema Prisma, migration, seed, busca, teste, env ou health check de backend.
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
- `.env` e `.env.example`: variáveis do app primeiro (`NODE_ENV`, `PORT`), depois grupos por prefixo, com linha em branco entre os grupos; veja `references/configuration.md`.
- Toda rota é autenticada por padrão; rotas públicas usam `@AllowAnonymous()`.
- Autorização é verificada por recurso, prevenindo IDOR/BOLA: controllers obtêm o usuário com `@Session()`, services e validators recebem `userId` e toda query de leitura, alteração ou remoção filtra pelo dono (`where: { id, userId }`); nunca aceite `userId` do body.
- Valide toda entrada externa: body, query, params e headers.
- Use respostas consistentes para recurso específico, lista paginada e erro.
- Nunca retorne `200` para erro.
- Sanitize e restrinja a saída; nunca exponha modelos Prisma, hashes, tokens ou segredos.
- Toda PK e FK é UUID v7 gerado pelo banco (`@db.Uuid`, `uuidv7()`); toda rota com `:id` usa `ParseUUIDPipe` e todo id em DTO usa `@IsUUID()`.
- Listagens usam `prisma.<model>.paginate()` e DTOs que estendem `PaginationQueryDto`.
- Busca textual que deve ignorar acentos usa coluna `normalized*` e `normalizeText()`; veja `references/search.md`.
- Seeds ficam em `prisma/seeds/`, são idempotentes e têm um arquivo por entidade; veja `references/seeds.md`.
- Health check usa `@nestjs/terminus`, com `liveness` e `readiness`; todo serviço de que a API depende tem indicador no readiness.
- Toda mudança de schema passa por migration versionada.
- O código deve ser explicativo por si só: nomes claros e funções pequenas; não escreva comentários.
- Todo service e validator novo ou alterado tem spec unitário (Vitest); todo controller novo ou alterado tem spec E2E com Postgres real; veja `references/testing.md`.
- Antes de concluir, `npm run format`, `npm run lint`, `npm run typecheck` e `npm run test` devem passar sem erro ou warning; rode também `npm run test:e2e` quando a mudança tocar controller, DTO, schema Prisma, migration ou autenticação; veja `references/formatting-linting.md` e `references/testing.md`.
- Use `camelCase` para variáveis, funções e propriedades.
- Use `PascalCase` para classes, interfaces, types e enums.
- Use `kebab-case` para arquivos e pastas.
- Use `UPPER_SNAKE_CASE` para constantes globais e variáveis de ambiente.

## Roteamento de referências

Leia apenas a referência necessária para a tarefa:

- Estrutura de pastas: `references/folder-structure.md`
- Nomenclatura: `references/naming-conventions.md`
- Configuração e variáveis de ambiente: `references/configuration.md`
- Autenticação, autorização, configuração do Better Auth, guards, sessão e IDOR: `references/authentication-authorization.md`
- Respostas padronizadas: `references/responses.md`
- DTOs e validação de entrada: `references/validation.md`
- Validação de relacionamentos: `references/relationships.md`
- Sanitização: `references/sanitization.md`
- Rate limiting: `references/rate-limiting.md`
- CORS: `references/cors.md`
- Graceful shutdown: `references/graceful-shutdown.md`
- Prisma, UUIDs, migrations, queries, `paginate()` e transações: `references/prisma.md`
- Seeds (`prisma/seeds/`, `prisma db seed`, dados iniciais): `references/seeds.md`
- Busca sem acento e sem diferença de maiúsculas (`normalizedName`, `normalizeText`): `references/search.md`
- Formatação, lint e typecheck (Prettier, oxlint, portão de qualidade): `references/formatting-linting.md`
- Testes (Vitest, specs unitários, E2E, Testcontainers, factories): `references/testing.md`
- Docker, Dockerfile, docker-compose e deploy: `references/docker-deployment.md`
- Health checks, Terminus e readiness de dependências: `references/health-checks.md`

## Templates

Ao criar um módulo novo, use os templates em `templates/` e adapte-os ao domínio. Cada template vira um arquivo na pasta indicada:

| Template                            | Destino                                                 |
| ----------------------------------- | ------------------------------------------------------- |
| `module.ts.tpl`                     | `<entity-names>.module.ts`                              |
| `controller.ts.tpl`                 | `controllers/<entity-names>.controller.ts`              |
| `create-dto.ts.tpl`                 | `dtos/create-<entity-name>.dto.ts`                      |
| `update-dto.ts.tpl`                 | `dtos/update-<entity-name>.dto.ts`                      |
| `list-query-dto.ts.tpl`             | `dtos/list-<entity-names>-query.dto.ts`                 |
| `create-service.ts.tpl`             | `services/create-<entity-name>.service.ts`              |
| `get-service.ts.tpl`                | `services/get-<entity-name>.service.ts`                 |
| `list-service.ts.tpl`               | `services/list-<entity-names>.service.ts`               |
| `update-service.ts.tpl`             | `services/update-<entity-name>.service.ts`              |
| `delete-service.ts.tpl`             | `services/delete-<entity-name>.service.ts`              |
| `exists-validator.ts.tpl`           | `validators/<entity-name>-exists.validator.ts`          |
| `select.constant.ts.tpl`            | `constants/<entity-name>-select.constant.ts`            |
| `searchable-fields.constant.ts.tpl` | `constants/<entity-name>-searchable-fields.constant.ts` |
| `sortable-fields.constant.ts.tpl`   | `constants/<entity-name>-sortable-fields.constant.ts`   |
| `create-service.spec.ts.tpl`        | `services/create-<entity-name>.service.spec.ts`         |
| `exists-validator.spec.ts.tpl`      | `validators/<entity-name>-exists.validator.spec.ts`     |
| `e2e-spec.ts.tpl`                   | `test/e2e/<entity-names>.e2e-spec.ts`                   |
| `factory.ts.tpl`                    | `test/factories/<entity-name>.factory.ts`               |

Substitua os placeholders (exemplo para a entidade `Order`):

| Placeholder        | Formato                                                             | Exemplo  |
| ------------------ | ------------------------------------------------------------------- | -------- |
| `{{EntityName}}`   | PascalCase, singular                                                | `Order`  |
| `{{entityName}}`   | camelCase, singular; também é o delegate do Prisma (`prisma.order`) | `order`  |
| `{{entity-name}}`  | kebab-case, singular                                                | `order`  |
| `{{ENTITY_NAME}}`  | UPPER_SNAKE_CASE, singular                                          | `ORDER`  |
| `{{EntityNames}}`  | PascalCase, plural                                                  | `Orders` |
| `{{entity-names}}` | kebab-case, plural                                                  | `orders` |

- O model Prisma deve se chamar `{{EntityName}}`, para que `prisma.{{entityName}}` exista, e ter `userId` (`@db.Uuid`) com relação para `User`. Se o recurso pertencer a uma organização, troque o filtro por `organizationId` da sessão.
- O decorator `@Session()` e o type `UserSession` vêm da integração NestJS do Better Auth usada no projeto; ajuste o import se o pacote for outro.
- O plural é usado no module, no controller, na rota, no service de listagem e no DTO de listagem; o singular, no restante.

O `list-service.ts.tpl` não normaliza a busca. Quando a entidade exigir busca normalizada (sem acento e sem diferença de maiúsculas), siga `references/search.md`: coluna `normalized*`, `normalizeText()` no service e `SEARCHABLE_FIELDS` apontando para ela.

Os demais services (`get`, `list`, `update`, `delete`) seguem o mesmo formato do `create-service.spec.ts.tpl`; escreva um spec para cada um, adaptando os casos.

Não crie arquivos ou métodos vazios. Remova o que não for necessário.
