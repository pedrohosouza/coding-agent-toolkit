# Páginas de erro

## Regras

- Crie `app/error.vue` com layout consistente; ele renderiza erros de SSR e de cliente.
- Receba o erro por `defineProps<{ error: NuxtError }>()` e trate `404`, `403` e `500`.
- Ofereça caminho de volta com `clearError({ redirect: '/' })`.
- Não exponha stack trace ou detalhes internos; o servidor já devolve mensagem genérica para `5xx`.
- Para recurso inexistente em página de detalhe, lance `createError({ statusCode: 404, fatal: true })` no composable ou na página quando o `useFetch` retornar `404`.
- Erros de leitura de listagem ficam na própria tela (`ui-states.md`); `error.vue` é para falhas da rota.
- Use componentes Nuxt UI (`UError`, `UButton`) e o mínimo de classes Tailwind.

## Exemplo

```vue
<script setup lang="ts">
import type { NuxtError } from '#app'

defineProps<{ error: NuxtError }>()

function goHome() {
  return clearError({ redirect: '/' })
}
</script>

<template>
  <UApp>
    <UError :error="error" :clear="false">
      <template #links>
        <UButton label="Voltar ao início" @click="goHome" />
      </template>
    </UError>
  </UApp>
</template>
```
