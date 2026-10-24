# Tema e design tokens

## Regras

- Use Nuxt UI como base do design system.
- Derive cores, espaçamento, raios e tipografia de design tokens.
- Não use valores hardcoded de cor, espaçamento ou fonte.
- Suporte dark mode por padrão.
- Use variantes e slots do Nuxt UI antes de sobrescrever estilos.
- Use `app.config.ts` para configurar o tema global do Nuxt UI.
- Use CSS variables para tokens de marca.
- Use Tailwind Variants apenas para customizações consistentes e reutilizáveis.

## Exemplo

```ts
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'brand',
      neutral: 'slate'
    }
  }
})
```

```css
:root {
  --ui-color-brand-500: oklch(0.64 0.17 255);
  --ui-radius: 0.75rem;
}

.dark {
  --ui-color-brand-500: oklch(0.72 0.16 255);
}
```
