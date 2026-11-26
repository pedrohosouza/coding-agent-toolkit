# Lei de Tesler (Conservação da Complexidade)

## Princípio

Todo processo tem uma complexidade mínima que não pode ser eliminada, apenas transferida. A decisão de design é quem absorve essa complexidade: o sistema (desenvolvimento, dados, automação) ou o usuário (cada vez que usa).

## Quando aplicar

- Formulários que pedem dados que o sistema já tem ou pode inferir.
- Configurações expostas ao usuário que poderiam ter defaults.
- Fluxos que exigem formatação manual, cálculos ou conhecimento técnico.
- Discussões sobre "simplificar" removendo funcionalidade necessária.

## Regras práticas

- Não peça o que pode ser derivado: cidade/UF a partir do CEP, bandeira a partir do número do cartão, fuso a partir do navegador.
- Todo campo opcional precisa de justificativa; todo obrigatório, de uso real.
- Defaults inteligentes baseados no contexto (moeda do país, última opção usada, organização atual).
- Cálculos (totais, impostos, datas de vencimento) feitos pelo sistema e exibidos, nunca pedidos.
- Erros técnicos traduzidos em linguagem do usuário com ação de correção.
- Quando a complexidade é inevitável, distribua: guie com etapas, exemplos e ajuda contextual.

## Padrões de implementação

- Autopreenchimento por CEP, CNPJ ou e-mail corporativo (domínio → empresa).
- `autocomplete` correto em inputs (`email`, `postal-code`, `cc-number`) para o navegador preencher.
- Importação de dados (CSV, integração) em vez de cadastro manual em massa.
- Templates e duplicação ("Criar a partir de…") para objetos complexos.
- Modo simples por padrão com "Avançado" para quem precisa.

## Exemplo antes/depois

- Antes: cadastro de empresa pede CNPJ, razão social, nome fantasia, endereço completo, CNAE e regime tributário digitados manualmente.
- Depois: usuário digita o CNPJ; o sistema busca e preenche razão social, endereço e CNAE; usuário apenas revisa e confirma o regime tributário com default sugerido.

## Anti-padrões e sinais de violação

- Campo pedindo formato específico ("digite apenas números, sem pontos").
- Usuário calculando algo manualmente para preencher um campo.
- Mensagem de erro com código interno ou stack trace.
- Configurações obrigatórias no primeiro uso sem default.
- "Simplificação" que remove uma capacidade e obriga o usuário a contorná-la fora do sistema.

## Conflitos e limites

- Com Occam e simplicidade: remover opções pode transferir complexidade ao usuário; simplifique a interface, não a capacidade.
- Automação precisa ser transparente e reversível: mostre o que foi preenchido e permita editar.
- Inferências erradas custam mais que perguntar; em dados críticos (fiscais, financeiros), confirme com o usuário.
- Não colete dados automaticamente sem base legal e transparência só para "reduzir atrito".

## Checklist de revisão

- [ ] O sistema pede algum dado que já tem ou poderia inferir?
- [ ] Campos têm defaults sensatos e `autocomplete` correto?
- [ ] Cálculos e formatações são feitos pelo sistema?
- [ ] Dados preenchidos automaticamente são visíveis e editáveis?
- [ ] Erros estão em linguagem do usuário, com próximo passo?
