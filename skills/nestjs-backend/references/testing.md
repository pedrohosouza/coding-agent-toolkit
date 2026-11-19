# Testes

## Regras

- Todos os testes usam Vitest. Jest não é usado.
- Decorators e metadata do NestJS são compilados por `unplugin-swc`.
- Importe `describe`, `it`, `expect`, `vi` e hooks de `vitest`; não habilite `globals`.
- Todo service e todo validator novo ou alterado tem spec unitário ao lado do arquivo: `services/create-order.service.spec.ts`.
- Todo controller novo ou alterado tem spec E2E em `test/e2e/<entity-names>.e2e-spec.ts`.
- Spec unitário monta o módulo com `Test.createTestingModule` e mocka o `PrismaService` com `mockDeep<PrismaService>()` (`vitest-mock-extended`).
- Spec unitário cobre regra de negócio, ownership/IDOR e exceções (`NotFoundException`, `ConflictException`).
- Spec E2E usa Supertest contra o app completo, com o mesmo bootstrap de produção (`configureApp`), Postgres real e autenticação real.
- Spec E2E cobre status codes, envelope de resposta, `400` de validação, `401` sem sessão, `404`/`403` de IDOR e paginação.
- O Postgres do E2E é um container efêmero (`@testcontainers/postgresql`, imagem `postgres:18-alpine`) iniciado no `globalSetup`; exige Docker.
- Migrations são aplicadas no container com `prisma migrate deploy`; nunca use `db push` nem `migrate dev` em teste.
- O banco é limpo antes de cada teste E2E com `TRUNCATE ... RESTART IDENTITY CASCADE` em todas as tabelas, exceto `_prisma_migrations`.
- Arquivos E2E rodam em série (`fileParallelism: false`), pois compartilham o mesmo banco.
- Nunca desligue o guard global de autenticação em teste; o helper cria usuário e sessão reais pelo Better Auth.
- Cada teste cria os próprios dados, via factories em `test/factories/`; nenhum teste depende de ordem nem de dado de outro teste.
- Variáveis de teste ficam em `.env.test`, versionado e sem segredo real; `DATABASE_URL` é injetada pelo `globalSetup`.
- `process.env` só é permitido em `test/` e em configs de teste; código de aplicação continua usando `ConfigService`.
- Não faça commit de `.only`, `.skip` nem `.todo`.
- Teste comportamento observável (resposta, efeito no banco, exceção), não detalhes de implementação.
- O Prisma Client precisa estar gerado antes dos testes (`npm run prisma:generate`); rode-o após `npm install` e após mudar o schema.
- `coverage/` entra no `.gitignore`.
- Cobertura é reportada por `npm run test:cov`; não há threshold mínimo.

## Estrutura

```text
src/modules/orders/services/
├── create-order.service.ts
└── create-order.service.spec.ts
test/
├── e2e/
│   └── orders.e2e-spec.ts
├── factories/
│   └── order.factory.ts
├── helpers/
│   ├── create-authenticated-agent.ts
│   ├── create-test-app.ts
│   └── reset-database.ts
└── setup/
    └── global-setup.ts
.env.test
vitest.config.ts
```

## Comandos

| Comando              | Função                                    |
| -------------------- | ----------------------------------------- |
| `npm run test`       | `vitest run --project unit`               |
| `npm run test:e2e`   | `vitest run --project e2e` (exige Docker) |
| `npm run test:watch` | `vitest --project unit`                   |
| `npm run test:cov`   | `vitest run --project unit --coverage`    |

- `npm run test` não sobe Docker; roda em qualquer ambiente.
- Rode `npm run test:e2e` quando a mudança tocar controller, DTO, schema Prisma, migration, autenticação ou resposta HTTP.

Dependências de desenvolvimento: `vitest`, `@vitest/coverage-v8`, `unplugin-swc`, `@swc/core`, `@nestjs/testing`, `vitest-mock-extended`, `supertest`, `@types/supertest` e `@testcontainers/postgresql`.

## Configuração

