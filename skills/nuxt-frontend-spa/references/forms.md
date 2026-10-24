# Formulários

## Regras

- Use `UForm` e `UFormField` do Nuxt UI.
- Use Zod para schema de validação.
- Schemas ficam em `schemas/<domain>.validation.ts` (ver `types-schemas.md`).
- Valide no cliente e confie apenas na validação do backend como fonte final.
- Mostre erro por campo e erro geral quando necessário.
- Desabilite o botão de envio durante submit para prevenir double-submit.
- Erros de validação do backend chegam pela prop `errors` e são aplicados com `setErrors`.
- O formulário não chama a API: emite o payload e o composable da página executa a mutação.
- Todo envio tem loading, toast de sucesso e toast de erro (ver `feedback.md`).
- Feche o modal ou limpe o estado apenas quando a ação retornar sucesso.
- Use máscaras apenas quando melhorarem a entrada do usuário.
- Use o mínimo de classes Tailwind possível.

## Exemplo

Formulário (`OrderFormPanel.vue`, apresentação): valida, monta o payload e emite.

```vue
<script setup lang="ts">
import type { FormError, FormSubmitEvent } from '@nuxt/ui'
import type { OrderForm, OrderPayload } from '~/schemas/order.validation'
import { orderSchema } from '~/schemas/order.validation'

const props = defineProps<{
  loading: boolean
  errors?: FormError[]
}>()

const emit = defineEmits<{
  submit: [payload: OrderPayload]
}>()

const form = useTemplateRef('form')
const state = reactive<OrderForm>({ name: '' })

watch(
  () => props.errors,
  (errors) => form.value?.setErrors(errors ?? [])
)

function onSubmit(event: FormSubmitEvent<OrderForm>) {
  emit('submit', { name: event.data.name })
}
</script>

<template>
  <UForm
    ref="form"
    :schema="orderSchema"
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
import type { OrderPayload } from '~/schemas/order.validation'

const { create, running, validationErrors } = useOrders()

async function onSubmit(payload: OrderPayload) {
  if (await create(payload)) {
    await navigateTo('/orders')
  }
}
</script>

<template>
  <OrderFormPanel
    :errors="validationErrors"
    :loading="running"
    @submit="onSubmit"
  />
</template>
```
