# Efeito von Restorff (Isolamento)

## Princípio

Entre itens semelhantes, aquele que se diferencia é mais notado e lembrado. Destaque visual é um recurso escasso: funciona quando usado para o que realmente importa e perde efeito quando tudo compete por atenção.

## Quando aplicar

- Definição da ação primária de uma tela ou modal.
- Plano recomendado em tabela de preços, alertas críticos, novidades.
- Telas em que "tudo é destaque" e nada se sobressai.
- Avisos importantes ignorados pelos usuários.

## Regras práticas

- Uma ação primária com cor de destaque por contexto; demais em estilos neutros.
- Destaque por mais de um canal: cor + tamanho, peso, ícone ou posição (não só cor).
- Alertas críticos com cor semântica, ícone e texto explícito; persistentes até resolvidos, se bloqueiam a tarefa.
- Badges de "Novo" ou contadores apenas onde há ação real; remova após visto.
- Ação destrutiva destacada em cor de perigo apenas no momento de confirmação, não como chamariz.
- Plano recomendado: um único, com rótulo de texto ("Recomendado"), não apenas borda colorida.

## Padrões de implementação

- Variantes `primary` / `secondary` / `ghost` / `danger` com regra de uma `primary` por grupo.
- Alertas inline (`role="alert"` para erros urgentes, `role="status"` para informativos).
- Destaque temporário (highlight que esmaece) para item recém-criado ou alterado em uma lista.
- Badge de notificação com contagem numérica e rótulo acessível.

## Exemplo antes/depois

- Antes: página de preços com três planos, todos com botão azul, borda colorida e selo ("Popular", "Melhor valor", "Completo").
- Depois: um único plano com selo "Recomendado", botão primário e leve elevação; os outros com botão secundário e sem selo.

## Anti-padrões e sinais de violação

- Vários botões primários na mesma tela.
- Banners, badges e cores vibrantes competindo pela atenção.
- Mensagens críticas no mesmo estilo de textos informativos.
- Destaque comunicado só por cor.
- Usuários ignoram alertas porque há alertas em todas as telas (cegueira a banners).

## Conflitos e limites

- Com Semelhança: o destaque só funciona sobre uma base consistente; não crie estilos novos para cada destaque.
- Animações de chamariz (piscar, pulsar) distraem e podem violar WCAG 2.2.2 e 2.3.1; respeite `prefers-reduced-motion`.
- Não destaque a opção mais lucrativa disfarçando as demais (ex.: "Recusar" quase invisível); isso é dark pattern.

## Checklist de revisão

- [ ] Há exatamente um elemento de destaque principal por contexto?
- [ ] O destaque usa mais de um canal além da cor?
- [ ] Alertas críticos são distinguíveis de mensagens informativas?
- [ ] Badges e selos indicam algo real e acionável?
- [ ] As opções não destacadas continuam legíveis e acessíveis?
