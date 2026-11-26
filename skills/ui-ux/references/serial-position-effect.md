# Efeito de Posição Serial

## Princípio

Em uma sequência, os primeiros e os últimos itens são mais lembrados que os do meio. Posicione informações e ações importantes nas extremidades e deixe o meio para conteúdo de menor prioridade.

## Quando aplicar

- Navegação (sidebar, tab bar, menus), listas de recursos e benefícios.
- Ordem de campos em formulários e de seções em uma página.
- Onboarding, tours e listas de instruções.

## Regras práticas

- Navegação: itens mais usados no início; itens de saída ou conta (Configurações, Sair) no fim.
- Tab bar mobile: até 5 itens, os principais nas extremidades e no centro de fácil acesso.
- Listas de benefícios ou recursos: o mais relevante primeiro, o segundo mais relevante por último.
- Páginas: a informação ou ação principal acima da dobra; resumo e próximo passo no fim.
- Instruções: comece pelo que o usuário precisa fazer agora e termine com o resultado esperado.
- Não esconda informação crítica (taxas, condições) no meio de listas longas.

## Padrões de implementação

- Sidebar com grupo principal no topo e conta/ajuda fixos no rodapé.
- Resumo no início e CTA repetido no fim de páginas longas.
- Mensagens de erro com o problema no início e a ação de correção no fim.
- Listas ordenáveis pelo usuário (favoritos fixados no topo).

## Exemplo antes/depois

- Antes: sidebar de app de projetos com "Projetos" (item mais usado) na 6ª posição entre 10 itens, e "Sair" no meio.
- Depois: "Início" e "Projetos" no topo; itens secundários no meio; "Configurações" e menu da conta fixos no rodapé da sidebar.

## Anti-padrões e sinais de violação

- Ação ou link mais usado perdido no meio de uma lista.
- Condição importante (multa, renovação automática) no meio de um texto longo.
- CTA apenas no topo de uma página longa.
- Ordem de menu alfabética quando a frequência de uso é muito desigual.

## Conflitos e limites

- Com Jakob: posições convencionais (logo à esquerda, conta à direita) vencem a otimização de ordem.
- Reordenar menus dinamicamente por uso quebra memória espacial; prefira ordem estável e favoritos explícitos.
- Não use o "meio esquecível" para esconder informações que o usuário tem direito de saber (preço total, cancelamento).

## Checklist de revisão

- [ ] Os itens mais importantes estão no início ou no fim das listas?
- [ ] A navegação segue ordem estável e prioriza os itens mais usados?
- [ ] Páginas longas repetem a ação principal no fim?
- [ ] Informação crítica não está enterrada no meio?
- [ ] A ordem respeita convenções familiares?
