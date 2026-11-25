<script setup lang="ts">
import type { FormError, FormSubmitEvent } from '@nuxt/ui'
import type { Create{{EntityName}}Input } from '#shared/schemas/{{entity-name}}.validation'
import { create{{EntityName}}Schema } from '#shared/schemas/{{entity-name}}.validation'

const props = defineProps<{
  loading: boolean
  errors?: FormError[]
}>()

const emit = defineEmits<{
  submit: [payload: Create{{EntityName}}Input]
}>()

const form = useTemplateRef('form')
const state = reactive<Create{{EntityName}}Input>({ name: '' })

watch(
  () => props.errors,
  (errors) => form.value?.setErrors(errors ?? [])
)

function onSubmit(event: FormSubmitEvent<Create{{EntityName}}Input>) {
  emit('submit', { name: event.data.name })
}
</script>

<template>
  <UForm
    ref="form"
    :schema="create{{EntityName}}Schema"
    :state="state"
    @submit="onSubmit"
  >
    <UFormField label="Nome" name="name" required>
      <UInput v-model="state.name" />
    </UFormField>

    <UButton type="submit" label="Salvar" :loading="loading" />
  </UForm>
</template>
