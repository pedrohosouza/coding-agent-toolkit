# Better Auth no cliente

## Regras

- O Better Auth roda no mesmo app: o cliente chama `/api/auth/*` na mesma origem, então os cookies funcionam sem `credentials` nem CORS.
- Existe um único cliente, `$authClient`, criado em `app/plugins/auth-client.ts` com `createAuthClient` de `better-auth/vue` e provido via `provide`.
- O plugin `organizationClient` entra quando o servidor usa o plugin Organization.
- `useAuth` é o único composable de sessão; páginas, middleware e componentes leem a sessão dele.
- A sessão fica em `useState('auth:session')`: é buscada no servidor, serializada no payload e hidratada no cliente, sem flash de "deslogado".
- No SSR, o cookie da requisição não é repassado sozinho: `refreshSession` envia `useRequestHeaders(['cookie'])` em `fetchOptions.headers` (no cliente o objeto é vazio).
- Chame `useRequestHeaders` no trecho síncrono, antes de qualquer `await`, para não perder o contexto do Nuxt.
- No servidor, `baseURL` vem de `useRequestURL().origin`; no cliente, da origem atual.
- `signIn` e `signOut` lançam o erro do Better Auth; quem chama mostra o toast com `getAuthErrorMessage` (ver `feedback.md`).
- Redirecione após login com `callbackURL` relativo; não use `window.location`.
- Nunca guarde token ou dado sensível no payload SSR; exponha só `session.user` e o necessário para a interface.
- A sessão do cliente serve à interface; o servidor valida a sessão em toda requisição.
- Templates: `auth-client.plugin.ts.tpl`, `use-auth.ts.tpl` e `auth-error.util.ts.tpl`.

## Plugin

```ts
import { organizationClient } from 'better-auth/client/plugins'
import { createAuthClient } from 'better-auth/vue'

export default defineNuxtPlugin(() => {
  const authClient = createAuthClient({
    baseURL: useRequestURL().origin,
    plugins: [organizationClient()]
  })

  return { provide: { authClient } }
})
```

## `useAuth`

```ts
async function refreshSession() {
  const headers = useRequestHeaders(['cookie'])

  const result = await $authClient.getSession({ fetchOptions: { headers } })

  session.value = result.data
}
```

- Expõe `authenticated`, `user`, `pending`, `session`, `refreshSession`, `signIn` e `signOut`.
- Papéis e organização ativa entram nele quando o projeto precisar.
- `signOut` zera a `session` e a navegação seguinte vai para o login.
