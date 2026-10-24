<script setup lang="ts">
import type { FormError, FormSubmitEvent } from '@nuxt/ui'
import type {
  {{EntityName}}Form,
  {{EntityName}}Payload
} from '~/schemas/{{entity-name}}.validation'
import { {{entityName}}Schema } from '~/schemas/{{entity-name}}.validation'

const props = defineProps<{
  loading: boolean
  errors?: FormError[]
}>()

const emit = defineEmits<{
  submit: [payload: {{EntityName}}Payload]
}>()

const form = useTemplateRef('form')
const state = reactive<{{EntityName}}Form>({ name: '' })

watch(
  () => props.errors,
  (errors) => form.value?.setErrors(errors ?? [])
)

function onSubmit(event: FormSubmitEvent<{{EntityName}}Form>) {
  emit('submit', { name: event.data.name })
}
</script>

<template>
  <UForm
    ref="form"
    :schema="{{entityName}}Schema"
    :state="state"
    @submit="onSubmit"
  >
    <UFormField label="Nome" name="name" required>
      <UInput v-model="state.name" />
    </UFormField>

    <UButton type="submit" label="Salvar" :loading="loading" />
  </UForm>
</template>
