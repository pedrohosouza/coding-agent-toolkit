# Formulários

## Regras

- Use `UForm` e `UFormField` do Nuxt UI.
- Use Zod para schema de validação.
- Schemas ficam em `shared/schemas/<entity>.validation.ts`, importados por `#shared/schemas/...`; o mesmo schema valida a rota Nitro e o `UForm`, então regra de validação nunca é duplicada.
- Valide no cliente para UX; a validação do servidor é a fonte final.
- Mostre erro por campo e erro geral quando necessário.
- Desabilite o botão de envio durante submit para prevenir double-submit.
- Erros de validação do backend chegam pela prop `errors` e são aplicados com `setErrors`.
- O formulário não chama a API: emite o payload e o composable da página executa a mutação.
- Todo envio tem loading, toast de sucesso e toast de erro (ver `feedback.md`).
- Feche o modal ou limpe o estado apenas quando a ação retornar sucesso.
- Use máscaras apenas quando melhorarem a entrada do usuário.
- Estado do formulário é local (`reactive`); não use `useState` para rascunho, a menos que precise sobreviver à navegação.
- Use o mínimo de classes Tailwind possível.

## Exemplo

Formulário (`CreateOrderInputPanel.vue`, apresentação): valida, monta o payload e emite.

```vue
<script setup lang="ts">
import type { FormError, FormSubmitEvent } from '@nuxt/ui'
import type { CreateOrderInput } from '#shared/schemas/order.validation'
import { createOrderSchema } from '#shared/schemas/order.validation'

const props = defineProps<{
  loading: boolean
  errors?: FormError[]
}>()

const emit = defineEmits<{
  submit: [payload: CreateOrderInput]
}>()

const form = useTemplateRef('form')
const state = reactive<CreateOrderInput>({ name: '' })

watch(
  () => props.errors,
  (errors) => form.value?.setErrors(errors ?? [])
)

function onSubmit(event: FormSubmitEvent<CreateOrderInput>) {
  emit('submit', { name: event.data.name })
}
</script>

<template>
  <UForm
    ref="form"
    :schema="createOrderSchema"
    :state="state"
    @submit="onSubmit"
  >
    <UFormField label="Nome" name="name" required>
      <UInput v-model="state.name" />
    </UFormField>

    <UButton type="submit" label="Salvar" :loading="loading" />
  </UForm>
</template>
```

Página (orquestração): liga o formulário ao composable.

```vue
<script setup lang="ts">
import type { CreateOrderInput } from '#shared/schemas/order.validation'

const { create, running, validationErrors } = useOrders()

async function onSubmit(payload: CreateOrderInput) {
  if (await create(payload)) {
    await navigateTo('/orders')
  }
}
</script>

<template>
  <CreateOrderInputPanel
    :errors="validationErrors"
    :loading="running"
    @submit="onSubmit"
  />
</template>
```
