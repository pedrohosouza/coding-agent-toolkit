# Gestalt: Semelhança

## Princípio

Elementos que compartilham cor, forma, tamanho ou estilo são percebidos como do mesmo tipo e com a mesma função. Consistência visual ensina o usuário; inconsistência gera dúvida sobre o que é clicável e o que faz o quê.

## Quando aplicar

- Botões, links, badges de status, ícones, cards e itens de navegação.
- Telas em que elementos clicáveis e não clicáveis têm aparência parecida.
- Sistemas com múltiplos estilos para a mesma função.

## Regras práticas

- Mesma função, mesmo estilo em toda a aplicação: um único estilo de link, de botão primário, de botão destrutivo.
- Função diferente, estilo diferente: texto estático nunca pode parecer link ou botão.
- Cor de destaque (brand/primária) reservada a elementos interativos e ação principal; não use em títulos ou decoração.
- Status com mapeamento fixo: ex. verde = ativo/pago, amarelo = pendente, vermelho = erro/atrasado, cinza = inativo.
- Nunca use só cor para diferenciar: combine com texto, ícone ou forma (WCAG 1.4.1).
- Ícones de uma mesma família (mesmo peso de traço, estilo preenchido ou contorno).

## Padrões de implementação

- Componentes de design system com variantes nomeadas por intenção (`primary`, `secondary`, `danger`), não por cor.
- Componente `StatusBadge` com mapa central status → cor + rótulo + ícone.
- Tokens semânticos (`--color-danger`, `--color-success`) em vez de cores cruas nos componentes.

```css
.badge[data-status="overdue"] { background: var(--color-danger-subtle); color: var(--color-danger-text); }
```

## Exemplo antes/depois

- Antes: lista de faturas em que "Pago" é verde em uma tela e azul em outra; títulos de seção usam a mesma cor azul dos links e usuários clicam neles.
- Depois: `StatusBadge` único com "Pago" verde + ícone de check em todas as telas; títulos em cor neutra; azul apenas em elementos clicáveis.

## Anti-padrões e sinais de violação

- Dois estilos diferentes de botão primário em telas distintas.
- Texto colorido ou sublinhado que não é link.
- Mesmo status com cores diferentes entre telas.
- Status diferenciados apenas por cor, sem rótulo.
- Ícones misturando estilos (contorno e preenchido) sem significado.

## Conflitos e limites

- Com von Restorff: o destaque depende de quebrar a semelhança; use exceções raras e intencionais, não estilos aleatórios.
- Daltonismo e baixa visão: semelhança por cor sozinha não basta; garanta contraste de 4.5:1 para texto e 3:1 para componentes de interface.
- Semelhança excessiva pode esconder diferenças importantes (ex.: ação destrutiva com o mesmo estilo de ação comum).

## Checklist de revisão

- [ ] Cada função tem um único estilo consistente em toda a aplicação?
- [ ] Elementos não interativos são visualmente distintos de interativos?
- [ ] O mapeamento de cores de status é centralizado e consistente?
- [ ] Cor nunca é o único diferenciador?
- [ ] A cor de destaque está reservada para interação e ação principal?
