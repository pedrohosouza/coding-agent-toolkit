import { z } from 'zod'

const envSchema = z.object({
  databaseUrl: z.string().min(1),
  betterAuthSecret: z.string().min(32),
  betterAuthUrl: z.url(),
  googleClientId: z.string().min(1),
  googleClientSecret: z.string().min(1),
  rateLimitWindowMs: z.coerce.number().int().positive(),
  rateLimitPublicLimit: z.coerce.number().int().positive(),
  rateLimitAuthenticatedLimit: z.coerce.number().int().positive(),
  rateLimitSensitiveLimit: z.coerce.number().int().positive(),
  shutdownTimeoutMs: z.coerce.number().int().positive()
})

export default defineNitroPlugin(() => {
  const result = envSchema.safeParse(useRuntimeConfig())

  if (!result.success) {
    const issues = result.error.issues
      .map((issue) => `${issue.path.join('.')}: ${issue.message}`)
      .join('; ')

    throw new Error(`Invalid environment configuration: ${issues}`)
  }
})
