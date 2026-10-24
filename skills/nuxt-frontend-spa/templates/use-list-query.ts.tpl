import type { ListQuery } from '~/types/api.types'

type FilterValue = string | number | boolean | undefined

interface ListQueryOptions {
  defaults?: Partial<Omit<ListQuery, 'page' | 'perPage'>>
  perPage?: number
}

const SEARCH_DEBOUNCE_MS = 350
const MIN_PER_PAGE = 10

function readString(value: unknown) {
  return typeof value === 'string' && value !== '' ? value : undefined
}

function readNumber(value: unknown, fallback: number) {
  const parsed = Number(readString(value))

  return Number.isInteger(parsed) && parsed > 0 ? parsed : fallback
}

export function useListQuery(
  filterKeys: string[] = [],
  options: ListQueryOptions = {}
) {
  const route = useRoute()
  const router = useRouter()
  const defaultPerPage = options.perPage ?? 10

  const query = computed<ListQuery>(() => {
    const result: ListQuery = {
      ...options.defaults,
      page: readNumber(route.query.page, 1),
      perPage: Math.max(
        readNumber(route.query.perPage, defaultPerPage),
        MIN_PER_PAGE
      )
    }

    const search = readString(route.query.search)

    if (search) {
      result.search = search
    }

    for (const key of filterKeys) {
      const value = readString(route.query[key])

      if (value !== undefined) {
        result[key] = value
      }
    }

    return result
  })

  const searchInput = ref(query.value.search ?? '')
  let searchTimer: ReturnType<typeof setTimeout> | undefined

  function patchQuery(patch: Record<string, FilterValue>, resetPage = true) {
    const next: Record<string, string> = {}

    for (const [key, value] of Object.entries({
      ...route.query,
      ...(resetPage ? { page: undefined } : {}),
      ...patch
    })) {
      if (value !== undefined && value !== '' && value !== null) {
        next[key] = String(value)
      }
    }

    return router.replace({ query: next })
  }

  function setPage(page: number) {
    return patchQuery({ page }, false)
  }

  function setPerPage(perPage: number) {
    return patchQuery({ perPage })
  }

  function setFilter(key: string, value: FilterValue) {
    return patchQuery({ [key]: value })
  }

  watch(searchInput, (value) => {
    clearTimeout(searchTimer)
    searchTimer = setTimeout(() => {
      void patchQuery({ search: value.trim() || undefined })
    }, SEARCH_DEBOUNCE_MS)
  })

  onScopeDispose(() => clearTimeout(searchTimer))

  return { query, searchInput, setFilter, setPage, setPerPage }
}
