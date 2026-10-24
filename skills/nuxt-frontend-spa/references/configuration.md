# Configuração e ambiente

A aplicação é uma SPA executada no navegador. Tudo o que entra no build ou no runtime do frontend é visível para o usuário.

## Regras

- Nunca acesse `process.env` em componentes, composables, plugins, middleware ou utils.
- Toda configuração é declarada em `runtimeConfig.public` no `nuxt.config.ts` e lida com `useRuntimeConfig()`.
- Use exclusivamente `runtimeConfig.public`; não use `runtimeConfig` privado.
- Os valores vêm de variáveis com prefixo `NUXT_PUBLIC_`.
- Nunca faça hardcode de URL de API, domínio, ID de ambiente ou qualquer valor que varie entre ambientes.
- Nunca guarde segredo no frontend: JWT secret, chave privada, token administrativo, credencial de serviço.
- Integração que exige segredo não é chamada pela SPA; passa por um endpoint do backend.
- Não valide JWT no frontend como mecanismo de segurança.
- Toda variável nova entra em `runtimeConfig.public` e em `.env.example`, sem valor real, antes do primeiro uso.
- Mantenha `ssr: false`.

## Declaração

```ts
export default defineNuxtConfig({
  ssr: false,
  runtimeConfig: {
    public: {
      apiBaseUrl: ''
    }
  }
})
```

A chave `apiBaseUrl` é preenchida por `NUXT_PUBLIC_API_BASE_URL`.

## `.env.example`

```text
NUXT_PUBLIC_API_BASE_URL=http://localhost:8000
```

## Uso

```ts
const config = useRuntimeConfig()
const baseURL = `${config.public.apiBaseUrl}/api`
```

## Convenção de nomes

| Chave em `runtimeConfig.public` | Variável de ambiente |
|---|---|
| `apiBaseUrl` | `NUXT_PUBLIC_API_BASE_URL` |
| `salesWhatsappNumber` | `NUXT_PUBLIC_SALES_WHATSAPP_NUMBER` |

- A chave é `camelCase`; a variável é `UPPER_SNAKE_CASE` com prefixo `NUXT_PUBLIC_`.
