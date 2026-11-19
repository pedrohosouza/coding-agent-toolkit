# Formatação e lint

## Regras

- Formatação é feita com Prettier; lint com oxlint. Não use ESLint nem outro formatador.
- Rode `npm run format`, `npm run lint`, `npm run typecheck` e `npm run test` antes de concluir qualquer tarefa; todos devem passar sem erro ou warning. Veja `references/testing.md`.
- Não altere `.prettierrc`, `.oxlintrc.json` nem `tsconfig.json` só para a validação passar; corrija a causa.
- Não silencie erros com `@ts-ignore`, `@ts-nocheck`, `eslint-disable`, `oxlint-disable` ou `any`.
- `dist/`, `node_modules/`, `coverage/`, `src/generated/`, `package-lock.json` e `prisma/migrations/` não são formatados nem analisados; nunca edite `src/generated/` à mão.
- Não formate arquivos fora do escopo da tarefa em commits de funcionalidade; se o formatador alterar arquivos não relacionados, reverta essas alterações.

## Comandos

| Comando             | Função                          |
| ------------------- | ------------------------------- |
| `npm run format`    | `prettier --write .`            |
| `npm run lint`      | `oxlint --deny-warnings`        |
| `npm run typecheck` | `tsc --noEmit -p tsconfig.json` |
| `npm run test`      | `vitest run --project unit`     |

## Prettier

`.prettierrc`:

```json
{
  "singleQuote": true,
  "trailingComma": "all"
}
```

`.prettierignore`:

```text
dist/
node_modules/
coverage/
src/generated/
package-lock.json
prisma/migrations/
```

## oxlint

`.oxlintrc.json`:

```json
{
  "$schema": "./node_modules/oxlint/configuration_schema.json",
  "plugins": ["typescript", "import", "node", "oxc", "vitest"],
  "categories": {
    "correctness": "error",
    "suspicious": "warn"
  },
  "rules": {
    "typescript/no-explicit-any": "error",
    "typescript/no-extraneous-class": [
      "warn",
      { "allowWithDecorator": true, "allowConstructorOnly": true }
    ],
    "typescript/ban-ts-comment": "error"
  },
  "ignorePatterns": ["dist", "coverage", "src/generated"]
}
```

- `--deny-warnings` faz warnings falharem o lint.
- `no-extraneous-class` permite classes com decorator (Nest) e só com construtor.
- O plugin `vitest` bloqueia `.only` e outros erros comuns em specs.
- Novas regras entram em `.oxlintrc.json` com justificativa no commit.
