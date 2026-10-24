import type { Prisma } from '../../../generated/prisma/client.js';

export const {{ENTITY_NAME}}_SELECT = {
  id: true,
  createdAt: true,
  updatedAt: true,
} satisfies Prisma.{{EntityName}}Select;
