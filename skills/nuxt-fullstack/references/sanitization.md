# Sanitização

## Regras

- Use queries parametrizadas; Prisma já parametriza. Para SQL cru use `Prisma.sql` ou `$queryRaw` com template; nunca `$queryRawUnsafe`.
- Nunca concatene input em SQL, comandos ou paths.
- Valide e normalize entrada com Zod antes de usar.
- Sanitize apenas quando fizer sentido para o domínio.
- O Vue escapa a saída por padrão; evite `v-html` com conteúdo do usuário.
- Defina explicitamente os campos retornados com `select`, via constante `<ENTITY>_SELECT`.
- Nunca retorne `password`, `token`, `hash`, segredo ou campo interno, nem os coloque em `useState` ou no payload SSR.
- Nunca confie em dados do cliente para decidir permissão.
