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
