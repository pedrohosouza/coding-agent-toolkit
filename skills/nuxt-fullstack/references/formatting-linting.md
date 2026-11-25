# Formatação, lint e typecheck

## Regras

- Formatação é feita com Prettier; lint com ESLint via `@nuxt/eslint`, que cobre `app/`, `server/` e `shared/`. Não use outro formatador nem linter.
- Rode `npm run format`, `npm run lint`, `npm run typecheck` e `npm run test` antes de concluir qualquer tarefa; todos devem passar sem erro ou warning. Rode também `npm run test:e2e` quando a mudança tocar rota, schema Zod, schema Prisma, migration, página, middleware ou autenticação. Veja `references/testing.md`.
- Não altere `.prettierrc`, `eslint.config.mjs` nem `tsconfig.json` só para a validação passar; corrija a causa.
- Não silencie erros com `@ts-ignore`, `@ts-nocheck`, `eslint-disable`, `@ts-expect-error` ou `any`.
- `eslint-config-prettier` é o último item da config do ESLint, para que regras de estilo não conflitem com o Prettier.
- `.nuxt/`, `.output/`, `node_modules/`, `coverage/`, `playwright-report/`, `test-results/`, `server/generated/`, `prisma/migrations/`, `package-lock.json`, `.claude/` e `.agents/` não são formatados nem analisados; nunca edite `.nuxt/` nem `server/generated/` à mão.
- `.nuxt/eslint.config.mjs` e os tsconfigs são gerados por `nuxt prepare` (executado no `postinstall`); rode `npm install` ou `npx nuxt prepare` se o ESLint ou o typecheck não encontrarem a config.
- O Prisma Client precisa estar gerado antes do typecheck e dos testes (`npm run prisma:generate`).
- Não formate arquivos fora do escopo da tarefa em commits de funcionalidade; se o formatador alterar arquivos não relacionados, reverta essas alterações.

## Comandos

| Comando                | Função                                            |
| ---------------------- | ------------------------------------------------- |
| `npm run format`       | `prettier --write .`                              |
| `npm run lint`         | `eslint . --max-warnings 0`                       |
| `npm run typecheck`    | `nuxt typecheck` (usa `vue-tsc`)                  |
| `npm run test`         | `vitest run --project unit --project nuxt`        |
| `npm run test:e2e`     | `vitest run --project e2e-api && playwright test` |

## Prettier

`.prettierrc`:

```json
{
  "semi": false,
  "singleQuote": true,
  "trailingComma": "none"
}
```

`.prettierignore`:

```text
.nuxt
.output
node_modules
coverage
playwright-report
test-results
server/generated
prisma/migrations
package-lock.json
.claude
.agents
```

## ESLint

`eslint.config.mjs`:

```js
import eslintConfigPrettier from 'eslint-config-prettier'
import withNuxt from './.nuxt/eslint.config.mjs'

export default withNuxt(
  { ignores: ['server/generated', 'coverage', 'playwright-report', 'test-results'] },
  eslintConfigPrettier
)
```

- `--max-warnings 0` faz warnings falharem o lint.
- Módulo `@nuxt/eslint` registrado em `modules` no `nuxt.config.ts`.
- Dependências de desenvolvimento: `@nuxt/eslint`, `eslint`, `eslint-config-prettier`, `prettier`, `typescript` e `vue-tsc`.
- Novas regras entram em `eslint.config.mjs` com justificativa no commit.

## Typecheck

- `nuxt typecheck` checa app, servidor e `shared/` pelos tsconfigs gerados em `.nuxt/`.
- Confirme que os specs em `test/` são cobertos. Se não forem, inclua `../test/**/*` em `typescript.tsConfig.include` (ou `typescript.nodeTsConfig.include`) no `nuxt.config.ts`; não desative a checagem.
