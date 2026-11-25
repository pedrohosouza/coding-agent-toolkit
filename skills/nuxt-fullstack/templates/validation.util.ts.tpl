import type { H3Event } from 'h3'
import type { ZodError, ZodType, z } from 'zod'
import type { ApiErrorDetail } from '~~/shared/types/api.types'

function toValidationDetails(error: ZodError): ApiErrorDetail[] {
  return error.issues.map((issue) => ({
    field: issue.path.map(String).join('.'),
    issue: issue.message
  }))
}

function parseOrThrow<TSchema extends ZodType>(
  schema: TSchema,
  data: unknown
): z.output<TSchema> {
  const result = schema.safeParse(data)

  if (!result.success) {
    throw createError({
      statusCode: 400,
      message: 'Validation failed',
      data: { details: toValidationDetails(result.error) }
    })
  }

  return result.data
}

export async function validateBody<TSchema extends ZodType>(
  event: H3Event,
  schema: TSchema
): Promise<z.output<TSchema>> {
  return parseOrThrow(schema, await readBody(event))
}

export function validateQuery<TSchema extends ZodType>(
  event: H3Event,
  schema: TSchema
): z.output<TSchema> {
  return parseOrThrow(schema, getQuery(event))
}

export function validateParams<TSchema extends ZodType>(
  event: H3Event,
  schema: TSchema
): z.output<TSchema> {
  return parseOrThrow(schema, getRouterParams(event))
}

export function validateHeaders<TSchema extends ZodType>(
  event: H3Event,
  schema: TSchema
): z.output<TSchema> {
  return parseOrThrow(schema, getRequestHeaders(event))
}
