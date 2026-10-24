---
name: ui-ux
description: Aplica 25 princípios de UX, psicologia cognitiva, percepção visual e usabilidade ao criar, revisar ou refatorar interfaces, telas, componentes, fluxos e jornadas. Cobre Lei de Hick, Fitts, Jakob, Miller, Doherty, Tesler, Postel, Parkinson, Navalha de Occam, Pareto, princípios da Gestalt, Proximidade, Semelhança, Continuidade, Fechamento, Região Comum, Conectividade Uniforme, Pragnanz, von Restorff, Posição Serial, Zeigarnik, Pico-Fim, Carga Cognitiva, Goal-Gradient, estética-usabilidade e Modelo Mental. Use ao definir hierarquia, navegação, formulários, listas, onboarding, feedback, acessibilidade, estados de UI ou decisões de interface.
---

# UI/UX Standards

Estas regras orientam decisões de interface com base em comportamento humano, cognição, percepção e usabilidade.

## Princípios universais

- Reduza esforço cognitivo.
- Prefira padrões familiares.
- Torne ações importantes fáceis de encontrar e executar.
- Agrupe informações relacionadas.
- Reduza escolhas desnecessárias.
- Dê feedback imediato e claro.
- Projete estados de loading, empty, error e success.
- Garanta acessibilidade, contraste, foco visível e navegação por teclado.
- Não transfira complexidade evitável ao usuário.
- Prefira a solução mais simples que resolva o problema.
- Priorize os fluxos e ações mais usados.

## Hierarquia de decisão

Ao criar ou revisar uma interface, pergunte:

1. O usuário entende o que esta tela faz?
2. A ação principal está clara?
3. Há escolhas ou informações desnecessárias?
4. Os elementos relacionados estão agrupados?
5. O feedback é imediato?
6. Os estados de erro e vazio estão definidos?
7. A interface funciona por teclado?
8. A experiência respeita padrões que o usuário já conhece?
9. O sistema está absorvendo complexidade que o usuário não precisa resolver?
10. O fluxo termina com confirmação e próximo passo claros?

## Roteamento de referências

Leia apenas a referência necessária:

- Redução de escolhas e decisão: `references/hick-law.md`
- Alvos, ações e interação: `references/fitts-law.md`
- Padrões familiares e convenções: `references/jakob-law.md`
- Carga cognitiva e agrupamento: `references/miller-law.md`
- Velocidade de resposta e feedback: `references/doherty-threshold.md`
- Complexidade do sistema: `references/tesler-law.md`
- Tolerância de entrada: `references/postel-law.md`
- Prazos e estimativas: `references/parkinson-law.md`
- Simplificação: `references/occams-razor.md`
- Priorização: `references/pareto-principle.md`
- Proximidade e percepção de grupo: `references/gestalt-proximity.md`
- Semelhança visual: `references/gestalt-similarity.md`
- Continuidade visual: `references/gestalt-continuity.md`
- Fechamento visual: `references/gestalt-closure.md`
- Região comum: `references/gestalt-common-region.md`
- Conectividade uniforme: `references/uniform-connectedness.md`
- Simplicidade perceptual: `references/pragnanz-law.md`
- Destaque visual e atenção: `references/von-restorff-effect.md`
- Memória e ordem de informações: `references/serial-position-effect.md`
- Tarefas incompletas e progresso: `references/zeigarnik-effect.md`
- Experiência memorável: `references/peak-end-rule.md`
- Carga cognitiva: `references/cognitive-load.md`
- Proximidade do objetivo e progresso: `references/goal-gradient-effect.md`
- Estética e percepção de usabilidade: `references/aesthetic-usability-effect.md`
- Expectativas e modelo mental: `references/mental-model.md`

## Regras de aplicação

- Não aplique todas as leis ao mesmo tempo.
- Identifique o problema principal da interface antes de escolher a lei aplicável.
- Use as leis como critérios de decisão, não como checklist rígido.
- Quando duas leis entrarem em conflito, priorize a usabilidade real e o contexto do usuário.
- Não use princípios de UX para justificar padrões manipuladores.
