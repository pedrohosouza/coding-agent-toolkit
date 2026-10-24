export default defineNuxtRouteMiddleware(async (to) => {
  const { authenticated, refreshSession } = useAuth()

  await refreshSession()

  if (!authenticated.value) {
    return navigateTo({
      path: '/auth/login',
      query: { redirect: to.fullPath }
    })
  }
})
