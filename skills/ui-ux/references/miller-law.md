# Lei de Miller

## Princípio

A memória de trabalho retém poucos itens por vez. A interface não deve exigir que o usuário memorize informações entre telas ou processe longas sequências não agrupadas; agrupar em blocos (chunking) torna o conteúdo digerível.

## Quando aplicar

- Números longos (telefone, CPF, cartão, códigos), listas extensas, menus planos.
- Fluxos em que o usuário precisa lembrar algo de uma tela anterior.
- Formulários longos sem seções, tabelas com dezenas de colunas.

## Regras práticas

- Não use "7 ± 2" como limite rígido de itens em menu; use como sinal para agrupar.
- Formate entradas e saídas em blocos: `123.456.789-00`, `(11) 98765-4321`, `4111 1111 1111 1111`.
- Formulários com mais de ~6–8 campos: divida em seções com título ou em etapas.
- Nunca peça ao usuário para copiar/lembrar um valor de outra tela; mostre-o no contexto ou preencha automaticamente.
- Em comparações, mantenha os itens comparados visíveis lado a lado.
- Tabelas: mostre colunas essenciais por padrão; demais via seletor de colunas.

## Padrões de implementação

- Máscaras de entrada que agrupam dígitos visualmente sem bloquear colagem.
- Fieldsets com `<legend>` para seções de formulário.
- Resumo persistente (sidebar ou card) em fluxos de várias etapas, mostrando escolhas anteriores.
- Recentes e favoritos para evitar que o usuário lembre nomes exatos.
- Autocomplete em vez de campo livre para entidades existentes.

```html
<fieldset>
  <legend>Endereço de cobrança</legend>
  …
</fieldset>
```

## Exemplo antes/depois

- Antes: checkout em 4 etapas; na etapa de pagamento o usuário não vê mais o plano escolhido nem o valor, e o código de cupom de 16 caracteres é exibido sem separação.
- Depois: card de resumo fixo com plano, ciclo e valor em todas as etapas; cupom exibido como `ABCD-EFGH-IJKL-MNOP`.

## Anti-padrões e sinais de violação

- Usuário precisa abrir outra aba para consultar um dado e voltar.
- Código de verificação ou chave exibido como sequência contínua longa.
- Menu com 20 itens no mesmo nível, sem agrupamento.
- Formulário de página única com 25 campos sem seções.
- Mensagens de erro que referenciam algo que não está mais na tela.

## Conflitos e limites

- O limite de Miller é sobre memória, não sobre quantidade visível: uma lista longa e escaneável (ex.: resultados de busca) não precisa ser cortada em 7.
- Dividir demais em etapas aumenta cliques e esconde contexto; prefira seções na mesma página quando os campos são relacionados.
- Máscaras rígidas podem quebrar colagem e leitores de tela; aceite entrada sem máscara e formate depois.

## Checklist de revisão

- [ ] O usuário nunca precisa memorizar dados entre telas?
- [ ] Sequências longas de caracteres estão agrupadas visualmente?
- [ ] Formulários e menus extensos estão organizados em grupos com título?
- [ ] Fluxos de várias etapas mostram um resumo das escolhas anteriores?
- [ ] Entidades existentes são escolhidas por autocomplete, não digitadas de memória?
