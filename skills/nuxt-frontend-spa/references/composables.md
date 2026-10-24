# Composables e estado

## Regras

- Use composables para lógica reutilizável.
- Todo acesso à API fica em composables, via `$api`; componentes e páginas não chamam a API.
- Toda mutação passa por `useApiAction`, que garante loading e toasts (ver `feedback.md`).
- Composables de infraestrutura compartilhados: `useApiAction`, `useListQuery` e `useAuth`.
- Um composable tem uma responsabilidade clara.
- Nomeie com `use` + domínio + ação/entidade.
- Retorne apenas o que o consumidor precisa.
- Tipifique o retorno.
- Não exponha estado interno desnecessário.
- Separe estado de servidor de estado de cliente.
- Não duplique estado de servidor em estado cliente.
- Use `useState` apenas para estado compartilhado entre componentes no client.
- Use Pinia apenas quando o estado global for genuinamente necessário.

## Exemplo

```ts
export function useOrderFilters() {
  const page = ref(1)
  const perPage = ref(10)
  const search = ref('')

  function reset() {
    page.value = 1
    perPage.value = 10
    search.value = ''
  }

  return {
    page,
    perPage,
    search,
    reset
  }
}
```
