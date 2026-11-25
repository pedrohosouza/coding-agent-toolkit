import type {
  Create{{EntityName}}Input,
  Update{{EntityName}}Input
} from '#shared/schemas/{{entity-name}}.validation'
import type { PaginatedApiResponse } from '#shared/types/api.types'
import type { {{EntityName}} } from '#shared/types/{{entity-name}}.types'

export function use{{EntityNames}}() {
  const { query, searchInput, setPage, setPerPage } = useListQuery([], {
    defaults: { sort: 'createdAt', order: 'desc' }
  })

  const { data, error, pending, refresh } = useFetch<
    PaginatedApiResponse<{{EntityName}}>
  >('/api/{{entity-names}}', {
    key: '{{entity-names}}-list',
    query
  })

  const items = computed(() => data.value?.data ?? [])
  const pagination = computed(() => data.value?.pagination)
  const { run, running, validationErrors } = useApiAction(refresh)

  function create(input: Create{{EntityName}}Input) {
    return run(
      () => $fetch('/api/{{entity-names}}', { method: 'POST', body: input }),
      {
        success: '{{EntityName}} criado',
        failure: 'Não foi possível criar'
      }
    )
  }

  function update(id: string, input: Update{{EntityName}}Input) {
    return run(
      () =>
        $fetch(`/api/{{entity-names}}/${id}`, { method: 'PATCH', body: input }),
      {
        success: '{{EntityName}} atualizado',
        failure: 'Não foi possível atualizar'
      }
    )
  }

  function remove(id: string) {
    return run(
      () => $fetch(`/api/{{entity-names}}/${id}`, { method: 'DELETE' }),
      {
        success: '{{EntityName}} excluído',
        failure: 'Não foi possível excluir'
      }
    )
  }

  return {
    create,
    error,
    items,
    pagination,
    pending,
    refresh,
    remove,
    running,
    searchInput,
    setPage,
    setPerPage,
    update,
    validationErrors
  }
}
