# Acessibilidade

## Regras

- Componentes Nuxt UI e HTML semântico: ver `SKILL.md`.
- Envolva o app em `UApp` no `app.vue`; ele provê toasts, overlays e portais acessíveis.
- Defina `lang="pt-BR"` com `useHead({ htmlAttrs: { lang: 'pt-BR' } })` e um título por página com `useSeoMeta({ title })`; ambos são renderizados no servidor.
- Garanta contraste adequado.
- Garanta foco visível.
- Garanta navegação por teclado.
- Use labels associados aos campos; botões só com ícone têm `aria-label`.
- Forneça feedback para erros e ações.
- Não remova outline de foco sem substituir por indicador visível equivalente.
- Teste fluxos principais apenas com teclado.
