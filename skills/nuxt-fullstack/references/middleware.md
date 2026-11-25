# Middleware de rota

## Regras

- Middleware existe para navegação e experiência do usuário; não é barreira de segurança.
- Toda autorização real é validada pelo servidor, em cada rota `/api/*`.
- Nunca trate role, permissão ou ID guardado no navegador como fonte confiável.
- O estado de autenticação vive em um único composable (`useAuth`); o middleware o consome (ver `auth-client.md`).
- Middleware de rota roda no servidor na primeira requisição e no cliente nas navegações seguintes; escreva-o para os dois contextos, sem `import.meta.server` nem `window`.
- Busque a sessão só quando ela ainda não estiver em `useState` (`if (!authenticated.value) await refreshSession()`); no SSR o cookie é repassado por `useRequestHeaders(['cookie'])` dentro de `refreshSession`.
- Redirecione com `return navigateTo(...)`; no SSR isso vira um `302`, sem flash de conteúdo protegido.
- Não replique regras de autorização do servidor além do necessário para controlar a interface.
- Um middleware tem uma responsabilidade.

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

```ts
definePageMeta({ middleware: 'auth' })
```

Para vários: `middleware: ['auth', 'org-admin']`.

## Exemplos

Exige sessão:

```ts
export default defineNuxtRouteMiddleware(async (to) => {
  const { authenticated, refreshSession } = useAuth()

  if (!authenticated.value) {
    await refreshSession()
  }

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

  if (!authenticated.value) {
    await refreshSession()
  }

  if (authenticated.value) {
    return navigateTo('/')
  }
})
```

Restringe por papel: exponha um `computed` (por exemplo `isAdmin`) em `useAuth`, derivado do papel que a sessão devolve, e use-o no middleware.

- Redirecione para uma rota segura; nunca deixe a página em branco.
- Preserve o destino original em `query.redirect` ao mandar para o login.
- Rotas `/api/*` não passam por middleware de rota; elas são protegidas pelo middleware de servidor.
