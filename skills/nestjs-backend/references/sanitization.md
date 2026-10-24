# Sanitização

## Regras

- Use queries parametrizadas; Prisma já parametriza queries.
- Nunca concatene input em SQL, NoSQL, comandos ou paths.
- Valide e normalize entrada antes de usar.
- Sanitize apenas quando fizer sentido para o domínio.
- Encode a saída quando renderizar HTML.
- Defina explicitamente os campos retornados com `select`.
- Nunca retorne `password`, `token`, `hash`, segredo ou campo interno.
- Nunca confie em dados do cliente para decidir permissão.
