# Efeito Goal-Gradient

## Princípio

A motivação aumenta à medida que a pessoa percebe estar mais perto do objetivo. Mostrar progresso real e fazer o início parecer já avançado ajuda o usuário a concluir fluxos de várias etapas.

## Quando aplicar

- Onboarding, cadastros, checkouts, wizards e importações.
- Checklists de configuração e metas de uso.
- Fluxos com alta taxa de abandono nas etapas intermediárias.

## Regras práticas

- Exiba progresso em fluxos com 3 ou mais etapas: "Etapa 2 de 4" e/ou barra.
- Conte etapas já feitas pelo sistema ou pelo usuário (ex.: conta criada) como progresso real concluído.
- Coloque etapas curtas no início para gerar avanço rápido; deixe opcionais para o fim ou para depois.
- Barra de progresso determinada sempre que o total for conhecido; não regrida.
- Mostre o que falta de forma concreta ("Falta só confirmar o pagamento").
- Permita voltar a etapas anteriores sem perder dados.

## Padrões de implementação

- Stepper com etapas nomeadas e estados concluído/atual/pendente.
- Checklist de onboarding com itens pré-marcados quando já concluídos.
- Barra de progresso com `role="progressbar"`, `aria-valuenow`, `aria-valuemax`.
- Botão de avanço que nomeia o próximo passo ("Continuar para pagamento").

```html
<div role="progressbar" aria-valuenow="2" aria-valuemin="0" aria-valuemax="4" aria-label="Etapa 2 de 4"></div>
```

## Exemplo antes/depois

- Antes: configuração de loja com 6 telas sem indicação de etapa; botões dizem apenas "Próximo".
- Depois: stepper com "Conta criada" já marcado, "Loja", "Produtos", "Pagamento" e "Publicar"; botões "Continuar para Produtos"; etapa "Personalizar tema" movida para depois da publicação.

## Anti-padrões e sinais de violação

- Fluxo longo sem indicação de progresso.
- Barra de progresso falsa ou que volta atrás.
- Etapas mais longas e difíceis logo no início.
- Etapas opcionais apresentadas como obrigatórias para "inflar" o fluxo.
- Voltar uma etapa apaga dados.

## Conflitos e limites

- Progresso artificial (começar em 20% sem nada feito) é manipulação; conte apenas avanço real.
- Com Hick e Miller: dividir demais em etapas cria fluxo longo; agrupe o que é relacionado.
- Incentivos de gamificação (pontos, streaks) não podem pressionar ações contra o interesse do usuário.

## Checklist de revisão

- [ ] Fluxos com 3+ etapas mostram progresso atual e total?
- [ ] O progresso exibido é real e nunca regride?
- [ ] Etapas rápidas e essenciais vêm primeiro?
- [ ] Botões nomeiam o próximo passo?
- [ ] É possível voltar sem perder dados?
