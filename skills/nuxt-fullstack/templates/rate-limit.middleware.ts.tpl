interface Bucket {
  count: number
  resetAt: number
}

const PUBLIC_PATH_PREFIXES = ['/api/auth/', '/api/health/']
const SENSITIVE_PATH_PREFIXES = ['/api/webhooks/']

const buckets = new Map<string, Bucket>()

function resolveLimit(
  pathname: string,
  isAuthenticated: boolean,
  config: ReturnType<typeof useRuntimeConfig>
): number {
  if (SENSITIVE_PATH_PREFIXES.some((prefix) => pathname.startsWith(prefix))) {
    return config.rateLimitSensitiveLimit
  }

  return isAuthenticated
    ? config.rateLimitAuthenticatedLimit
    : config.rateLimitPublicLimit
}

export default defineEventHandler((event) => {
  const { pathname } = getRequestURL(event)

  if (
    !pathname.startsWith('/api/') ||
    PUBLIC_PATH_PREFIXES.some((prefix) => pathname.startsWith(prefix))
  ) {
    return
  }

  const config = useRuntimeConfig()
  const userId = event.context.session?.user.id
  const identifier = userId ?? getRequestIP(event, { xForwardedFor: true })
  const limit = resolveLimit(pathname, userId !== undefined, config)
  const now = Date.now()
  const key = `${identifier}:${pathname}`
  const current = buckets.get(key)
  const bucket =
    current && current.resetAt > now
      ? current
      : { count: 0, resetAt: now + config.rateLimitWindowMs }

  bucket.count += 1
  buckets.set(key, bucket)

  setResponseHeaders(event, {
    'X-RateLimit-Limit': String(limit),
    'X-RateLimit-Remaining': String(Math.max(limit - bucket.count, 0)),
    'X-RateLimit-Reset': String(Math.ceil(bucket.resetAt / 1000))
  })

  if (bucket.count > limit) {
    const retryAfter = Math.ceil((bucket.resetAt - now) / 1000)

    setResponseHeader(event, 'Retry-After', retryAfter)
    throw createError({ statusCode: 429, message: 'Too many requests' })
  }
})
