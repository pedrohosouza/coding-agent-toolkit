import { {{ENTITY_NAME}}_SELECT } from '~~/server/constants/{{entity-name}}-select.constant'
import { prisma } from '~~/server/utils/prisma'
import type { ExtendedPrismaClient } from '~~/server/utils/prisma'
import { {{EntityName}}ExistsValidator } from '~~/server/validators/{{entity-name}}-exists.validator'
import type { Update{{EntityName}}Input } from '~~/shared/schemas/{{entity-name}}.validation'

export class Update{{EntityName}}Service {
  constructor(
    private readonly db: ExtendedPrismaClient = prisma,
    private readonly {{entityName}}ExistsValidator = new {{EntityName}}ExistsValidator(db)
  ) {}

  async execute(userId: string, id: string, input: Update{{EntityName}}Input) {
    await this.{{entityName}}ExistsValidator.execute(userId, id)

    return this.db.{{entityName}}.update({
      where: { id },
      data: { name: input.name },
      select: {{ENTITY_NAME}}_SELECT
    })
  }
}
