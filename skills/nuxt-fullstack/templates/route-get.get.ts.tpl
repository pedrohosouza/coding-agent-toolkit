import { idParamsSchema } from '~~/shared/schemas/common.validation'
import { Get{{EntityName}}Service } from '~~/server/services/{{entity-names}}/get-{{entity-name}}.service'
import { requireSession } from '~~/server/utils/require-session'
import { respond } from '~~/server/utils/response'
import { validateParams } from '~~/server/utils/validation'

export default defineEventHandler(async (event) => {
  const { id } = validateParams(event, idParamsSchema)
  const session = await requireSession(event)

  const {{entityName}} = await new Get{{EntityName}}Service().execute(
    session.user.id,
    id
  )

  return respond({{entityName}})
})
