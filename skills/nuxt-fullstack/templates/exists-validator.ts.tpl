import { prisma } from '~~/server/utils/prisma'
import type { ExtendedPrismaClient } from '~~/server/utils/prisma'

export class {{EntityName}}ExistsValidator {
  constructor(private readonly db: ExtendedPrismaClient = prisma) {}

  async execute(userId: string, id: string) {
    const {{entityName}} = await this.db.{{entityName}}.findFirst({
      where: { id, userId },
      select: { id: true }
    })

    if (!{{entityName}}) {
      throw createError({ statusCode: 404, message: '{{EntityName}} not found' })
    }

    return {{entityName}}
  }
}
