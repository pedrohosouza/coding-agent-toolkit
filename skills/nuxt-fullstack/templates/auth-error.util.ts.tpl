interface AuthErrorShape {
  message?: string
  status?: number
  statusCode?: number
}

export function getAuthErrorMessage(
  error: unknown,
  fallback = 'Não foi possível concluir esta ação. Tente novamente.'
) {
  if (!error || typeof error !== 'object') {
    return fallback
  }

  const authError = error as AuthErrorShape
  const status = authError.status ?? authError.statusCode

  if (status === 429) {
    return 'Muitas tentativas em pouco tempo. Aguarde alguns minutos e tente novamente.'
  }

  if (status === 401) {
    return 'E-mail ou senha incorretos.'
  }

  if (status === 403) {
    return 'Confirme seu e-mail antes de entrar.'
  }

  if (status && status >= 500) {
    return 'O serviço de autenticação está indisponível. Tente novamente em instantes.'
  }

  return fallback
}