`vitest.config.ts`:

```ts
import swc from 'unplugin-swc';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  plugins: [swc.vite()],
  test: {
    coverage: {
      provider: 'v8',
      include: ['src/**/*.ts'],
      exclude: ['src/generated/**', 'src/main.ts', '**/*.spec.ts'],
    },
    projects: [
      {
        extends: true,
        test: {
          name: 'unit',
          include: ['src/**/*.spec.ts'],
        },
      },
      {
        extends: true,
        test: {
          name: 'e2e',
          include: ['test/e2e/**/*.e2e-spec.ts'],
          globalSetup: ['test/setup/global-setup.ts'],
          setupFiles: ['dotenv/config'],
          env: { DOTENV_CONFIG_PATH: '.env.test' },
          fileParallelism: false,
          testTimeout: 30_000,
          hookTimeout: 120_000,
        },
      },
    ],
  },
});
```

- `globalSetup` fica dentro do project `e2e`, para que `npm run test` não suba o container.
- Adicione `dotenv` às dependências de desenvolvimento por causa do `setupFiles`.
- `tsconfig.build.json` exclui os testes do build: `"exclude": ["node_modules", "dist", "test", "**/*.spec.ts"]`.
- `tsconfig.json` inclui `src`, `test` e `vitest.config.ts`, para que o typecheck cubra os testes.

`.env.test` (siga a organização do `.env` de `references/configuration.md`; preencha todas as variáveis exigidas pelo schema de validação):

```text
NODE_ENV=test
PORT=3001
CORS_ALLOWED_ORIGINS=http://localhost:3000

BETTER_AUTH_SECRET=test-secret-with-at-least-32-characters
BETTER_AUTH_URL=http://localhost:3001

GOOGLE_CLIENT_ID=test-google-client-id
GOOGLE_CLIENT_SECRET=test-google-client-secret

THROTTLE_TTL_MS=60000
THROTTLE_ANONYMOUS_LIMIT=10000
THROTTLE_SENSITIVE_LIMIT=10000
```

- `DATABASE_URL` não entra no `.env.test`: o `globalSetup` a define com a URL do container.
- Toda variável obrigatória do schema de validação precisa estar no `.env.test`; se faltar, o app falha no boot do teste.

## Bootstrap compartilhado

O `main.ts` e os testes E2E configuram o app pela mesma função, para que o teste exercite o pipeline real.

`src/common/factories/configure-app.factory.ts`:

```ts
import { HttpAdapterHost } from '@nestjs/core';
import type { INestApplication } from '@nestjs/common';
import { ValidationPipe } from '@nestjs/common';
import { HttpExceptionFilter } from '../filters/http-exception.filter.js';
import { ResponseEnvelopeInterceptor } from '../interceptors/response-envelope.interceptor.js';
import { createValidationException } from './validation-exception.factory.js';

export function configureApp(app: INestApplication): void {
  app.setGlobalPrefix('api');
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      exceptionFactory: createValidationException,
    }),
  );
  app.useGlobalInterceptors(new ResponseEnvelopeInterceptor());
  app.useGlobalFilters(new HttpExceptionFilter(app.get(HttpAdapterHost)));
}
```

- Se o projeto já registra pipes, interceptors, filtros ou prefixo no `main.ts`, mova tudo para `configureApp` e chame-a no `main.ts`; não mantenha duas listas.
- CORS e `enableShutdownHooks()` continuam no `main.ts`.

## Setup global

`test/setup/global-setup.ts`:

```ts
import { execSync } from 'node:child_process';
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import type { TestProject } from 'vitest/node';

export default async function setup(project: TestProject) {
  const container = await new PostgreSqlContainer('postgres:18-alpine').start();
  const databaseUrl = container.getConnectionUri();

  execSync('npx prisma migrate deploy', {
    env: { ...process.env, DATABASE_URL: databaseUrl },
    stdio: 'inherit',
  });

  project.provide('databaseUrl', databaseUrl);
  process.env.DATABASE_URL = databaseUrl;

  return async () => {
    await container.stop();
  };
}

declare module 'vitest' {
  export interface ProvidedContext {
    databaseUrl: string;
  }
}
```

