import type { H3Event } from 'h3'
import { auth } from '~~/server/utils/auth'
import type { AuthSession } from '~~/server/utils/auth'

declare module 'h3' {
  interface H3EventContext {
    session?: AuthSession
  }
}

export async function requireSession(event: H3Event): Promise<AuthSession> {
  const session =
    event.context.session ??
    (await auth.api.getSession({ headers: event.headers }))

  if (!session) {
    throw createError({ statusCode: 401, message: 'Unauthorized' })
  }

  event.context.session = session

  return session
}
