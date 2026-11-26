# Conectividade Uniforme

## Princípio

Elementos ligados visualmente por linhas, setas ou um contêiner contínuo são percebidos como mais relacionados do que elementos apenas próximos ou semelhantes. A conexão explícita é o sinal de relação mais forte entre os princípios de agrupamento.

## Quando aplicar

- Steppers, wizards, timelines, pipelines e fluxos de status.
- Relações hierárquicas (árvores, organogramas) e dependências.
- Controles ligados a um conteúdo específico (abas e painel, tooltip e alvo).
- Grupos de botões de opção mutuamente exclusiva (segmented control).

## Regras práticas

- Use linha/conector quando a relação é de sequência ou dependência; use região comum quando é de pertencimento.
- Em steppers, o conector entre etapas muda de estado (concluído, atual, pendente) junto com as etapas.
- Abas: a aba ativa se funde visualmente ao painel (mesmo fundo, sem borda entre eles).
- Tooltips e popovers com seta apontando para o elemento de origem.
- Segmented controls em um contêiner contínuo; opções separadas parecem ações independentes.
- Não conecte elementos sem relação real; linhas decorativas criam relações falsas.

## Padrões de implementação

- Stepper com `<ol>`, `aria-current="step"` na etapa atual e conectores via pseudo-elementos.
- Abas com `role="tablist"`, `role="tab"`, `aria-selected` e `role="tabpanel"`.
- Árvores com linhas guia de indentação.
- Kanban com colunas contínuas para cada status.

```html
<ol class="stepper">
  <li class="done">Dados</li><li aria-current="step">Pagamento</li><li>Revisão</li>
</ol>
```

## Exemplo antes/depois

- Antes: status do pedido mostrado como quatro badges soltos ("Recebido", "Separado", "Enviado", "Entregue") com o atual em negrito.
- Depois: trilha horizontal com conectores; etapas concluídas e conectores preenchidos, etapa atual destacada, futuras em cinza.

## Anti-padrões e sinais de violação

- Etapas de wizard sem conexão visual, parecendo opções independentes.
- Aba ativa separada do painel por borda, como se fossem blocos diferentes.
- Popover sem indicação de qual elemento o originou.
- Linhas decorativas ligando elementos não relacionados.

## Conflitos e limites

- Conexões demais (diagramas densos) viram ruído; simplifique ou ofereça visão em lista.
- Conexão visual não é comunicada a leitores de tela; use estrutura semântica (`<ol>`, roles ARIA, `aria-controls`).
- Em telas estreitas, conectores horizontais devem virar verticais em vez de quebrar.

## Checklist de revisão

- [ ] Sequências e dependências usam conexão visual explícita?
- [ ] O estado dos conectores acompanha o estado das etapas?
- [ ] Abas e popovers estão visualmente ligados ao seu conteúdo/origem?
- [ ] Não há conexões sugerindo relações inexistentes?
- [ ] A relação também está na semântica (lista ordenada, ARIA)?
