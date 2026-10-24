# Lei de Tesler

## Princípio

Todo sistema possui uma quantidade de complexidade que não pode ser eliminada; ela pode apenas ser movida entre usuário e sistema.

## Aplicação

- Faça o sistema absorver complexidade sempre que possível.
- Automatize decisões previsíveis.
- Reduza configuração manual.
- Não simplifique removendo controle necessário.
- Deixe complexidade avançada disponível apenas quando necessário.

## Exemplo

Um formulário de endereço pode preencher cidade e estado a partir do CEP, em vez de exigir que o usuário digite tudo.

## Sinal de violação

- Usuário precisa configurar detalhes técnicos desnecessários.
- Sistema exige decisões que poderia tomar sozinho.
- Complexidade foi apenas escondida, não resolvida.