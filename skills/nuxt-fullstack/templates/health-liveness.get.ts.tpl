import { respond } from '~~/server/utils/response'

export default defineEventHandler(() => respond({ status: 'ok' }))
