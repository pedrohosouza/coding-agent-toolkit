import { prisma } from '~~/server/utils/prisma'
import { respond } from '~~/server/utils/response'

const CHECK_TIMEOUT_MS = 3000

function withTimeout<T>(promise: Promise<T>): Promise<T> {
  return Promise.race([
    promise,
    new Promise<never>((_resolve, reject) =>
      setTimeout(() => reject(new Error('Check timed out')), CHECK_TIMEOUT_MS)
    )
  ])
}

async function checkDatabase(): Promise<'up' | 'down'> {
  try {
    await withTimeout(prisma.$queryRaw`SELECT 1`)

    return 'up'
  } catch {
    return 'down'
  }
}

export default defineEventHandler(async (event) => {
  if (event.context.isShuttingDown) {
    throw createError({ statusCode: 503, message: 'Shutting down' })
  }

  const checks = { database: await checkDatabase() }
  const isReady = Object.values(checks).every((status) => status === 'up')

  if (!isReady) {
    throw createError({ statusCode: 503, message: 'Service unavailable' })
  }

  return respond({ status: 'ok', checks })
})
