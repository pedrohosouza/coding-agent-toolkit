import { prisma } from '~~/server/utils/prisma'
import type { ExtendedPrismaClient } from '~~/server/utils/prisma'
import { {{EntityName}}ExistsValidator } from '~~/server/validators/{{entity-name}}-exists.validator'

export class Delete{{EntityName}}Service {
  constructor(
    private readonly db: ExtendedPrismaClient = prisma,
    private readonly {{entityName}}ExistsValidator = new {{EntityName}}ExistsValidator(db)
  ) {}

  async execute(userId: string, id: string): Promise<void> {
    await this.{{entityName}}ExistsValidator.execute(userId, id)

    await this.db.{{entityName}}.delete({ where: { id } })
  }
}
