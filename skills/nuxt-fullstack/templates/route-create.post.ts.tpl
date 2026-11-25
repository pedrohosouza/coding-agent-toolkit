import { create{{EntityName}}Schema } from '~~/shared/schemas/{{entity-name}}.validation'
import { Create{{EntityName}}Service } from '~~/server/services/{{entity-names}}/create-{{entity-name}}.service'
import { requireSession } from '~~/server/utils/require-session'
import { respond } from '~~/server/utils/response'
import { validateBody } from '~~/server/utils/validation'

export default defineEventHandler(async (event) => {
  const body = await validateBody(event, create{{EntityName}}Schema)
  const session = await requireSession(event)

  const {{entityName}} = await new Create{{EntityName}}Service().execute(
    session.user.id,
    body
  )

  setResponseStatus(event, 201)

  return respond({{entityName}})
})
