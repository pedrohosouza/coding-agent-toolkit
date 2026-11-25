import { auth } from '~~/server/utils/auth'

const PUBLIC_PATH_PREFIXES = ['/api/auth/', '/api/health/']

export default defineEventHandler(async (event) => {
  const { pathname } = getRequestURL(event)
  const isApiRoute = pathname.startsWith('/api/')
  const isPublic = PUBLIC_PATH_PREFIXES.some((prefix) =>
    pathname.startsWith(prefix)
  )

  if (!isApiRoute || isPublic) {
    return
  }

  const session = await auth.api.getSession({ headers: event.headers })

  if (!session) {
    throw createError({ statusCode: 401, message: 'Unauthorized' })
  }

  event.context.session = session
})
