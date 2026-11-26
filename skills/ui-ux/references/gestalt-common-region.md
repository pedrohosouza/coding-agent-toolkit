# Gestalt: Região Comum

## Princípio

Elementos dentro de uma mesma área delimitada (borda, fundo, card) são percebidos como grupo, mesmo que não estejam muito próximos. Região comum é um agrupamento mais forte que proximidade e é útil quando o espaço é limitado.

## Quando aplicar

- Cards de entidades (cliente, pedido, plano), painéis de dashboard, seções de configurações.
- Formulários longos com blocos de assuntos diferentes.
- Tabelas e listas densas em que o espaçamento não basta para separar grupos.

## Regras práticas

- Use contêiner (card, fundo, borda) quando proximidade sozinha não separa os grupos.
- Uma técnica de delimitação por nível: fundo OU borda OU sombra; não as três ao mesmo tempo.
- Evite cards dentro de cards dentro de cards; no máximo dois níveis de aninhamento.
- Padding interno do contêiner consistente (ex.: 16–24 px) e maior que o espaço entre elementos internos.
- Itens selecionados recebem fundo/borda de destaque, delimitando sua região.
- Ações que afetam o grupo ficam dentro do contêiner (header ou footer do card).

## Padrões de implementação

- `<fieldset>` com `<legend>` para seções de formulário (agrupa visual e semanticamente).
- Cards com header (título + ações), body e footer opcional.
- Linhas zebradas ou fundo de hover em tabelas; fundo de seleção em itens ativos.
- `<section aria-labelledby>` para regiões nomeadas.

```html
<section class="card" aria-labelledby="billing-title">
  <header><h2 id="billing-title">Cobrança</h2><button>Editar</button></header>
  …
</section>
```

## Exemplo antes/depois

- Antes: página de configurações com 30 opções em lista contínua; "Notificações por e-mail" e "Excluir conta" parecem do mesmo grupo.
- Depois: cards "Perfil", "Notificações", "Segurança" e uma "Zona de perigo" com borda vermelha contendo "Excluir conta".

## Anti-padrões e sinais de violação

- Card para cada elemento, mesmo isolado ("cardificação" de tudo).
- Três ou mais níveis de bordas aninhadas.
- Botão de ação de um card visualmente fora dele.
- Grupos semânticos diferentes dentro do mesmo contêiner.

## Conflitos e limites

- Contêineres demais criam ruído visual (Prägnanz); prefira proximidade e títulos quando o espaço permite.
- Em mobile, cards com padding grande desperdiçam largura; reduza padding ou use divisores.
- Borda e fundo precisam de contraste perceptível (3:1 para limites que identificam componentes).

## Checklist de revisão

- [ ] Grupos que proximidade não separa têm delimitação visual?
- [ ] Há no máximo dois níveis de contêineres aninhados?
- [ ] Ações do grupo estão dentro do contêiner?
- [ ] O agrupamento visual tem equivalente semântico (fieldset, section)?
- [ ] A delimitação usa uma técnica por nível, sem excesso?
