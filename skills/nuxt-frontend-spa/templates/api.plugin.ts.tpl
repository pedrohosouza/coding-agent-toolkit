import type { $Fetch } from 'ofetch'
import type { ApiErrorBody } from '~/types/api.types'

export default defineNuxtPlugin(() => {
  const config = useRuntimeConfig()
  const api = $fetch.create({
    baseURL: `${config.public.apiBaseUrl}/api`,
    credentials: 'include',
    onResponseError({ response }) {
      const body = response._data as ApiErrorBody | undefined
      const route = useRoute()

      if (response.status === 401 && !route.path.startsWith('/auth')) {
        void navigateTo({
          path: '/auth/login',
          query: { redirect: route.fullPath }
        })
      }

      throw createError({
        statusCode: response.status,
        statusMessage:
          body?.error?.message ?? 'Não foi possível comunicar com a API.',
        data: body?.error
      })
    }
  })

  return {
    provide: {
      api: api as $Fetch
    }
  }
})
