import { z } from 'zod'
import { paginationQueryShape } from './common.validation'

export const create{{EntityName}}Schema = z.strictObject({
  name: z
    .string()
    .trim()
    .min(3, 'Use ao menos 3 caracteres.')
    .max(120, 'Use no máximo 120 caracteres.')
})

export const update{{EntityName}}Schema = create{{EntityName}}Schema.partial()

export const list{{EntityNames}}QuerySchema = z.strictObject({
  ...paginationQueryShape,
  sort: z.enum(['name', 'createdAt', 'updatedAt']).default('createdAt')
})

export type Create{{EntityName}}Input = z.output<typeof create{{EntityName}}Schema>
export type Update{{EntityName}}Input = z.output<typeof update{{EntityName}}Schema>
export type List{{EntityNames}}Query = z.output<typeof list{{EntityNames}}QuerySchema>
