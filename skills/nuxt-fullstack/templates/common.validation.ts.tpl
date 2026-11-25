import { z } from 'zod'

export const SORT_ORDERS = ['asc', 'desc'] as const

export const idParamsSchema = z.strictObject({ id: z.uuid() })

export const paginationQueryShape = {
  page: z.coerce.number().int().min(1).default(1),
  perPage: z.coerce.number().int().min(1).max(100).default(10),
  search: z.string().trim().min(1).max(100).optional(),
  order: z.enum(SORT_ORDERS).default('desc')
}

export type IdParams = z.output<typeof idParamsSchema>
