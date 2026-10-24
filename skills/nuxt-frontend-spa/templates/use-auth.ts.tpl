interface SignInInput {
  email: string
  password: string
}

export function useAuth() {
  const { $authClient } = useNuxtApp()
  const sessionState = $authClient.useSession()
  const session = computed(() => sessionState.value.data)
  const user = computed(() => session.value?.user ?? null)
  const authenticated = computed(() => Boolean(session.value))
  const pending = computed(() => sessionState.value.isPending)

  const getFrontendUrl = (path: string) =>
    new URL(path, window.location.origin).toString()

  async function refreshSession() {
    await sessionState.value.refetch()
  }

  async function signIn(input: SignInInput, callbackPath = '/') {
    const result = await $authClient.signIn.email({
      ...input,
      callbackURL: getFrontendUrl(callbackPath)
    })

    if (result.error) {
      throw result.error
    }

    await refreshSession()
    return result.data
  }

  async function signOut() {
    const result = await $authClient.signOut()

    if (result.error) {
      throw result.error
    }

    await refreshSession()
  }

  return {
    authenticated,
    pending,
    refreshSession,
    session,
    signIn,
    signOut,
    user
  }
}
