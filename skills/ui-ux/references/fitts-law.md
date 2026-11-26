# Lei de Fitts

## Princípio

O tempo para atingir um alvo depende da distância até ele e do seu tamanho. Alvos grandes e próximos do ponto de atenção são acionados mais rápido e com menos erro; alvos pequenos e distantes geram cliques errados e frustração.

## Quando aplicar

- Botões, links, ícones clicáveis, checkboxes, toggles e itens de menu.
- Interfaces mobile e touch, tabelas com ações por linha.
- Ações frequentes posicionadas longe do foco da tarefa.
- Ações destrutivas próximas de ações comuns.

## Regras práticas

- Área clicável mínima de 24×24 CSS px (WCAG 2.2, critério 2.5.8); recomendado 44×44 px para touch e ações principais.
- Espaçamento mínimo de 8 px entre alvos adjacentes em touch.
- Label de checkbox/radio deve ser clicável (associado ao input), não só o quadradinho.
- Linha inteira de lista clicável quando a ação principal é abrir o item.
- Ação primária perto do conteúdo que ela conclui (fim do formulário, rodapé do modal).
- Em mobile, ações principais na zona do polegar (parte inferior); evite cantos superiores para ações frequentes.
- Ações destrutivas afastadas das construtivas e com confirmação ou undo.

## Padrões de implementação

- Aumentar a área de toque sem aumentar o visual: padding ou pseudo-elemento.
- Barra de ação fixa (sticky) no rodapé em formulários longos e no mobile.
- Menu de contexto aberto junto ao cursor/linha, não em painel distante.
- Botões de largura total em telas estreitas.

```css
.icon-btn { position: relative; inline-size: 24px; block-size: 24px; }
.icon-btn::after { content: ""; position: absolute; inset: -10px; } /* alvo de 44px */
```

## Exemplo antes/depois

- Antes: tabela de clientes com ícones de 14 px para editar/excluir colados um ao outro; o botão "Salvar" do formulário de edição fica no topo da página.
- Depois: linha inteira abre o cliente; ações em menu `⋯` com alvo de 32–44 px; "Excluir" separado e com confirmação; "Salvar" em barra fixa no rodapé do formulário.

## Anti-padrões e sinais de violação

- Ícones clicáveis menores que 24×24 px sem área de toque estendida.
- Links de texto curto ("aqui") como única forma de executar ação importante.
- "Excluir" ao lado de "Salvar" com mesmo estilo e tamanho.
- Checkbox que só responde ao clique no quadrado.
- Botão de envio fora da área visível após preencher o formulário.

## Conflitos e limites

- Com Hick: mais botões visíveis e grandes aumentam opções; priorize tamanho apenas para ações frequentes.
- Com densidade de informação: tabelas densas podem usar alvos menores no desktop, mas nunca abaixo de 24 px e com foco visível.
- Não aumente o botão de "Aceitar" e reduza o "Recusar" para manipular escolhas (consentimento de cookies, upsell).
- Acessibilidade de teclado independe de Fitts: alvo grande sem foco visível continua inacessível.

## Checklist de revisão

- [ ] Todos os alvos interativos têm ao menos 24×24 px (44×44 em touch para ações principais)?
- [ ] A ação primária está próxima do fim da tarefa?
- [ ] Ações destrutivas estão separadas e protegidas?
- [ ] Labels de inputs de seleção são clicáveis?
- [ ] No mobile, ações frequentes estão alcançáveis com o polegar?
