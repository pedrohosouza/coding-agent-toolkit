import { idParamsSchema } from '~~/shared/schemas/common.validation'
import { update{{EntityName}}Schema } from '~~/shared/schemas/{{entity-name}}.validation'
import { Update{{EntityName}}Service } from '~~/server/services/{{entity-names}}/update-{{entity-name}}.service'
import { requireSession } from '~~/server/utils/require-session'
import { respond } from '~~/server/utils/response'
import { validateBody, validateParams } from '~~/server/utils/validation'

export default defineEventHandler(async (event) => {
  const { id } = validateParams(event, idParamsSchema)
  const body = await validateBody(event, update{{EntityName}}Schema)
  const session = await requireSession(event)

  const {{entityName}} = await new Update{{EntityName}}Service().execute(
    session.user.id,
    id,
    body
  )

  return respond({{entityName}})
})
