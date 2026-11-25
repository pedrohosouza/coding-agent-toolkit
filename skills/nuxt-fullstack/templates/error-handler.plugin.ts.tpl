import { Prisma } from '~~/server/generated/prisma/client'
import type { ApiErrorDetail, ApiErrorResponse } from '~~/shared/types/api.types'

const HTTP_ERROR_CODES: Readonly<Record<number, string>> = {
  400: 'BAD_REQUEST',
  401: 'UNAUTHORIZED',
  403: 'FORBIDDEN',
  404: 'NOT_FOUND',
  409: 'CONFLICT',
  413: 'PAYLOAD_TOO_LARGE',
  422: 'UNPROCESSABLE_ENTITY',
  429: 'TOO_MANY_REQUESTS',
  500: 'INTERNAL_SERVER_ERROR',
  503: 'SERVICE_UNAVAILABLE'
}

function readValidationDetails(data: unknown): ApiErrorDetail[] | undefined {
  if (typeof data !== 'object' || data === null || !('details' in data)) {
    return undefined
  }

  return data.details as ApiErrorDetail[]
}

function resolvePrismaStatus(cause: unknown): number | undefined {
  if (!(cause instanceof Prisma.PrismaClientKnownRequestError)) {
    return undefined
  }

  if (cause.code === 'P2002') {
    return 409
  }

  if (cause.code === 'P2025') {
    return 404
  }

  return undefined
}

function resolveMessage(
  statusCode: number,
  prismaStatus: number | undefined,
  message: string
): string {
  if (prismaStatus === 409) {
    return 'Resource already exists'
  }

  if (prismaStatus === 404) {
    return 'Resource not found'
  }

  return statusCode >= 500 && statusCode !== 503
    ? 'Internal server error'
    : message
}

function buildErrorResponse(
  statusCode: number,
  message: string,
  details: ApiErrorDetail[] | undefined
): ApiErrorResponse {
  const isValidationError = statusCode === 400 && details !== undefined

  return {
    error: {
      code: isValidationError
        ? 'VALIDATION_ERROR'
        : (HTTP_ERROR_CODES[statusCode] ?? 'INTERNAL_SERVER_ERROR'),
      message: isValidationError ? 'Validation failed' : message,
      ...(details ? { details } : {})
    }
  }
}

export default defineNitroPlugin((nitroApp) => {
  const defaultOnError = nitroApp.h3App.options.onError

  nitroApp.h3App.options.onError = async (error, event) => {
    if (!getRequestURL(event).pathname.startsWith('/api/')) {
      return defaultOnError?.(error, event)
    }

    const prismaStatus = resolvePrismaStatus(error.cause)
    const statusCode = prismaStatus ?? error.statusCode ?? 500
    const body = buildErrorResponse(
      statusCode,
      resolveMessage(statusCode, prismaStatus, error.message),
      readValidationDetails(error.data)
    )

    setResponseStatus(event, statusCode)
    setResponseHeader(event, 'Content-Type', 'application/json')

    return send(event, JSON.stringify(body))
  }
})
