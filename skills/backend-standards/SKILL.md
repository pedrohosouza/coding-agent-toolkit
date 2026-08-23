---
name: backend-standards
description: Padrões obrigatórios ao projetar, criar, alterar ou revisar endpoints de backend/API (REST). Cobre versionamento, configuração via ambiente, formato de resposta (sucesso/erro/paginado), validação de input, integridade referencial, sanitização, paginação, filtragem/ordenação, rate limiting, CORS, idempotência, cache, health checks, graceful shutdown, logging e migrations. Use SEMPRE que a tarefa envolver rota, endpoint, controller, handler HTTP, request/response, variável de ambiente, migration, ou quando o usuário pedir para expor/consumir dados via API no backend — mesmo que não cite "padrões" explicitamente. Agnóstico de framework.
---

# Backend Standards

Regras obrigatórias para endpoints de API. Toda rota nova ou alterada DEVE
seguir estas regras. Em conflito com um pedido pontual, avise antes de violar.

O corpo é agnóstico de framework/linguagem. Exemplos citam ferramentas comuns
apenas como ilustração — adapte à stack do projeto.

## 1. Autenticação e Autorização

- Toda rota é autenticada por padrão. Rotas públicas são marcadas explicitamente.
- Token validado no servidor. Nunca confie em permissão vinda do cliente.
- Verifique autorização por recurso (o usuário só acessa o que é dele) — previne
  IDOR/BOLA. Aplique o menor privilégio.

## 2. Versionamento

- Versione a API na URL: `/v1/...`, `/v2/...`.
- Nunca faça breaking changes numa versão já publicada.
- Mudanças incompatíveis => nova versão. Mantenha compatibilidade retroativa
  dentro da mesma versão.

## 3. Configuração via Ambiente

- **Nenhuma variável de ambiente é acessada diretamente no código.** Todo acesso
  passa por uma camada/serviço de configuração dedicada — nunca leia `process.env`
  (ou equivalente) espalhado pela aplicação.
- Toda env nova é adicionada ao schema de validação da config **antes** de ser
  usada. A aplicação falha no boot (fail-fast) se uma variável obrigatória estiver
  ausente ou inválida.
- Nunca hardcode segredos, URLs ou chaves. Mantenha um `.env.example`
  documentando todas as variáveis (sem valores reais).

## 4. Padronização de Respostas

Use sempre um envelope consistente.

**Sucesso (recurso específico):**
```json
{ "data": { "id": "123", "nome": "Exemplo" } }
```

**Sucesso (lista paginada):**
```json
{
  "data": [ ... ],
  "pagination": { "limit": 20, "next_cursor": "abc123", "has_more": true, "total": 1543 }
}
```

