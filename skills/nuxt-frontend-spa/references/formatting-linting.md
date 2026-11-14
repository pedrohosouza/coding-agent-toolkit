# Formatação e lint

## Regras

- Formatação é feita com Prettier; lint com ESLint via `@nuxt/eslint`. Não use outro formatador nem linter.
- Rode `npm run format`, `npm run lint` e `npm run typecheck` antes de concluir qualquer tarefa; todos devem passar sem erro ou warning.
- Não altere `.prettierrc`, `eslint.config.mjs` nem `tsconfig.json` só para a validação passar; corrija a causa.
- Não silencie erros com `@ts-ignore`, `@ts-nocheck`, `eslint-disable`, `// @ts-expect-error` ou `any`.
- `eslint-config-prettier` é o último item da config do ESLint, para que regras de estilo não conflitem com o Prettier.
- `.nuxt/`, `.output/`, `node_modules/`, `package-lock.json`, `.claude/` e `.agents/` não são formatados; nunca edite `.nuxt/` à mão.
- `.nuxt/eslint.config.mjs` é gerado por `nuxt prepare` (executado no `postinstall`); rode `npm install` ou `npx nuxt prepare` se o ESLint não encontrar a config.
- Não formate arquivos fora do escopo da tarefa em commits de funcionalidade; se o formatador alterar arquivos não relacionados, reverta essas alterações.

## Comandos

| Comando             | Função                           |
| ------------------- | -------------------------------- |
| `npm run format`    | `prettier --write .`             |
| `npm run lint`      | `eslint . --max-warnings 0`      |
| `npm run typecheck` | `nuxt typecheck` (usa `vue-tsc`) |

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
package-lock.json
.claude
.agents
```

## ESLint

`eslint.config.mjs`:

```js
import eslintConfigPrettier from 'eslint-config-prettier'
import withNuxt from './.nuxt/eslint.config.mjs'

export default withNuxt(eslintConfigPrettier)
```

- `--max-warnings 0` faz warnings falharem o lint.
- Módulo `@nuxt/eslint` registrado em `modules` no `nuxt.config.ts`.
- Dependências de desenvolvimento: `@nuxt/eslint`, `eslint`, `eslint-config-prettier`, `prettier`, `typescript` e `vue-tsc`.
- Novas regras entram em `eslint.config.mjs` com justificativa no commit.
