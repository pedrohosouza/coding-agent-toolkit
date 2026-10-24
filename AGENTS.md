# Diretrizes do Repositório

## Contexto do Projeto

<!-- Descreva o que o produto faz, o glossário do domínio e as regras de negócio que afetam o código (ex.: multi-tenant, papéis). -->

## Stack

<!-- Liste gerenciador de pacotes, frameworks e versões (ex.: npm, Node, Nuxt, NestJS). -->

## Comandos

<!-- Liste os comandos do projeto: build, format, lint, typecheck, dev, prod, prisma e demais scripts. -->

## Serviços Externos

<!-- Liste os serviços de que a API depende (banco, cache, filas, storage, APIs de terceiros). Cada um precisa de indicador no readiness. -->

## Regras de Negócio

<!-- Registre as regras que mudam o comportamento do código e não são óbvias pelo código (ex.: limites, estados, cálculos, bloqueios). -->

## Autenticação e Papéis

<!-- Descreva o provedor de autenticação, os papéis, as permissões por recurso e o escopo de acesso (ex.: por organização). -->

## Variáveis de Ambiente

<!-- Liste as variáveis do projeto, quais são obrigatórias, o que cada uma controla e onde ficam os valores por ambiente. -->

## Ambientes e Deploy

<!-- Descreva os ambientes (dev, staging, produção), a pipeline de CI/CD, como o deploy é feito e como reverter. -->

## Convenções e Padrões

<!-- Registre as convenções específicas deste projeto (estrutura, nomes, padrões de código) que fogem do padrão do framework. -->

## Comunicação e Idioma

- Código, nomes de variáveis, funções, classes, arquivos, comentários e commits sempre em inglês.
- Respostas ao usuário e textos exibidos na interface em português.

## Estilo de resposta

Em toda sessão, leia e aplique a skill caveman no nível full, sem precisar de invocação explícita.
Mantenha o idioma do usuário.

## O Que NÃO Fazer

- Não silencie erros de tipo ou de linter com `@ts-ignore`, `@ts-nocheck`, `eslint-disable` ou `any` implícito; corrija a causa.
- Não refatore nem altere código fora do escopo da tarefa.
- Não instale dependências sem autorização explícita.
- Não rode servidor local (`dev`, `preview`) sem pedido do usuário.
- Não faça `git commit`, `git push`, crie tags nem altere histórico sem autorização explícita; comandos Git de leitura são permitidos.

## Portão de Qualidade

Uma tarefa nunca é concluída enquanto houver erro de formatação, linter ou tipos.

Antes de dar a tarefa como finalizada:

1. Execute o comando de formatação.
2. Execute o comando de linter.
3. Execute o comando de typecheck.

Corrija qualquer erro ou warning antes de encerrar; não altere a configuração de lint ou TypeScript só para a validação passar. Os comandos estão na seção Comandos.
