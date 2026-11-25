import { prisma } from '~~/server/utils/prisma'

declare module 'h3' {
  interface H3EventContext {
    isShuttingDown?: boolean
  }
}

export default defineNitroPlugin((nitroApp) => {
  const { shutdownTimeoutMs } = useRuntimeConfig()
  let isShuttingDown = false

  const startShutdown = () => {
    isShuttingDown = true
    setTimeout(() => process.exit(1), shutdownTimeoutMs).unref()
  }

  process.once('SIGTERM', startShutdown)
  process.once('SIGINT', startShutdown)

  nitroApp.hooks.hook('request', (event) => {
    event.context.isShuttingDown = isShuttingDown
  })

  nitroApp.hooks.hook('close', async () => {
    await prisma.$disconnect()
  })
})
