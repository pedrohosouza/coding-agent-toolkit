# Middleware de rota

## Regras

- Middleware existe para navegação e experiência do usuário; não é barreira de segurança.
- Toda autorização real é validada pelo backend.
- Nunca trate role, permissão ou ID guardado no navegador como fonte confiável.
- O estado de autenticação vive em um único composable (`useAuth`); o middleware o consome.
- Não replique regras de autorização do backend além do necessário para controlar a interface.
- Um middleware tem uma responsabilidade.
- Não use `import.meta.server`; a aplicação roda só no cliente.

## Sessão: `useAuth`

- `useAuth` é o único composable de sessão; middleware, páginas e componentes leem a sessão dele.
- Ele usa o `$authClient` (Better Auth), provido por `plugins/auth-client.ts` com `credentials: 'include'` e `basePath: '/api/auth'`, igual ao backend.
- Expõe `authenticated`, `user`, `pending`, `session`, `refreshSession`, `signIn` e `signOut`; papéis e organização entram nele quando o projeto precisar.
- As ações lançam o erro do Better Auth; quem chama mostra o toast com `getAuthErrorMessage` (ver `feedback.md`).
- Os templates estão em `templates/`: `auth-client.plugin.ts.tpl`, `use-auth.ts.tpl` e `auth-error.util.ts.tpl`.
- A sessão no navegador serve para a interface; o backend valida a sessão em toda requisição.

## Nomes e arquivos

- O arquivo fica em `app/middleware/` com nome `kebab-case` e **sem** sufixo `.middleware`.
- O nome do arquivo é o nome do middleware em `definePageMeta`; `auth.middleware.ts` viraria `auth.middleware`.

```text
middleware/
├── auth.ts
├── guest.ts
└── org-admin.ts
```

## Uso

Aplique por página com `definePageMeta`:

```ts
definePageMeta({ middleware: 'auth' })
```

Para vários: `middleware: ['auth', 'org-admin']`.

## Exemplos

Exige sessão:

```ts
export default defineNuxtRouteMiddleware(async (to) => {
  const { authenticated, refreshSession } = useAuth()

  await refreshSession()

  if (!authenticated.value) {
    return navigateTo({
      path: '/auth/login',
      query: { redirect: to.fullPath }
    })
  }
})
```

Bloqueia quem já está autenticado:

```ts
export default defineNuxtRouteMiddleware(async () => {
  const { authenticated, refreshSession } = useAuth()

  await refreshSession()

  if (authenticated.value) {
    return navigateTo('/')
  }
})
```

Restringe por papel: exponha um `computed` (por exemplo `isAdmin`) em `useAuth`, derivado do papel que o backend devolve na sessão, e use-o no middleware:

```ts
export default defineNuxtRouteMiddleware(() => {
  const { isAdmin } = useAuth()

  if (!isAdmin.value) {
    return navigateTo('/')
  }
})
```

- Redirecione para uma rota segura; nunca deixe a página em branco.
- Preserve o destino original em `query.redirect` ao mandar para o login.
