# Composables e estado

## Regras

- Use composables para lógica reutilizável.
- Todo acesso à API fica em composables: leitura com `useFetch`/`useAsyncData`, mutação com `$fetch` dentro de `useApiAction`; componentes e páginas não chamam a API (ver `data-fetching.md`).
- Toda mutação passa por `useApiAction`, que garante loading e toasts (ver `feedback.md`).
- Composables de infraestrutura compartilhados: `useApiAction`, `useListQuery` e `useAuth`.
- Um composable tem uma responsabilidade clara.
- Nomeie com `use` + domínio + ação/entidade; o arquivo é `useX.ts`.
- Retorne apenas o que o consumidor precisa e tipifique o retorno.
- Separe estado de servidor de estado de cliente; não duplique estado de servidor em estado cliente.
- Estado compartilhado entre componentes usa `useState('chave')`; nunca `ref` no escopo do módulo, pois vaza entre requisições no servidor.
- Chame composables do Nuxt (`useFetch`, `useState`, `useRoute`) de forma síncrona no `setup`, antes de qualquer `await`.
- Código com `window` ou `document` fica em `onMounted` ou `import.meta.client`.
- Use Pinia apenas quando o estado global for genuinamente necessário.

## Exemplo

```ts
export function useOrderFilters() {
  const status = useState<string | undefined>('order-filters:status')

  function reset() {
    status.value = undefined
  }

  return { reset, status }
}
```
