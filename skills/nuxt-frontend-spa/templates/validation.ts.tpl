import { z } from 'zod'

export const {{entityName}}Schema = z.object({
  name: z
    .string()
    .trim()
    .min(3, 'Use ao menos 3 caracteres.')
    .max(120, 'Use no máximo 120 caracteres.')
})

export type {{EntityName}}Form = z.output<typeof {{entityName}}Schema>

export interface {{EntityName}}Payload {
  name: string
}
