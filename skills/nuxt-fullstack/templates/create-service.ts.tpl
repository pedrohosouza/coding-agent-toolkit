import { {{ENTITY_NAME}}_SELECT } from '~~/server/constants/{{entity-name}}-select.constant'
import { prisma } from '~~/server/utils/prisma'
import type { ExtendedPrismaClient } from '~~/server/utils/prisma'
import type { Create{{EntityName}}Input } from '~~/shared/schemas/{{entity-name}}.validation'

export class Create{{EntityName}}Service {
  constructor(private readonly db: ExtendedPrismaClient = prisma) {}

  async execute(userId: string, input: Create{{EntityName}}Input) {
    return this.db.{{entityName}}.create({
      data: { name: input.name, userId },
      select: {{ENTITY_NAME}}_SELECT
    })
  }
}
