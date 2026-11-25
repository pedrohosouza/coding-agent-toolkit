import { Prisma } from '~~/server/generated/prisma/client'
import type { PaginatedApiResponse } from '~~/shared/types/api.types'

export interface PaginateOptions {
  page: number
  perPage: number
  search?: string
  searchFields?: readonly string[]
}

interface PaginatableDelegate<TRecord> {
  findMany(args: unknown): Promise<TRecord[]>
  count(args: unknown): Promise<number>
}

interface WhereHolder {
  where?: unknown
}

function isPaginatableDelegate<TRecord>(
  value: unknown
): value is PaginatableDelegate<TRecord> {
  return (
    typeof value === 'object' &&
    value !== null &&
    'findMany' in value &&
    'count' in value
  )
}

function isWhereHolder(value: unknown): value is WhereHolder {
  return typeof value === 'object' && value !== null
}

function buildWhere(
  where: unknown,
  search: string | undefined,
  searchFields: readonly string[] | undefined
): unknown {
  if (!search || !searchFields?.length) {
    return where
  }

  return {
    AND: [
      where ?? {},
      {
        OR: searchFields.map((field) => ({
          [field]: { contains: search, mode: 'insensitive' }
        }))
      }
    ]
  }
}

export const paginationExtension = Prisma.defineExtension({
  name: 'pagination',
  model: {
    $allModels: {
      async paginate<T, A>(
        this: T,
        args: Prisma.Exact<
          A,
          Omit<Prisma.Args<T, 'findMany'>, 'skip' | 'take'>
        >,
        options: PaginateOptions
      ): Promise<PaginatedApiResponse<Prisma.Result<T, A, 'findMany'>[number]>> {
        const { page, perPage, search, searchFields } = options
        const delegate: unknown = Prisma.getExtensionContext(this)

        if (
          !isPaginatableDelegate<Prisma.Result<T, A, 'findMany'>[number]>(
            delegate
          )
        ) {
          throw createError({
            statusCode: 500,
            message: 'Model does not support pagination'
          })
        }

        const baseArgs: WhereHolder = isWhereHolder(args) ? args : {}
        const where = buildWhere(baseArgs.where, search, searchFields)

        const [data, totalItems] = await Promise.all([
          delegate.findMany({
            ...baseArgs,
            where,
            skip: (page - 1) * perPage,
            take: perPage
          }),
          delegate.count({ where })
        ])

        const totalPages = Math.ceil(totalItems / perPage)

        return {
          data,
          pagination: {
            page,
            perPage,
            totalItems,
            totalPages,
            hasNextPage: page < totalPages,
            hasPreviousPage: page > 1
          }
        }
      }
    }
  }
})