- O `prisma.config.ts` lê `DATABASE_URL` do ambiente; o `execSync` a sobrescreve com a URL do container.
- Os workers herdam `process.env.DATABASE_URL`; `inject('databaseUrl')` é a alternativa tipada.

## Helpers

`test/helpers/create-test-app.ts`:

```ts
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { AppModule } from '../../src/app.module.js';
import { configureApp } from '../../src/common/factories/configure-app.factory.js';

export async function createTestApp(): Promise<INestApplication> {
  const moduleRef = await Test.createTestingModule({
    imports: [AppModule],
  }).compile();
  const app = moduleRef.createNestApplication({ bodyParser: false });

  configureApp(app);
  await app.init();

  return app;
}
```

`test/helpers/reset-database.ts`:

```ts
import { PrismaService } from '../../src/common/modules/prisma/services/prisma.service.js';
import type { INestApplication } from '@nestjs/common';

export async function resetDatabase(app: INestApplication): Promise<void> {
  const prismaService = app.get(PrismaService);
  const tables = await prismaService.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public' AND tablename <> '_prisma_migrations'
  `;

  if (tables.length === 0) {
    return;
  }

  const names = tables.map(({ tablename }) => `"public"."${tablename}"`);
  await prismaService.$executeRawUnsafe(
    `TRUNCATE TABLE ${names.join(', ')} RESTART IDENTITY CASCADE`,
  );
}
```

`test/helpers/create-authenticated-agent.ts`:

```ts
import type { INestApplication } from '@nestjs/common';
import request from 'supertest';

export async function createAuthenticatedAgent(app: INestApplication) {
  const agent = request.agent(app.getHttpServer());
  const email = `user-${crypto.randomUUID()}@example.com`;
  const password = 'Test-password-123';

  const response = await agent
    .post('/api/auth/sign-up/email')
    .send({ name: 'Test User', email, password })
    .expect(200);

  return { agent, userId: response.body.user.id as string, email };
}
```

- Todas as rotas usam o prefixo global `api`, inclusive as do Better Auth (`/api/auth/*`); os testes chamam `/api/orders`.
- O `agent` mantém o cookie de sessão entre chamadas.
- Para testar IDOR, crie dois agents e tente acessar, com o segundo, um recurso do primeiro.
- Se o projeto exigir verificação de e-mail, o helper deve concluir a verificação pelo banco antes do sign-in.
- O rate limit do Better Auth pode bloquear muitos sign-ups seguidos; em `.env.test`, use limites altos (`THROTTLE_*`).

## Factories

- Uma factory por entidade em `test/factories/<entity-name>.factory.ts`, criando o registro direto pelo `PrismaService`.
- A factory recebe `overrides` parciais e devolve o registro criado.
- Dados únicos usam `crypto.randomUUID()`, nunca contadores globais.

## Spec unitário

- Um `describe` por service; um `it` por comportamento, nomeado em inglês pelo resultado esperado (`throws NotFoundException when the order does not exist`).
- O mock é configurado por teste, com `prismaService.order.findUnique.mockResolvedValue(...)`.
- Valide a chamada ao Prisma (`where`, `data`, `select`) apenas quando ela for o comportamento relevante, como filtro por dono.
- Veja `templates/create-service.spec.ts.tpl` e `templates/exists-validator.spec.ts.tpl`.

## Spec E2E

- `beforeAll` cria o app; `afterAll` fecha (`app.close()`); `beforeEach` chama `resetDatabase`.
- Um `describe` por rota (`GET /api/orders`), com os casos de sucesso e de erro.
- Entidade com dono (`userId`) exige também o caso de IDOR: um agent cria o recurso e outro tenta ler, atualizar e remover; o template não cobre isso por usar uma entidade sem dono.
- Veja `templates/e2e-spec.ts.tpl` e `templates/factory.ts.tpl`.
