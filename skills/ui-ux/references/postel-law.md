# Lei de Postel

## Princípio

Seja conservador no que envia e tolerante no que aceita.

## Aplicação

- Aceite variações razoáveis de entrada do usuário.
- Normalize dados antes de validar ou persistir.
- Aceite formatos equivalentes quando seguro.
- Produza saída previsível e estruturada.
- Não seja tolerante com dados maliciosos ou inválidos.
- Valide no backend como fonte final.

## Exemplo

Um campo de telefone pode aceitar espaços, parênteses e hífen, mas deve ser normalizado antes de salvar.

## Sinal de violação

- Usuário é punido por formatação irrelevante.
- Sistema aceita qualquer entrada sem normalização.
- Saída da API é imprevisível.