# Diretrizes do Repositório

## Contexto do Projeto

## Stack

## Comandos

## Regras de Negócio

## Autenticação e Papéis

## Convenções e Padrões

## Comunicação e Idioma

- Código, nomes de variáveis, funções, classes, arquivos, comentários e commits sempre em inglês.
- Respostas ao usuário e textos exibidos na interface em português.

## O Que NÃO Fazer

- Não silencie erros de tipo ou de linter com `@ts-ignore`, `@ts-nocheck`, `eslint-disable` ou `any` implícito; corrija a causa.
- Não refatore nem altere código fora do escopo da tarefa.
- Não instale dependências sem autorização explícita.

## Portão de Qualidade

Uma tarefa nunca é concluída enquanto houver erro de formatação, linter ou tipos, ou teste falhando.

Antes de dar a tarefa como finalizada:

1. Execute o comando de formatação.
2. Execute o comando de linter.
3. Execute o comando de typecheck.
4. Execute o comando de testes.

Corrija qualquer erro, warning ou teste falhando antes de encerrar; não altere a configuração de lint ou TypeScript só para a validação passar. Os comandos estão na seção Comandos.
