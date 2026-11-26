# Efeito Zeigarnik

## Princípio

Tarefas interrompidas ou incompletas são lembradas melhor que as concluídas e geram vontade de terminá-las. A interface pode usar isso para ajudar o usuário a retomar e completar trabalhos que ele mesmo começou.

## Quando aplicar

- Onboarding, configuração inicial e perfis com várias etapas.
- Formulários longos, editores e qualquer trabalho que pode ser interrompido.
- Carrinhos, rascunhos e importações pendentes.

## Regras práticas

- Salve progresso automaticamente (rascunho) em formulários com mais de alguns campos ou etapas.
- Ao retornar, mostre onde o usuário parou e ofereça "Continuar de onde parou".
- Checklist de configuração com itens concluídos marcados e próximos passos claros.
- Indique itens pendentes com contagem objetiva ("2 de 5 concluídos").
- Permita dispensar ou adiar o checklist; não bloqueie o uso do produto.
- Lembretes de pendências apenas para tarefas que o usuário iniciou e que geram valor para ele.

## Padrões de implementação

- Autosave com indicador de estado ("Salvando…", "Salvo às 14:32").
- Lista de rascunhos acessível ("Rascunhos (3)").
- Card de onboarding no dashboard com checklist e barra de progresso.
- Persistência local (`localStorage`) como fallback para formulários longos, com limpeza após envio.

## Exemplo antes/depois

- Antes: usuário fecha a aba no meio do cadastro de um produto com 20 campos e perde tudo; ao voltar, encontra o formulário vazio.
- Depois: autosave a cada alteração; ao voltar, banner "Você tem um rascunho de 'Camiseta básica'. Continuar ou descartar?".

## Anti-padrões e sinais de violação

- Perda de dados ao navegar, recarregar ou expirar a sessão.
- Checklist de onboarding que não pode ser fechado.
- Notificações insistentes sobre tarefas que o usuário não iniciou ("Complete seu perfil" para desbloquear nada).
- Indicador de progresso que nunca chega a 100% ou que regride.

## Conflitos e limites

- Explorar tensão de tarefa incompleta para gerar engajamento artificial (perfil "75% completo" com itens inúteis) é manipulação.
- Autosave em dados sensíveis (pagamento, senhas) não deve persistir localmente.
- Com Parkinson: salvar e retomar reduz pressão; não force conclusão em uma sessão.
- Rascunhos precisam de expiração e limpeza clara para não acumular confusão.

## Checklist de revisão

- [ ] Trabalho em andamento é salvo automaticamente?
- [ ] O usuário consegue retomar exatamente de onde parou?
- [ ] Progresso pendente é exibido de forma objetiva?
- [ ] Checklists e lembretes podem ser dispensados?
- [ ] Dados sensíveis estão fora do armazenamento de rascunho?
