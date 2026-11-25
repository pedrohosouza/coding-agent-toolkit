interface SignInInput {
  email: string
  password: string
}

export function useAuth() {
  const { $authClient } = useNuxtApp()

  type AuthSession = typeof $authClient.$Infer.Session

  const session = useState<AuthSession | null>('auth:session', () => null)
  const pending = useState('auth:pending', () => false)
  const user = computed(() => session.value?.user ?? null)
  const authenticated = computed(() => Boolean(session.value))

  async function refreshSession() {
    const headers = useRequestHeaders(['cookie'])

    pending.value = true

    try {
      const result = await $authClient.getSession({
        fetchOptions: { headers }
      })

      session.value = result.data
    } finally {
      pending.value = false
    }
  }

  async function signIn(input: SignInInput, callbackPath = '/') {
    const result = await $authClient.signIn.email({
      ...input,
      callbackURL: callbackPath
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

    session.value = null
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
