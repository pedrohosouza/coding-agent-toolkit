import type { ApiListResponse } from '~/types/api.types'
import type { {{EntityName}}Payload } from '~/schemas/{{entity-name}}.validation'
import type { {{EntityName}} } from '~/types/{{entity-name}}.types'

export function use{{EntityNames}}() {
  const { $api } = useNuxtApp()
  const { query, searchInput, setPage, setPerPage } = useListQuery([], {
    defaults: { sort: 'createdAt', order: 'desc' }
  })

  const { data, error, pending, refresh } = useAsyncData(
    '{{entity-names}}',
    () =>
      $api<ApiListResponse<{{EntityName}}>>('/{{entity-names}}', {
        query: query.value
      }),
    { watch: [query] }
  )

  const items = computed(() => data.value?.data ?? [])
  const pagination = computed(() => data.value?.pagination)
  const { run, running, validationErrors } = useApiAction(refresh)

  function create(input: {{EntityName}}Payload) {
    return run(
      () => $api('/{{entity-names}}', { method: 'POST', body: input }),
      {
        success: '{{EntityName}} criado',
        failure: 'Não foi possível criar'
      }
    )
  }

  function update(id: string, input: {{EntityName}}Payload) {
    return run(
      () => $api(`/{{entity-names}}/${id}`, { method: 'PATCH', body: input }),
      {
        success: '{{EntityName}} atualizado',
        failure: 'Não foi possível atualizar'
      }
    )
  }

  function remove(id: string) {
    return run(() => $api(`/{{entity-names}}/${id}`, { method: 'DELETE' }), {
      success: '{{EntityName}} excluído',
      failure: 'Não foi possível excluir'
    })
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
