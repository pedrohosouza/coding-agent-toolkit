# Lei de Parkinson

## Princípio

O trabalho se expande para ocupar o tempo disponível. Em interfaces, tarefas sem limite claro de escopo ou tempo tendem a demorar mais; reduzir o esforço esperado e deixar o tamanho da tarefa explícito ajuda o usuário a concluí-la.

## Quando aplicar

- Formulários, cadastros, onboarding e checkouts com duração indefinida.
- Fluxos que o usuário adia ou abandona por parecerem longos.
- Tarefas que poderiam ser feitas em menos passos com autopreenchimento.

## Regras práticas

- Informe o tamanho da tarefa antes de começar: "3 etapas", "cerca de 2 minutos" (apenas se a estimativa for real).
- Mostre progresso durante a tarefa (etapa atual / total).
- Reduza o tempo necessário: autopreenchimento, defaults, login social, pagamento salvo.
- Prazos reais (expiração de convite, trial) devem ser exibidos com data exata, não só contagem regressiva.
- Divida tarefas grandes em entregas menores que podem ser concluídas e salvas.

## Padrões de implementação

- Stepper com rótulos de etapa e indicador "Etapa 2 de 3".
- `autocomplete` nos inputs para preenchimento do navegador.
- Checkout expresso (dados salvos, um clique para confirmar).
- Rascunho automático para permitir terminar depois sem perda.
- Banner de prazo com data absoluta: "Seu teste termina em 12/03 (5 dias)".

## Exemplo antes/depois

- Antes: onboarding de nova conta abre uma página única com 18 campos, sem indicação de quanto falta.
- Depois: "Configure sua conta em 3 passos (cerca de 2 minutos)"; etapa 1 só com nome da empresa e equipe; demais dados opcionais adiados para depois do primeiro uso.

## Anti-padrões e sinais de violação

- Fluxo longo sem indicação de etapas ou fim.
- Estimativas de tempo otimistas que não correspondem à realidade.
- Campos que poderiam ser preenchidos pelo navegador sem `autocomplete`.
- Tarefa que obriga concluir tudo de uma vez, sem salvar progresso.

## Conflitos e limites

- Timers e escassez falsa ("oferta acaba em 09:59" que reinicia) são dark patterns; use apenas prazos reais.
- Sessões com tempo limite devem avisar antes de expirar e permitir estender (WCAG 2.2.1, ajuste de tempo).
- Pressão de tempo aumenta erros em tarefas críticas (financeiras, jurídicas); não apresse o usuário nesses casos.
- Com Zeigarnik: salvar e retomar é preferível a forçar conclusão imediata.

## Checklist de revisão

- [ ] O usuário sabe o tamanho da tarefa antes de começar?
- [ ] Há indicador de progresso em fluxos de várias etapas?
- [ ] O sistema reduz tempo com autopreenchimento e defaults?
- [ ] Prazos exibidos são reais e com data absoluta?
- [ ] Sessões com tempo limite avisam e permitem estender?
