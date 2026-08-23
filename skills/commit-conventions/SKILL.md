---
name: commit-conventions
description: Padrão de mensagens de commit (Conventional Commits) e boas práticas de commit. Use SEMPRE que for escrever uma mensagem de commit, agrupar mudanças em commits, revisar um histórico de git, ou quando o usuário mencionar "commit", "commitar", "mensagem de commit", "conventional commits" ou pedir para versionar mudanças. Aplique mesmo que o usuário não cite explicitamente o padrão.
---

# Commit Conventions

Padrão de mensagens de commit baseado em Conventional Commits. Agnóstico de
projeto — vale para qualquer repositório.

## Formato

```
<tipo>(<escopo opcional>): <descrição no imperativo>

<corpo opcional>

<rodapé opcional>
```

Exemplos:
```
feat(auth): adiciona refresh token no login
fix(posts): corrige vazamento de dados entre tenants na listagem
refactor(users): extrai validação para service dedicado
```

## Tipos permitidos

- `feat` — nova funcionalidade
- `fix` — correção de bug
- `refactor` — mudança de código sem alterar comportamento externo
- `chore` — manutenção (deps, config, scripts, tooling)
- `docs` — apenas documentação
- `test` — adição ou ajuste de testes
- `style` — formatação/estilo sem mudança de lógica
- `perf` — melhoria de performance
- `build` — mudanças no build ou dependências
- `ci` — mudanças em pipelines de CI

## Regras da mensagem

- Descrição no **imperativo** e minúscula: "adiciona", não "adicionado"/"Adiciona".
- Sem ponto final na descrição.
- Máximo ~72 caracteres na primeira linha.
- Escopo é opcional, mas quando usado deve ser um módulo/área real do projeto.
- Corpo (opcional) explica o **porquê**, não o "o quê" (o diff já mostra o quê).
- **Breaking change:** adicione `!` após o tipo/escopo (`feat(api)!: ...`) e/ou
  um rodapé `BREAKING CHANGE: <descrição>`.
- Referencie issues no rodapé quando aplicável (`Refs #123`, `Closes #123`).

## Boas práticas de commit

- **Um commit por unidade lógica de mudança.** Não misture refactor + feature +
  fix no mesmo commit.
- Commits devem deixar o repositório em estado consistente (idealmente compila e
  passa no lint).
- Não commite código comentado, `console.log`/`print` de debug, ou segredos.
- Nunca commite `.env`, credenciais ou artefatos gerados (`dist/`, build, client
  de ORM gerado).

## Fluxo (segurança)

- **Nunca faça `git commit` ou `git push` sem confirmação explícita do usuário.**
- Não reescreva histórico compartilhado (`reset --hard`, `rebase`, `push --force`)
  sem pedir antes.
- Ao ser solicitado a "commitar", primeiro mostre o que será commitado
  (`git status` / `git diff`) e a mensagem proposta, e aguarde confirmação.

## Notas por ferramenta (adapte ao projeto)

- Se o projeto usa `commitlint` / `husky`, siga a config existente do repositório
  em vez destas regras quando houver conflito.
- Se há convenção de branch definida (ex: `feat/<descricao>`, `fix/<descricao>`),
  respeite-a.