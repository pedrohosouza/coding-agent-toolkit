export default defineNuxtRouteMiddleware(async (to) => {
  const { authenticated, refreshSession } = useAuth()

  if (!authenticated.value) {
    await refreshSession()
  }

  if (!authenticated.value) {
    return navigateTo({
      path: '/auth/login',
      query: { redirect: to.fullPath }
    })
  }
})
