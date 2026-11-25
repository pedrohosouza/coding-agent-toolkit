import type { ApiErrorDetail } from '#shared/types/api.types'

interface ApiErrorShape {
  statusCode?: number
  status?: number
  data?: {
    error?: {
      code?: string
      message?: string
      details?: ApiErrorDetail[]
    }
  }
}

const ERROR_MESSAGES: Record<string, string> = {
  UNAUTHORIZED: 'Sua sessão expirou. Entre novamente.',
  FORBIDDEN: 'Você não tem permissão para realizar esta ação.',
  NOT_FOUND: 'Registro não encontrado.',
  CONFLICT: 'Já existe um registro com estes dados.',
  VALIDATION_ERROR: 'Revise os campos informados.',
  TOO_MANY_REQUESTS: 'Muitas tentativas. Aguarde um instante e tente novamente.',
  INTERNAL_SERVER_ERROR: 'Erro interno. Tente novamente em instantes.',
  SERVICE_UNAVAILABLE: 'Serviço indisponível. Tente novamente em instantes.'
}

export function getApiErrorStatus(error: unknown) {
  const shape = error as ApiErrorShape | null

  return shape?.statusCode ?? shape?.status
}

export function getApiErrorCode(error: unknown) {
  return (error as ApiErrorShape | null)?.data?.error?.code
}

export function getApiErrorMessage(
  error: unknown,
  fallback = 'Não foi possível concluir esta ação. Tente novamente.'
) {
  const code = getApiErrorCode(error)

  if (code && ERROR_MESSAGES[code]) {
    return ERROR_MESSAGES[code]
  }

  return fallback
}

export function mapValidationDetails(error: unknown) {
  const details = (error as ApiErrorShape | null)?.data?.error?.details ?? []

  return details.map((detail) => ({
    name: detail.field,
    message: detail.issue
  }))
}
