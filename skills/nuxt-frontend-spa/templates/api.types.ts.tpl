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

export interface ApiListResponse<T> {
  data: T[]
  pagination: Pagination
}

export interface ApiValidationDetail {
  field: string
  issue: string
}

export interface ApiErrorBody {
  error?: {
    code?: string
    message?: string
    details?: ApiValidationDetail[]
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
