# Feedback ao usuário

Toda ação do usuário e toda falha recebem resposta visível. Nunca há falha silenciosa.

## Regras

- Toda mutação (criar, editar, excluir, enviar, sincronizar) mostra: loading, sucesso e erro.
- Loading: botão com `loading` e `disabled`, ou skeleton para conteúdo.
- Sucesso: toast verde com mensagem curta no passado (`Módulo criado`).
- Erro: toast vermelho com título da ação e descrição vinda de `getApiErrorMessage`.
- Erro de validação (`VALIDATION_ERROR`): erros por campo no `UForm`, não só toast.
- Estados de leitura (loading, vazio, erro) não usam toast; ficam em `ui-states.md`.
- Mensagens ao usuário em português, sem códigos nem detalhes técnicos.
- Mensagens específicas de conflito (`409`) são passadas pelo chamador; o erro genérico usa `getApiErrorMessage`.
- Nunca engula erro com `catch {}` vazio nem `try/finally` sem tratamento.
- Previna double-submit com `running`/`loading`.
- Redirecionamento após sucesso conta como feedback quando a próxima tela deixa claro o resultado.
- Use o toast do Nuxt UI (`useToast`); não crie sistema próprio.

## `useApiAction`

Composable único para mutações. Executa a ação, mostra o toast, atualiza os dados e expõe os erros de validação do backend.

```ts
interface ApiActionMessages {
  success: string
  failure: string
  conflict?: string
}

export function useApiAction(onSuccess?: () => Promise<unknown>) {
  const toast = useToast()
  const running = ref(false)
  const error = ref<unknown>(null)
  const validationErrors = computed(() => mapValidationDetails(error.value))

  async function run(
    action: () => Promise<unknown>,
    messages: ApiActionMessages
  ) {
    running.value = true
    error.value = null

    try {
      await action()
      toast.add({ color: 'success', title: messages.success })
      await onSuccess?.()
      return true
    } catch (cause) {
      error.value = cause
      toast.add({
        color: 'error',
        title: messages.failure,
        description:
          messages.conflict && getApiErrorCode(cause) === 'CONFLICT'
            ? messages.conflict
            : getApiErrorMessage(cause)
      })
      return false
    } finally {
      running.value = false
    }
  }

  return { run, running, validationErrors }
}
```

- `run` retorna `true` em sucesso e `false` em erro; o chamador usa para fechar modal ou redirecionar.
- `onSuccess` normalmente é o `refresh` da listagem.
- `running` alimenta `:loading` e `:disabled` do botão de envio.
- `validationErrors` guarda os `details` do último erro `VALIDATION_ERROR`, já no formato `{ name, message }` do `UForm`, e volta a `[]` a cada nova execução.

## Uso em composable de domínio

```ts
const { run, running } = useApiAction(refresh)

function create(input: OrderPayload) {
  return run(() => $api('/orders', { method: 'POST', body: input }), {
    success: 'Pedido criado',
    failure: 'Não foi possível criar o pedido',
    conflict: 'Já existe um pedido com estes dados.'
  })
}
```

## Padrão de mensagens

| Operação | `success` | `failure` |
|---|---|---|
| Criar | `Pedido criado` | `Não foi possível criar o pedido` |
| Atualizar | `Pedido atualizado` | `Não foi possível atualizar o pedido` |
| Excluir | `Pedido excluído` | `Não foi possível excluir o pedido` |
| Ação | `Sincronização enfileirada` | `Não foi possível sincronizar` |

## Erros de campo

O schema Zod espelha as regras do backend, então `VALIDATION_ERROR` é raro. Quando acontece, o toast mostra `Revise os campos informados.` e o `useApiAction` expõe `validationErrors`.

O composable de domínio repassa `validationErrors`, a página o entrega ao formulário e o formulário aplica com `setErrors` do `UForm`:

```ts
const { run, running, validationErrors } = useApiAction(refresh)

return { create, running, validationErrors }
```

```vue
<OrderFormPanel
  :errors="validationErrors"
  :loading="running"
  @submit="onSubmit"
/>
```

```ts
const form = useTemplateRef('form')

watch(
  () => props.errors,
  (errors) => form.value?.setErrors(errors)
)
```

- Toda mutação continua passando por `useApiAction`; não chame `$api` direto para tratar erro por campo.
- O toast de erro continua obrigatório.
