# CORS

## Regras

- Origens permitidas vêm da configuração.
- Nunca use `*` em API autenticada.
- Permita apenas métodos e headers realmente usados.
- Use `credentials: true` apenas quando a API usar cookies.
- Com cookies, a origem deve ser explícita.
- Responda corretamente ao preflight `OPTIONS`.
- Configure `Access-Control-Max-Age` para reduzir preflights repetidos.
