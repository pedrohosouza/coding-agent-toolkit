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
      <h2>{{ props.title }}</h2>
    </template>

    <slot />

    <template #footer>
      <UButton
        label="Salvar"
        :loading="props.loading"
        :disabled="props.loading"
        @click="emit('save', 'value')"
      />
    </template>
  </UCard>
</template>
