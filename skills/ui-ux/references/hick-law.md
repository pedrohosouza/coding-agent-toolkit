# Lei de Hick

## Princípio

O tempo para decidir cresce com o número e a complexidade das opções apresentadas ao mesmo tempo. Menos opções visíveis, mais bem rotuladas e ordenadas, produzem decisões mais rápidas e com menos erro.

## Quando aplicar

- Menus, navbars e sidebars com muitos itens no mesmo nível.
- Telas com vários botões de peso visual igual competindo pela ação principal.
- Selects e dropdowns longos, páginas de planos, onboarding com muitas perguntas.
- Usuário hesita, abandona ou escolhe errado em um ponto de decisão.

## Regras práticas

- Uma ação primária por tela ou seção; demais ações como secundárias (outline/ghost) ou em menu "Mais ações".
- Navegação principal: até ~7 itens de primeiro nível; acima disso, agrupe em seções com títulos.
- Dropdown com mais de ~10 opções: adicione busca (combobox). Acima de ~50: busca obrigatória, sugestões recentes no topo.
- Página de preços: 3 planos costuma ser suficiente; destaque um como recomendado.
- Pré-selecione um default sensato quando houver escolha óbvia para a maioria.
- Ordene opções por frequência de uso ou de forma previsível (alfabética, cronológica), nunca aleatória.
- Rótulos com verbo + objeto ("Criar fatura"), não termos ambíguos ("Processar").

## Padrões de implementação

- Divulgação progressiva: opções avançadas em accordion "Configurações avançadas" ou em etapa posterior.
- Stepper para dividir uma decisão grande em decisões pequenas e sequenciais.
- Menu de overflow (`⋯`) para ações raras em linhas de tabela.
- Combobox com filtro para listas longas (países, clientes, produtos).
- Botão dividido (split button) quando há uma ação comum e variantes raras.

```html
<button class="btn-primary">Salvar</button>
<button class="btn-ghost">Cancelar</button>
<details><summary>Mais ações</summary>…</details>
```

## Exemplo antes/depois

- Antes: cabeçalho de detalhe de pedido com 8 botões iguais (Editar, Duplicar, Exportar PDF, Exportar CSV, Arquivar, Excluir, Enviar, Imprimir).
- Depois: "Enviar ao cliente" como primário, "Editar" como secundário, demais ações em menu "Mais ações", com "Excluir" separado por divisor e em cor de perigo.

## Anti-padrões e sinais de violação

- Dois ou mais botões primários lado a lado.
- Select nativo com dezenas de opções e sem busca.
- Formulário que exibe todos os campos opcionais por padrão.
- Menus com itens de nomes parecidos ("Relatórios", "Análises", "Insights").
- Usuário precisa ler todas as opções para achar a mais comum.

## Conflitos e limites

- Com Fitts: esconder ações em menus aumenta cliques; mantenha visíveis as ações usadas com frequência, esconda apenas as raras.
- Usuários experientes toleram densidade (dashboards, ferramentas de operação); ofereça atalhos de teclado e command palette em vez de remover opções.
- Reduzir opções não pode esconder ações obrigatórias por lei ou contrato (ex.: cancelar assinatura deve ser tão acessível quanto assinar).
- Não use "default pré-selecionado" para empurrar opções caras ou consentimentos (dark pattern).

## Checklist de revisão

- [ ] Existe exatamente uma ação primária visível por contexto?
- [ ] Listas com mais de ~10 opções têm busca ou agrupamento?
- [ ] Opções avançadas ou raras estão atrás de divulgação progressiva?
- [ ] Há um default sensato e ético quando aplicável?
- [ ] As opções estão ordenadas por frequência ou critério previsível?
