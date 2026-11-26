# Gestalt: Continuidade

## Princípio

O olho segue linhas, curvas e alinhamentos contínuos e agrupa elementos dispostos ao longo deles. Alinhamentos consistentes criam caminhos de leitura previsíveis; quebras de alinhamento interrompem o fluxo e sugerem separação.

## Quando aplicar

- Formulários, listas, timelines, steppers, breadcrumbs e carrosséis.
- Layouts com elementos desalinhados ou com várias margens esquerdas.
- Fluxos sequenciais que precisam comunicar ordem.

## Regras práticas

- Um eixo de alinhamento à esquerda por seção; evite várias "bordas" de texto diferentes.
- Formulários em coluna única com labels acima dos campos para leitura vertical contínua.
- Números em tabelas alinhados à direita com `font-variant-numeric: tabular-nums`; texto à esquerda.
- Steppers e timelines com linha conectora contínua entre etapas.
- Em carrosséis e listas horizontais, deixe o próximo item parcialmente visível para indicar continuidade.
- Botões de ação alinhados ao eixo do conteúdo (início ou fim, consistente em toda a aplicação).

## Padrões de implementação

- Grid de layout com colunas e gutters definidos; conteúdo alinhado às colunas.
- Timeline vertical com linha via `border-left` ou pseudo-elemento.
- Scroll horizontal com `scroll-snap` e item cortado na borda.

```css
.timeline { border-inline-start: 2px solid var(--color-border); padding-inline-start: var(--space-4); }
td.amount { text-align: right; font-variant-numeric: tabular-nums; }
```

## Exemplo antes/depois

- Antes: formulário de cadastro em duas colunas com labels à esquerda de larguras variadas; o olho zigue-zagueia e usuários pulam campos.
- Depois: coluna única, labels acima, todos os campos alinhados à mesma margem; apenas pares naturais (cidade/UF) lado a lado.

## Anti-padrões e sinais de violação

- Campos de formulário com larguras e margens esquerdas diferentes sem motivo.
- Valores monetários alinhados à esquerda em tabela.
- Stepper sem conexão visual entre etapas.
- Carrossel cujos itens cabem exatamente na tela, sem pista de que há mais.

## Conflitos e limites

- Layouts em múltiplas colunas podem ser apropriados para dados de referência lidos (não preenchidos), como páginas de detalhe.
- Em RTL, o eixo se inverte; use propriedades lógicas (`inline-start`) para não quebrar continuidade.
- Continuidade visual deve coincidir com a ordem do DOM e do foco por teclado; ordem visual diferente da ordem de tabulação viola WCAG 2.4.3.

## Checklist de revisão

- [ ] Cada seção tem um eixo de alinhamento consistente?
- [ ] Formulários seguem fluxo vertical em coluna única?
- [ ] Números estão alinhados à direita com dígitos tabulares?
- [ ] Sequências (steppers, timelines) têm conexão visual contínua?
- [ ] A ordem visual coincide com a ordem do DOM e do foco?
