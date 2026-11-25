export interface Pagination {
  page: number
  perPage: number
  totalItems: number
  totalPages: number
  hasNextPage: boolean
  hasPreviousPage: boolean
}

export interface ApiResponse<T> {
  data: T
}

export interface PaginatedApiResponse<T> {
  data: T[]
  pagination: Pagination
}

export interface ApiErrorDetail {
  field: string
  issue: string
}

export interface ApiErrorResponse {
  error: {
    code: string
    message: string
    details?: ApiErrorDetail[]
  }
}

export interface ListQuery {
  page: number
  perPage: number
  search?: string
  sort?: string
  order?: 'asc' | 'desc'
  [filter: string]: string | number | boolean | undefined
}
