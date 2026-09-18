---
name: commit-conventions
description: Define mensagens e organização de commits com Conventional Commits. Use ao propor, revisar ou executar commits.
---

# Commit Conventions

Siga primeiro `commitlint`, hooks e convenções existentes no repositório.

## Formato

```text
<type>(<optional-scope>): <imperative description>

<optional body>

<optional footer>
```

Tipos permitidos:

- `feat`: nova funcionalidade
- `fix`: correção de bug
- `refactor`: mudança sem alterar comportamento externo
- `chore`: manutenção
- `docs`: documentação
- `test`: testes
- `style`: formatação sem mudança de lógica
- `perf`: performance
- `build`: build ou dependências
- `ci`: integração e entrega contínuas

## Mensagem

- Escreva em inglês, no imperativo, com descrição minúscula e sem ponto final.
- Mantenha a primeira linha em aproximadamente 72 caracteres.
- Use escopo somente quando representar módulo ou área real.
- Use corpo para explicar contexto e motivo, não para repetir o diff.
- Marque breaking changes com `!` e/ou `BREAKING CHANGE:`.
- Referencie issues no rodapé quando aplicável.

## Organização

- Cada commit representa uma unidade lógica e deixa o repositório consistente.
- Não misture feature, correção e refatoração independentes.
- Não inclua código de debug, segredos, `.env` ou artefatos gerados não
  versionados pelo projeto.

## Segurança Git

- Nunca execute `git commit` ou `git push` sem confirmação explícita do usuário.
- Antes de commitar, revise `git status` e `git diff`, proponha a mensagem e
  aguarde confirmação.
- Nunca reescreva histórico compartilhado sem autorização explícita.
