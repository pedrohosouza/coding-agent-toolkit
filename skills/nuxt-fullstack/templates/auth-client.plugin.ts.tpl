import { organizationClient } from 'better-auth/client/plugins'
import { createAuthClient } from 'better-auth/vue'

export default defineNuxtPlugin(() => {
  const authClient = createAuthClient({
    baseURL: useRequestURL().origin,
    plugins: [organizationClient()]
  })

  return {
    provide: {
      authClient
    }
  }
})
