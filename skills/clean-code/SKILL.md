---
name: clean-code
description: Aplica regras de clareza, simplicidade e manutenção ao escrever, refatorar ou revisar código.
---

# Clean Code

Use estas regras em toda alteração de código. Preserve convenções locais e deixe
explícito qualquer desvio necessário.

## Regras centrais

- Resolva a causa raiz com a menor solução clara.
- Mantenha responsabilidades coesas e dependências explícitas.
- Prefira código direto a abstrações, configuração ou generalização prematuras.
- Deixe código tocado igual ou mais claro, sem expandir o escopo da tarefa.

## Controle de fluxo

- **Nunca use `else` ou `else if`.** Use guard clauses, early returns, extração
  de funções, despacho ou polimorfismo.
- Não substitua `else` por ternários ou estruturas mais difíceis de entender
  apenas para contornar a regra.
- Prefira condições positivas e encapsule condições complexas com nomes claros.

## Funções e objetos

- Funções fazem uma coisa, têm poucos argumentos e evitam efeitos colaterais
  ocultos.
- Não use argumentos booleanos para selecionar comportamentos; exponha operações
  distintas.
- Use injeção de dependência e aplique a Lei de Deméter.
- Evite objetos híbridos que misturam comportamento de domínio com estruturas de
  transporte.
- Prefira objetos de valor quando primitivos escondem regras importantes.

## Legibilidade

- Use nomes que revelem intenção e variáveis explicativas quando reduzirem
  complexidade.
- Declare elementos próximos do uso e mantenha código relacionado próximo.
- Organize funções do fluxo principal para detalhes.
- Siga formatação e largura de linha definidas pelo projeto.

## Código autoexplicativo

- **Nunca escreva comentários no código.** Expresse intenção com nomes, tipos,
  constantes, funções pequenas e estrutura clara.
- Se uma parte exigir explicação, refatore até o próprio código comunicar o
  comportamento.
- Nunca deixe código comentado.

## Revisão

Antes de concluir, procure complexidade, repetição, acoplamento, efeitos
colaterais e nomes vagos. Simplifique somente dentro do escopo autorizado.