**Erro:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Mensagem legível para humano",
    "details": [ { "field": "email", "issue": "formato inválido" } ]
  }
}
```

- Status codes HTTP corretos (`200`, `201`, `204`, `400`, `401`, `403`, `404`,
  `409`, `422`, `429`, `500`).
- Nunca retorne `200` com um erro dentro do corpo.

## 5. Validação de Input

- Valide TODA entrada (body, query, params, headers) com schema antes de qualquer
  lógica. Tipo, tamanho, formato e obrigatoriedade.
- Use allowlist, nunca blocklist.
- Rejeite campos desconhecidos em vez de ignorá-los silenciosamente.
- Erro de validação retorna `422` (ou `400`) no formato de erro padrão.

## 6. Validação de Relacionamentos (Integridade Referencial)

Diferente da validação de formato — garante que os recursos referenciados
existem e podem ser usados.

- Antes de criar/atualizar um recurso com FK, verifique que o recurso pai existe
  (ex: ao criar um post, confirme que o `user_id` existe). Senão, `422`/`404`.
- Nunca deixe o banco lançar erro de foreign key cru para o cliente.
- Combine com autorização: o usuário pode usar/associar aquele recurso? Senão,
  `403`.
- Ao deletar um pai, defina o comportamento (bloquear, cascatear, soft delete).
  Nunca deixe órfãos.

**Exemplo — criar post com `{ user_id, titulo, conteudo }`:**
```
1. Formato do user_id válido?                 -> senão 422
2. Existe user com esse user_id?              -> senão 422
3. Usuário autenticado pode criar p/ esse id? -> senão 403
4. Cria o post dentro de uma transação
```

## 7. Sanitização

- Sanitize/escape para prevenir injeção (SQL/NoSQL/comando) e XSS.
- Sempre queries parametrizadas — nunca concatene input.
- Saída: nunca exponha campos internos (hash de senha, tokens). Defina
  explicitamente o que sai.

## 8. Limite de Tamanho de Payload

- Rejeite bodies acima do limite (padrão: 1 MB) com `413`.
- Limites específicos para uploads; valide `Content-Length` e tipo real de arquivo.

## 9. Paginação

- Toda rota que retorna lista DEVE paginar. Nunca retorne coleção sem limite.
- `limit` padrão: 20; máximo: 100 (rejeite acima).
- Cursor-based para grandes volumes / tempo real; offset apenas para conjuntos
  pequenos/estáticos.
- Sempre inclua o bloco `pagination` (ver seção 2).

## 10. Filtragem e Ordenação

- Filtros via query params: `?status=ativo&tipo=x`.
- Ordenação: `?sort=campo&order=asc|desc`.
- Valide campos de filtro/ordenação contra allowlist — nunca aceite campo
  arbitrário (previne exposição e injeção).
- Sempre combinada com paginação.

## 11. Rate Limiting

- Estratégia sliding window ou token bucket; contador em store distribuído (ex:
  Redis).
- Identificação por: API key > token > IP.
- Limites base: público 60 req/min por IP; autenticado 1000 req/min por token;
  sensível (login, reset) 5–10 req/min por IP.
- Ao exceder: `429`. Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`,
  `X-RateLimit-Reset`, e `Retry-After` no 429.

## 12. CORS

- Allowlist explícita de origens (via env). NUNCA `*` em API autenticada.
- Métodos e headers permitidos: só os realmente usados.
- `Allow-Credentials: true` só com cookies — e aí a origem não pode ser `*`.
- Responda ao preflight `OPTIONS`; use `Access-Control-Max-Age`.

## 13. Idempotência

- Operações não-seguras repetíveis (ex: pagamentos) aceitam header
  `Idempotency-Key`. Mesma chave => mesmo resultado, sem duplicar efeito.
- Guarde o resultado da chave por uma janela (ex: 24h).

## 14. Idempotência de Webhooks / Eventos

- Todo evento/webhook carrega ID único; consumidores descartam IDs já
  processados (dedupe).
- Assine payloads enviados (HMAC) para verificação de autenticidade.
- Eventos que falham repetidamente vão para dead letter queue, não são
  descartados.

## 15. Cache

- `Cache-Control` conforme a natureza do recurso; `ETag`/`Last-Modified` +
  `304` quando aplicável.
- Estratégia clara de invalidação (tempo, evento ou versão).
- Nunca cacheie dados sensíveis/por-usuário sem `Cache-Control: private`.

## 16. Health Checks

- `/health` (liveness) e `/readiness` (dependências OK).
- Não exigem autenticação, mas não expõem detalhes internos sensíveis.

## 17. Graceful Shutdown

- Ao receber SIGTERM/SIGINT: pare de aceitar novas requisições, finalize as em
  andamento, feche conexões e encerre. Defina timeout máximo.

## 18. Logging Estruturado

- Logs em JSON, não texto livre.
- Todo log de requisição inclui `request_id` (correlation ID), propagado
  downstream.
- NUNCA logue dados sensíveis (senhas, tokens, PII, corpo de pagamento).
- Registre: método, rota, status, latência, request_id, user_id (quando houver).

## 19. Migrations

- **Toda mudança de schema passa por migration versionada.** Nunca altere o banco
  manualmente.
- Migrations são reversíveis (up/down) sempre que possível e ficam versionadas no
  git; nunca edite uma migration já aplicada em ambiente compartilhado — crie uma
  nova.
- Migrations rodam no deploy, de forma controlada. Nunca use reset destrutivo em
  banco com dados reais.