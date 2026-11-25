import { {{ENTITY_NAME}}_SEARCHABLE_FIELDS } from '~~/server/constants/{{entity-name}}-searchable-fields.constant'
import { {{ENTITY_NAME}}_SELECT } from '~~/server/constants/{{entity-name}}-select.constant'
import { prisma } from '~~/server/utils/prisma'
import type { ExtendedPrismaClient } from '~~/server/utils/prisma'
import type { List{{EntityNames}}Query } from '~~/shared/schemas/{{entity-name}}.validation'

export class List{{EntityNames}}Service {
  constructor(private readonly db: ExtendedPrismaClient = prisma) {}

  async execute(userId: string, query: List{{EntityNames}}Query) {
    const { page, perPage, search, sort, order } = query

    return this.db.{{entityName}}.paginate(
      {
        where: { userId },
        orderBy: { [sort]: order },
        select: {{ENTITY_NAME}}_SELECT
      },
      {
        page,
        perPage,
        search,
        searchFields: {{ENTITY_NAME}}_SEARCHABLE_FIELDS
      }
    )
  }
}
