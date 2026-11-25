import { betterAuth } from 'better-auth'
import { prismaAdapter } from 'better-auth/adapters/prisma'
import { prisma } from '~~/server/utils/prisma'

const config = useRuntimeConfig()

const SENSITIVE_PATHS = [
  '/sign-in/*',
  '/sign-up/*',
  '/forget-password',
  '/reset-password'
]

const windowInSeconds = Math.ceil(config.rateLimitWindowMs / 1000)

export const auth = betterAuth({
  database: prismaAdapter(prisma, { provider: 'postgresql' }),
  secret: config.betterAuthSecret,
  baseURL: config.betterAuthUrl,
  trustedOrigins: [config.betterAuthUrl],
  emailAndPassword: { enabled: true },
  socialProviders: {
    google: {
      clientId: config.googleClientId,
      clientSecret: config.googleClientSecret
    }
  },
  advanced: { database: { generateId: false } },
  rateLimit: {
    enabled: true,
    window: windowInSeconds,
    max: config.rateLimitPublicLimit,
    customRules: Object.fromEntries(
      SENSITIVE_PATHS.map((path) => [
        path,
        { window: windowInSeconds, max: config.rateLimitSensitiveLimit }
      ])
    )
  }
})

export type AuthSession = typeof auth.$Infer.Session
