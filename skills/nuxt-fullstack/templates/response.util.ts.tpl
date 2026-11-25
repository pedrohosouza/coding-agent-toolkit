import type {
  ApiResponse,
  PaginatedApiResponse
} from '~~/shared/types/api.types'

export function respond<T>(data: T): ApiResponse<T> {
  return { data }
}

export function respondPaginated<T>(
  result: PaginatedApiResponse<T>
): PaginatedApiResponse<T> {
  return { data: result.data, pagination: result.pagination }
}
