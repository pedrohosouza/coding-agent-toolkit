# Componentes e Nuxt UI

## Regras

- A hierarquia de decisão (componente Nuxt UI, props, slots, `ui`, Tailwind) e as regras de estilo estão no `SKILL.md`.
- Não duplique estilos globais no componente.
- Componentes de domínio recebem props e emitem eventos; não chamam a API (ver `folder-structure.md`).

## Categorias de decisão

- Elemento: botão, badge, avatar, card, ícone
- Formulário: input, select, checkbox, radio, switch, form
- Overlay: modal, drawer, popover, tooltip, toast
- Navegação: menu, breadcrumb, tabs, paginação
- Dados: tabela, lista, descrição, estatística
- Layout: página, seção, container, separator

## Componente

```vue
<script setup lang="ts">
interface Props {
  title: string
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const emit = defineEmits<{
  save: [value: string]
}>()
</script>

<template>
  <UCard>
    <template #header>
      <h2 class="text-lg font-semibold">
        {{ props.title }}
      </h2>
    </template>

    <slot />
  </UCard>
</template>
```

## Exemplo a evitar

```vue
<div class="flex flex-col gap-4 rounded-xl border p-6 shadow-sm">
  <h2 class="text-lg font-semibold">Entrar</h2>

  <label for="email">E-mail</label>
  <input id="email" type="email" />

  <button type="submit">Entrar</button>
</div>
```

Esse padrão reconstrói `UCard`, `UFormField`, `UInput` e `UButton` com HTML puro e classes Tailwind desnecessárias.
