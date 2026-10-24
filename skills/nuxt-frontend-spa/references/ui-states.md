# Estados de UI

## Estados obrigatórios

Toda tela ou seção assíncrona deve tratar:

- `loading`
- `empty`
- `error`
- `success`

## Regras

- Use `USkeleton` para carregamento de conteúdo.
- Use spinner apenas em botões e ações pontuais.
- Mostre estado vazio com mensagem clara e ação sugerida.
- Mostre erro com mensagem compreensível e ação de retry.
- Use optimistic update apenas quando a reversão for clara.
- Toda ação tem feedback e nenhuma falha é silenciosa; regras completas em `feedback.md`.
- Leitura não usa toast: erro e vazio aparecem na própria tela.
