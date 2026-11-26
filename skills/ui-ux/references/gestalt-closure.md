# Gestalt: Fechamento

## Princípio

O cérebro completa formas e padrões incompletos, percebendo o todo mesmo com partes ausentes. Na interface, isso permite sugerir continuidade e estrutura com menos elementos, desde que a pista seja clara.

## Quando aplicar

- Listas e carrosséis com mais conteúdo além da área visível.
- Ícones, logos e indicadores de progresso.
- Layouts minimalistas sem bordas explícitas.
- Usuários que não percebem que existe conteúdo adicional (scroll, abas, itens ocultos).

## Regras práticas

- Corte o último item visível em listas horizontais para sinalizar que há mais (ex.: mostrar ~1/3 do próximo card).
- Em áreas com scroll interno, use sombra ou fade na borda enquanto houver conteúdo oculto.
- Indicadores de progresso mostram a forma completa (trilho) e a parte preenchida.
- Ícones podem ser simplificados, mas devem ser reconhecíveis em 16–24 px.
- Não dependa de fechamento para estrutura crítica: campos de formulário precisam de borda ou fundo perceptível (contraste mínimo de 3:1 para limites de componentes).

## Padrões de implementação

- Fade de borda em contêiner com overflow.
- Progresso circular ou linear com trilho visível.
- Skeleton screens: blocos que sugerem a forma do conteúdo final.

```css
.scroll-x { overflow-x: auto; mask-image: linear-gradient(to right, #000 85%, transparent); }
.progress { background: var(--color-track); } .progress > span { background: var(--color-primary); }
```

## Exemplo antes/depois

- Antes: seção "Integrações" mostra exatamente 4 cards que preenchem a largura; usuários não descobrem as outras 12 integrações.
- Depois: o 5º card aparece cortado na borda com fade e setas de navegação; o scroll horizontal fica óbvio.

## Anti-padrões e sinais de violação

- Conteúdo cortado exatamente na borda, parecendo terminado.
- Input sem borda visível, só com linha de placeholder.
- Ícones tão abstratos que o usuário não completa a forma.
- Barra de progresso sem trilho, impossível saber quanto falta.

## Conflitos e limites

- Minimalismo excessivo prejudica acessibilidade: usuários com baixa visão não completam formas de baixo contraste.
- Fade e cortes não substituem controles acessíveis; carrosséis precisam de botões navegáveis por teclado.
- Em mobile, itens cortados devem continuar com alvo de toque adequado.

## Checklist de revisão

- [ ] Conteúdo além da área visível é sinalizado por corte, fade ou sombra?
- [ ] Indicadores de progresso mostram o total e o preenchido?
- [ ] Ícones simplificados são reconhecíveis no tamanho usado?
- [ ] Limites de inputs e controles têm contraste suficiente?
- [ ] Há controles acessíveis além da pista visual?
