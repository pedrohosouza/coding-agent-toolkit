import { {{ENTITY_NAME}}_SELECT } from '~~/server/constants/{{entity-name}}-select.constant'
import { prisma } from '~~/server/utils/prisma'
import type { ExtendedPrismaClient } from '~~/server/utils/prisma'
import { {{EntityName}}ExistsValidator } from '~~/server/validators/{{entity-name}}-exists.validator'

export class Get{{EntityName}}Service {
  constructor(
    private readonly db: ExtendedPrismaClient = prisma,
    private readonly {{entityName}}ExistsValidator = new {{EntityName}}ExistsValidator(db)
  ) {}

  async execute(userId: string, id: string) {
    await this.{{entityName}}ExistsValidator.execute(userId, id)

    return this.db.{{entityName}}.findUniqueOrThrow({
      where: { id },
      select: {{ENTITY_NAME}}_SELECT
    })
  }
}
