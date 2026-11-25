import { list{{EntityNames}}QuerySchema } from '~~/shared/schemas/{{entity-name}}.validation'
import { List{{EntityNames}}Service } from '~~/server/services/{{entity-names}}/list-{{entity-names}}.service'
import { requireSession } from '~~/server/utils/require-session'
import { respondPaginated } from '~~/server/utils/response'
import { validateQuery } from '~~/server/utils/validation'

export default defineEventHandler(async (event) => {
  const query = validateQuery(event, list{{EntityNames}}QuerySchema)
  const session = await requireSession(event)

  const result = await new List{{EntityNames}}Service().execute(
    session.user.id,
    query
  )

  return respondPaginated(result)
})
