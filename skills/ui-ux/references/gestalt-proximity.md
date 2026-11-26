# Gestalt: Proximidade

## Princípio

Elementos próximos são percebidos como relacionados. O espaçamento é a ferramenta mais barata de agrupamento: a distância entre grupos deve ser claramente maior que a distância dentro de cada grupo.

## Quando aplicar

- Formulários (label, campo, ajuda e erro), cards, listas e toolbars.
- Telas em que o usuário associa informação ao elemento errado.
- Layouts com espaçamento uniforme em tudo, sem hierarquia.

## Regras práticas

- Use uma escala de espaçamento (ex.: 4, 8, 12, 16, 24, 32, 48 px) via tokens; não valores arbitrários.
- Espaço entre grupos ≥ 2× o espaço interno do grupo (ex.: 8 px dentro, 24 px entre).
- Label a 4–8 px do seu campo; campo seguinte a 16–24 px. O label nunca pode ficar equidistante de dois campos.
- Mensagem de erro e texto de ajuda colados ao campo que descrevem.
- Botões de ação próximos ao conteúdo que afetam (ex.: "Salvar" no fim da seção, não no topo da página).
- Ações de item dentro do item, não em toolbar distante.

## Padrões de implementação

- Tokens de espaçamento (`--space-1` … `--space-8`) e utilitários de `gap` em flex/grid.
- Stack vertical com `gap` pequeno dentro do grupo e margem maior entre grupos.

```css
.field { display: grid; gap: var(--space-1); }      /* label, input, ajuda */
.form-section { display: grid; gap: var(--space-5); } /* entre campos */
.form > .form-section + .form-section { margin-top: var(--space-8); }
```

## Exemplo antes/depois

- Antes: formulário de perfil com 16 px uniformes entre todos os elementos; o label "Telefone" parece pertencer ao campo de e-mail acima; erro aparece no topo da página.
- Depois: label a 4 px do campo, 20 px entre campos, 40 px entre seções "Dados pessoais" e "Contato"; erro logo abaixo do campo inválido.

## Anti-padrões e sinais de violação

- Espaçamento igual entre todos os elementos da tela.
- Label mais perto do campo anterior que do seu próprio.
- Botões de ação de um card posicionados fora dele.
- Valores de margem arbitrários (13 px, 17 px, 22 px) sem escala.

## Conflitos e limites

- Proximidade sozinha falha quando o espaço é escasso (mobile, tabelas densas); combine com região comum (fundo, borda) ou divisores.
- Em layouts responsivos, colunas que viram linhas podem aproximar itens não relacionados; revise em cada breakpoint.
- Proximidade visual não cria relação para leitores de tela: associe com `<label for>`, `aria-describedby` e `<fieldset>`.

## Checklist de revisão

- [ ] O espaço entre grupos é visivelmente maior que dentro dos grupos?
- [ ] Cada label está inequivocamente mais próximo do seu campo?
- [ ] Erros e ajudas ficam junto ao campo correspondente?
- [ ] O espaçamento segue uma escala de tokens?
- [ ] As relações visuais também existem na semântica (label, fieldset, aria)?
