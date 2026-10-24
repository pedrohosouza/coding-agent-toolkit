# Limiar de Doherty

## Princípio

A produtividade aumenta quando sistema e usuário interagem em um ritmo em que nenhum dos dois precisa esperar desnecessariamente pelo outro.

## Aplicação

- Dê feedback imediato a toda interação.
- Mostre estado de loading rapidamente.
- Use optimistic updates quando a reversão for clara.
- Evite travar a interface durante operações.
- Otimize carregamento e respostas.
- Comunique progresso em operações longas.

## Exemplo

Ao enviar um formulário, o botão deve mudar para loading imediatamente e a interface deve indicar progresso.

## Sinal de violação

- Clique sem feedback.
- Tela travada sem indicação de progresso.
- Operação longa sem status.