import type { Prisma } from '~~/server/generated/prisma/client'

export const {{ENTITY_NAME}}_SELECT = {
  id: true,
  name: true,
  createdAt: true,
  updatedAt: true
} satisfies Prisma.{{EntityName}}Select
