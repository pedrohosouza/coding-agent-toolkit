import { createAuthClient } from 'better-auth/vue'

export default defineNuxtPlugin(() => {
  const config = useRuntimeConfig()
  const authClient = createAuthClient({
    baseURL: config.public.apiBaseUrl,
    basePath: '/api/auth',
    fetchOptions: {
      credentials: 'include'
    },
    sessionOptions: {
      refetchOnWindowFocus: true
    }
  })

  return {
    provide: {
      authClient
    }
  }
})
