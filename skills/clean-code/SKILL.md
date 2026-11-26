---
name: clean-code
description: Aplica regras de clareza, simplicidade e manutenção (sem else, sem comentários, funções pequenas, nomes que revelam intenção, sem números mágicos) ao escrever, refatorar ou revisar código. Use em toda criação ou alteração de código e em code review.
---

# Clean Code

Use estas regras em todo código novo ou alterado. Código existente fora do trecho tocado não é reescrito apenas para cumprir estas regras; refatoração ampla exige pedido explícito. Quando o projeto tiver convenção explícita diferente (lint, guia de estilo, instruções locais), siga o projeto.

## Regras centrais

- Resolva a causa raiz com a menor solução clara.
- Mantenha responsabilidades coesas e dependências explícitas.
- Prefira código direto a abstrações, configuração ou generalização prematuras.
- Deixe código tocado igual ou mais claro, sem expandir o escopo da tarefa.
- Evite código morto e dependências desnecessárias.
- Evite números e strings mágicos; use constantes ou enums nomeados.
- Trate erros explicitamente; não engula exceções.

## Controle de fluxo

- **Nunca use `else` ou `else if`** em código escrito ou alterado. Use guard clauses, early returns, extração
  de funções, despacho ou polimorfismo.
- Não substitua `else` por ternários ou estruturas mais difíceis de entender
  apenas para contornar a regra.
- Prefira condições positivas e encapsule condições complexas com nomes claros.

## Funções e objetos

- Funções fazem uma coisa, têm poucos argumentos e evitam efeitos colaterais
  ocultos.
- Não use argumentos booleanos para selecionar comportamentos; exponha operações
  distintas.
- Use injeção de dependência e inversão de dependência.
- Prefira objetos de valor quando primitivos escondem regras importantes.

## Legibilidade

- Use nomes que revelem intenção e variáveis explicativas quando reduzirem
  complexidade.
- Declare elementos próximos do uso e mantenha código relacionado próximo.
- Organize funções do fluxo principal para detalhes.
- Siga formatação e largura de linha definidas pelo projeto.

## Código autoexplicativo

- **Nunca escreva comentários no código**, inclusive TODO, FIXME e explicações de porquê. Expresse intenção com nomes, tipos,
  constantes, funções pequenas e estrutura clara.
- Se uma parte exigir explicação, refatore até o próprio código comunicar o
  comportamento.
- Nunca deixe código comentado.
- Ao tocar um trecho com comentários existentes, remova-os somente se o próprio código, após a alteração, já expressar o que eles diziam.
- Diretivas que não são comentários explicativos e são exigidas por ferramentas (shebang, pragmas, tipos JSDoc em projeto JavaScript sem TypeScript) seguem a configuração do projeto.

## Revisão

Antes de concluir, procure complexidade, repetição, acoplamento, efeitos
colaterais e nomes vagos. Simplifique somente dentro do escopo autorizado.
