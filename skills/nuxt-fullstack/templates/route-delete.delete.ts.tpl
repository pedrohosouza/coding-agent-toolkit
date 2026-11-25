import { idParamsSchema } from '~~/shared/schemas/common.validation'
import { Delete{{EntityName}}Service } from '~~/server/services/{{entity-names}}/delete-{{entity-name}}.service'
import { requireSession } from '~~/server/utils/require-session'
import { validateParams } from '~~/server/utils/validation'

export default defineEventHandler(async (event) => {
  const { id } = validateParams(event, idParamsSchema)
  const session = await requireSession(event)

  await new Delete{{EntityName}}Service().execute(session.user.id, id)

  return sendNoContent(event)
})
