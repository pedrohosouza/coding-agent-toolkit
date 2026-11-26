# Efeito Estética-Usabilidade

## Princípio

Usuários percebem interfaces visualmente agradáveis como mais fáceis de usar e toleram melhor pequenos problemas nelas. Esse efeito ajuda na confiança, mas pode mascarar problemas reais de usabilidade em testes e revisões.

## Quando aplicar

- Telas com aparência inconsistente, desalinhada ou "inacabada".
- Produtos em que confiança é crítica (financeiro, saúde, dados sensíveis).
- Revisões e testes em que feedback positivo sobre o visual esconde falhas de fluxo.

## Regras práticas

- Base de qualidade visual: escala de espaçamento, escala tipográfica, paleta limitada e alinhamento a grid.
- Comprimento de linha de texto corrido entre ~45 e 75 caracteres; altura de linha ~1.4–1.6 para corpo.
- Contraste mínimo WCAG: 4.5:1 para texto normal, 3:1 para texto grande e componentes de interface.
- Estados visuais completos e consistentes: hover, focus visível, active, disabled, loading, erro.
- Imagens e ícones com resolução adequada e estilo único.
- Polimento de detalhes: sem textos cortados, layout shift, bordas desalinhadas ou overflow em mobile.

## Padrões de implementação

- Design system com tokens e componentes reutilizáveis.
- `:focus-visible` estilizado em vez de removido.
- Transições curtas (~150–250 ms) em mudanças de estado, desligadas com `prefers-reduced-motion`.
- Revisão em vários breakpoints e com dados reais (nomes longos, listas vazias, valores grandes).

```css
:focus-visible { outline: 2px solid var(--color-focus); outline-offset: 2px; }
@media (prefers-reduced-motion: reduce) { * { transition: none !important; } }
```

## Exemplo antes/depois

- Antes: tela de pagamento com fontes misturadas, botões de alturas diferentes, campos desalinhados e textos cortados no mobile; usuários desconfiam e abandonam.
- Depois: tipografia e espaçamento por tokens, campos alinhados, selo de segurança discreto, estados de foco e erro consistentes; fluxo idêntico, mas percebido como confiável.

## Anti-padrões e sinais de violação

- `outline: none` sem substituto de foco.
- Texto de baixo contraste por "elegância" (cinza claro sobre branco).
- Layout testado só com dados fictícios curtos.
- Visual caprichado em telas de marketing e descuidado nas telas do produto.
- Testes de usabilidade com elogios ao visual e tarefas não concluídas.

## Conflitos e limites

- Beleza não substitui usabilidade: avalie taxa de conclusão e erros, não apenas satisfação declarada.
- Estética nunca justifica contraste insuficiente, fontes pequenas ou remoção de foco.
- Animações e efeitos visuais não podem atrasar a interação (Doherty).
- Visual polido usado para dar credibilidade a práticas enganosas é dark pattern.

## Checklist de revisão

- [ ] Espaçamento, tipografia e cores seguem tokens consistentes?
- [ ] Contraste atende WCAG e o foco é visível?
- [ ] Todos os estados de componentes estão estilizados?
- [ ] A tela foi revisada com dados reais e em vários breakpoints?
- [ ] A usabilidade foi validada independentemente da estética?
