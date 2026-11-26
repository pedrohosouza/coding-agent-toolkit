# Princípio de Pareto

## Princípio

Uma pequena parte das funcionalidades, telas e ações concentra a maior parte do uso e do valor. Otimize primeiro esses caminhos críticos e não dê a recursos raros o mesmo destaque que aos frequentes.

## Quando aplicar

- Priorização de backlog de UX, melhorias e correções.
- Definição do que aparece na navegação principal, no dashboard e nas ações visíveis.
- Telas com muitos recursos de peso visual igual.
- Decisão sobre onde investir em performance, testes e polimento.

## Regras práticas

- Identifique os fluxos principais com dados reais (analytics, logs, suporte) antes de redesenhar; não suponha.
- Ações frequentes: visíveis, acessíveis em um clique e com atalho de teclado quando fizer sentido.
- Ações raras: em menus secundários, configurações ou divulgação progressiva.
- Dashboard: priorize as poucas métricas que orientam decisão; demais em relatórios.
- Garanta que os fluxos críticos tenham todos os estados (loading, vazio, erro, sucesso) antes de polir fluxos secundários.
- Bugs e lentidão nos caminhos críticos têm prioridade sobre novos recursos.

## Padrões de implementação

- Navegação com itens principais visíveis e "Mais" para o restante.
- Ações rápidas ("Nova fatura", "Novo cliente") no topo do dashboard.
- Command palette para recursos raros, sem poluir a interface.
- Configurações organizadas por frequência, com as comuns no topo.

## Exemplo antes/depois

- Antes: sistema de faturamento dá o mesmo destaque a 12 módulos na sidebar; emitir fatura (ação mais usada) exige três cliques a partir do dashboard.
- Depois: botão "Emitir fatura" fixo no header; sidebar com Faturas, Clientes e Relatórios no topo; módulos raros agrupados em "Mais".

## Anti-padrões e sinais de violação

- Recursos raros ocupando espaço nobre no dashboard.
- Fluxo principal com mais passos que fluxos secundários.
- Esforço de polimento em telas pouco acessadas enquanto o fluxo principal tem erros.
- Decisões de priorização sem nenhum dado de uso.

## Conflitos e limites

- "Pouco usado" não é "pouco importante": exportar dados, cancelar conta e recuperação de senha são raros, mas críticos e devem ser encontráveis.
- Acessibilidade não é "caso de 20%": é requisito para todos os fluxos.
- Usuários avançados e minoritários podem ser os de maior receita; pondere uso por valor.
- Não esconda funcionalidades obrigatórias por lei (privacidade, cancelamento) alegando baixo uso.

## Checklist de revisão

- [ ] Os fluxos mais usados foram identificados com dados?
- [ ] Ações frequentes estão a um clique e visualmente priorizadas?
- [ ] Recursos raros estão acessíveis sem poluir a tela principal?
- [ ] Fluxos críticos têm todos os estados implementados?
- [ ] Ações raras mas críticas continuam fáceis de encontrar?
