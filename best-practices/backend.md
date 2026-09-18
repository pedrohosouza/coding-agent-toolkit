# Checklist de Boas Práticas para APIs

Use esta lista na criação, revisão e publicação de APIs. Adapte limites e
ferramentas à realidade do projeto, mas registre qualquer exceção relevante.

## Contrato e design

- [ ] **Modele recursos com nomes claros e consistentes.** Use substantivos nas
  rotas, plural consistente e hierarquia apenas quando existir relação real.
- [ ] **Use os métodos HTTP conforme sua semântica.** `GET` consulta, `POST`
  cria ou dispara ação, `PUT` substitui, `PATCH` altera parcialmente e `DELETE`
  remove.
- [ ] **Versione a API.** Publique rotas como `/v1/...` e crie nova versão para
  mudanças incompatíveis.
- [ ] **Preserve compatibilidade dentro da mesma versão.** Não remova nem altere
  campos publicados sem estratégia de depreciação.
- [ ] **Documente o contrato.** Mantenha OpenAPI ou formato equivalente alinhado
  ao comportamento real da aplicação.
- [ ] **Defina tipos, formatos e exemplos.** Documente requests, responses,
  headers, autenticação, paginação e todos os erros possíveis.
- [ ] **Mantenha convenção única de nomes.** Escolha `snake_case` ou `camelCase`
  para o payload e aplique em toda a API.
- [ ] **Defina datas e horários sem ambiguidade.** Use ISO 8601, UTC no transporte
  e timezone explícito quando o domínio exigir.
- [ ] **Use IDs opacos.** Não exponha informação sensível ou previsível em
  identificadores públicos quando isso aumentar risco de enumeração.
- [ ] **Planeje depreciações.** Avise consumidores, informe prazo e monitore uso
  antes de remover uma versão ou campo.

## Respostas e erros

- [ ] **Padronize o envelope de sucesso.** Retorne recurso em `data` e metadados
  em campos previsíveis.
- [ ] **Padronize o envelope de erro.** Inclua código estável, mensagem legível e
  detalhes seguros por campo quando aplicável.
- [ ] **Use status HTTP correto.** Não retorne `200` quando a operação falhar.
- [ ] **Retorne `201` em criação.** Inclua o recurso criado e, quando útil, header
  `Location`.
- [ ] **Retorne `204` apenas sem corpo.** Não envie JSON junto desse status.
- [ ] **Diferencie autenticação e autorização.** Use `401` para credencial ausente
  ou inválida e `403` para acesso negado.
- [ ] **Trate conflitos de domínio.** Use `409` para duplicidade, concorrência ou
  estado incompatível.
- [ ] **Não exponha detalhes internos.** Stack trace, SQL, caminho de arquivo e
  nomes de infraestrutura ficam apenas nos logs protegidos.
- [ ] **Inclua `request_id`.** Permita relacionar erro recebido pelo cliente aos
  logs e traces do servidor.

Exemplo de sucesso:

```json
{
  "data": {
    "id": "123",
    "nome": "Exemplo"
  }
}
```

Exemplo de lista paginada:

```json
{
  "data": [],
  "pagination": {
    "limit": 20,
    "next_cursor": "abc123",
    "has_more": true,
    "total": 1543
  }
}
```

Exemplo de erro:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Existem campos inválidos.",
    "details": [
      {
        "field": "email",
        "issue": "formato inválido"
      }
    ],
    "request_id": "req_123"
  }
}
```

## Validação e sanitização

- [ ] **Valide toda entrada antes da regra de negócio.** Inclua body, query,
  params, headers, cookies e arquivos.
- [ ] **Valide com schema.** Verifique tipo, obrigatoriedade, tamanho, formato,
  faixa, enum e estrutura.
- [ ] **Use allowlist.** Aceite somente campos, filtros, ordenações, MIME types e
  valores previstos.
- [ ] **Rejeite campos desconhecidos.** Evite aceitar dados ignorados ou permitir
  mass assignment.
- [ ] **Normalize somente quando seguro.** Não altere silenciosamente dados cujo
  formato tenha significado para o domínio.
- [ ] **Use queries parametrizadas.** Nunca concatene entrada em SQL, NoSQL,
  comandos, templates ou expressões.
- [ ] **Escape saída conforme o contexto.** Previna XSS, injeção em logs e outras
  interpretações indevidas.
- [ ] **Limite tamanho do body.** Use `1 MB` como ponto de partida e retorne `413`
  quando o limite for excedido.
- [ ] **Valide uploads pelo conteúdo real.** Verifique tamanho, assinatura, tipo,
  extensão e nome; armazene fora da área executável.
- [ ] **Remova metadados sensíveis de arquivos.** Faça isso quando EXIF ou outros
  metadados puderem expor usuário ou ambiente.
- [ ] **Selecione explicitamente campos de saída.** Nunca serialize entidades do
  banco diretamente nem retorne hashes, tokens ou campos internos.

## Relacionamentos e regras de domínio

- [ ] **Valide referências antes de gravar.** Confirme que cada recurso pai
  existe e está em estado permitido.
- [ ] **Autorize cada associação.** Existência do recurso não significa permissão
  para consultar, alterar ou relacionar.
- [ ] **Não devolva erro bruto de foreign key.** Converta falhas de integridade em
  erro de domínio seguro.
- [ ] **Defina comportamento de exclusão.** Escolha bloquear, cascatear ou usar
  soft delete sem deixar registros órfãos.
- [ ] **Proteja invariantes com o banco.** Use constraints, índices únicos e
  chaves estrangeiras além da validação na aplicação.
- [ ] **Use transações em alterações relacionadas.** Todas as etapas devem
  confirmar ou reverter juntas.
- [ ] **Evite transações longas.** Não mantenha locks enquanto chama serviços
  externos ou executa trabalho demorado.
- [ ] **Controle concorrência.** Use versão, lock otimista ou outra estratégia
  para impedir sobrescrita silenciosa.

## Autenticação e autorização

- [ ] **Autentique por padrão.** Marque rotas públicas explicitamente.
- [ ] **Valide credenciais no servidor.** Confira assinatura, emissor, audiência,
  validade e revogação quando aplicável.
- [ ] **Autorize por recurso e ação.** Previna IDOR/BOLA verificando dono, tenant,
  papel e escopo em toda operação.
- [ ] **Aplique menor privilégio.** Usuários, serviços, banco e filas recebem
  somente permissões necessárias.
- [ ] **Isole tenants.** Inclua o contexto do tenant em consultas, cache, eventos,
  arquivos e logs.
- [ ] **Proteja sessões e cookies.** Use `Secure`, `HttpOnly`, `SameSite`, rotação
  e expiração adequadas.
- [ ] **Proteja autenticação contra abuso.** Aplique rate limit, atraso progressivo
  e MFA em operações de maior risco.
- [ ] **Armazene senhas com algoritmo próprio.** Use Argon2id, scrypt ou bcrypt
  com custo revisado; nunca criptografia reversível.
- [ ] **Evite enumeração de contas.** Respostas de login e recuperação não devem
  revelar se usuário existe.
- [ ] **Exija reautenticação em ações críticas.** Troca de senha, pagamento e
  mudança de segurança podem exigir confirmação recente.

## Segurança HTTP e privacidade

- [ ] **Use HTTPS em todos os ambientes expostos.** Redirecione HTTP e habilite
  HSTS quando domínio e operação permitirem.
- [ ] **Configure CORS com allowlist.** Nunca use `*` em API autenticada.
- [ ] **Permita apenas métodos e headers necessários.** Trate preflight `OPTIONS`
  e configure `Access-Control-Max-Age` conscientemente.
- [ ] **Use credenciais no CORS somente quando necessário.** `Allow-Credentials`
  exige origem explícita e proteção CSRF para autenticação por cookie.
- [ ] **Configure headers de segurança.** Inclua `X-Content-Type-Options`, política
  de framing e demais headers compatíveis com o uso da API.
- [ ] **Não aceite redirects arbitrários.** Valide destinos contra allowlist.
- [ ] **Previna SSRF.** Restrinja protocolo, host, IP e redirecionamentos em URLs
  fornecidas pelo cliente.
- [ ] **Minimize dados pessoais.** Colete, processe e retenha somente o necessário.
- [ ] **Defina retenção e exclusão.** Dados e backups seguem requisitos legais e
  pedidos válidos do usuário.
- [ ] **Audite ações sensíveis.** Registre ator, ação, alvo, resultado e horário
  sem armazenar segredo ou conteúdo desnecessário.

## Segredos e configuração

- [ ] **Centralize acesso à configuração.** Nenhum módulo lê `process.env` ou
  equivalente diretamente fora da camada dedicada.
- [ ] **Valide configuração no boot.** Falhe rápido quando variável obrigatória
  estiver ausente, inválida ou incompatível.
- [ ] **Mantenha `.env.example`.** Documente todas as variáveis sem valores reais.
- [ ] **Nunca grave segredos no código ou repositório.** Use secret manager e
  credenciais distintas por ambiente.
- [ ] **Rotacione segredos.** Tenha procedimento para troca sem indisponibilidade
  e revogação imediata em incidente.
- [ ] **Separe ambientes.** Desenvolvimento, teste, staging e produção não
  compartilham banco, chaves nem filas.
- [ ] **Defina defaults apenas para valores seguros.** Configuração crítica não
  deve assumir valor permissivo quando ausente.

## Paginação, filtros e ordenação

- [ ] **Pagine toda coleção.** Nunca retorne lista potencialmente ilimitada.
- [ ] **Defina limite padrão e máximo.** Comece com `20` e limite a `100`, salvo
  necessidade documentada.
- [ ] **Prefira cursor em grandes volumes.** Use offset apenas em conjuntos
  pequenos ou estáticos.
- [ ] **Use ordenação determinística.** Inclua critério único de desempate para
  não pular nem repetir itens.
- [ ] **Valide filtros e campos de ordenação.** Compare tudo com allowlist.
- [ ] **Evite consultas livres do cliente.** Não exponha diretamente SQL, campos
  internos ou operadores sem controle.
- [ ] **Retorne metadados consistentes.** Inclua `limit`, próximo cursor,
  `has_more` e `total` apenas quando seu custo for aceitável.

## Idempotência, eventos e integrações

- [ ] **Ofereça idempotência em operações críticas.** Pagamentos e criações
  repetíveis aceitam `Idempotency-Key`.
- [ ] **Associe chave ao consumidor e payload.** Reuso com payload diferente deve
  falhar em vez de devolver resultado incorreto.
- [ ] **Armazene resultado por janela definida.** Documente prazo, como `24h`, e
  devolva a mesma resposta para repetição válida.
- [ ] **Use ID único em eventos e webhooks.** Consumidores registram IDs processados
  e descartam duplicatas.
- [ ] **Assine webhooks.** Use HMAC, timestamp e tolerância curta contra replay.
- [ ] **Responda webhooks rapidamente.** Enfileire processamento demorado.
- [ ] **Aplique retry com backoff e jitter.** Limite tentativas e não repita erros
  permanentes.
- [ ] **Use dead letter queue.** Preserve eventos que excederem tentativas para
  análise e reprocessamento controlado.
- [ ] **Use outbox quando consistência exigir.** Garanta publicação de evento após
  commit sem janela de perda entre banco e broker.
- [ ] **Defina timeouts em toda chamada externa.** Nenhuma requisição aguarda
  indefinidamente.
- [ ] **Use circuit breaker quando adequado.** Isole dependência instável e evite
  falha em cascata.

## Rate limiting e proteção contra abuso

- [ ] **Aplique rate limit distribuído.** Use sliding window ou token bucket em
  store compartilhado quando houver mais de uma instância.
- [ ] **Identifique consumidor corretamente.** Prefira API key, token e depois IP.
- [ ] **Use limites menores em rotas sensíveis.** Login e reset podem começar em
  `5–10 req/min` por IP.
- [ ] **Defina limites por risco e custo.** Considere escrita, busca pesada,
  exportação e upload separadamente.
- [ ] **Retorne `429` ao exceder.** Envie `Retry-After` e headers de limite
  consistentes.
- [ ] **Não confie apenas em IP.** Proxies, NAT e atacantes distribuídos exigem
  mais sinais de proteção.

## Cache

- [ ] **Defina política por recurso.** Configure `Cache-Control` conforme
  sensibilidade, frequência de alteração e compartilhamento permitido.
- [ ] **Use validação condicional.** Ofereça `ETag` ou `Last-Modified` e responda
  `304` quando aplicável.
- [ ] **Planeje invalidação antes de ativar cache.** Use prazo, evento, versão ou
  combinação explícita.
- [ ] **Separe cache por usuário e tenant.** A chave inclui todo contexto que muda
  o resultado.
- [ ] **Marque conteúdo sensível como privado.** Use `private` ou `no-store`
  conforme o risco.
- [ ] **Evite cache stampede.** Use lock, stale-while-revalidate ou jitter de TTL
  em dados muito acessados.

## Banco de dados e migrations

- [ ] **Versione toda mudança de schema.** Nunca altere banco compartilhado
  manualmente.
- [ ] **Não edite migration já aplicada.** Crie nova migration corretiva.
- [ ] **Faça migrations reversíveis quando possível.** Documente recuperação para
  alterações irreversíveis.
- [ ] **Planeje mudanças sem downtime.** Expanda schema, migre dados, troque a
  aplicação e remova legado em etapa posterior.
- [ ] **Faça backfill em lotes.** Evite locks longos, crescimento abrupto do log e
  sobrecarga de produção.
- [ ] **Crie índices para consultas reais.** Confirme plano de execução e custo de
  escrita antes de adicionar índice.
- [ ] **Evite consultas N+1.** Carregue relações em lote e monitore volume de
  queries por request.
- [ ] **Defina timeout e pool de conexões.** Dimensione limites para aplicação e
  banco sem esgotar recursos.
- [ ] **Tenha backup e restauração testados.** Backup sem teste de restore não
  comprova recuperação.

## Desempenho e resiliência

- [ ] **Defina metas mensuráveis.** Estabeleça SLOs de latência, disponibilidade e
  taxa de erro por operação importante.
- [ ] **Meça antes de otimizar.** Use métricas, traces e profiling para encontrar
  gargalos reais.
- [ ] **Evite trabalho pesado no request.** Use fila para relatórios, mídia,
  notificações e tarefas demoradas.
- [ ] **Aplique backpressure.** Limite concorrência e rejeite carga acima da
  capacidade de forma controlada.
- [ ] **Defina timeouts de servidor e banco.** Cancele trabalho quando cliente ou
  prazo da operação terminar.
- [ ] **Propague cancelamento.** Interrompa consultas e chamadas downstream que não
  serão mais usadas.
- [ ] **Teste degradação de dependências.** A API deve falhar de forma previsível
  quando banco, cache, fila ou serviço externo estiver indisponível.

## Observabilidade

- [ ] **Gere logs estruturados em JSON.** Evite texto livre difícil de consultar.
- [ ] **Propague `request_id` e trace context.** Relacione gateway, API, fila e
  serviços downstream.
- [ ] **Registre contexto útil.** Inclua método, rota normalizada, status, latência,
  request ID e ID do usuário quando permitido.
- [ ] **Nunca registre segredos ou dados sensíveis.** Redija tokens, senhas,
  cookies, dados de pagamento e PII.
- [ ] **Colete métricas técnicas e de negócio.** Acompanhe taxa, erros, duração,
  saturação e operações críticas.
- [ ] **Use tracing distribuído.** Instrumente banco, cache, filas e chamadas
  externas nas rotas importantes.
- [ ] **Crie alertas acionáveis.** Alerte por impacto ao usuário e inclua runbook,
  responsável e contexto.
- [ ] **Controle cardinalidade.** Não use IDs livres como labels de métricas.

## Saúde, deploy e operação

- [ ] **Exponha `/health` para liveness.** Verifique processo sem depender de todos
  os serviços externos.
- [ ] **Exponha `/readiness` para prontidão.** Indique se instância pode receber
  tráfego sem revelar detalhes sensíveis.
- [ ] **Implemente graceful shutdown.** Pare novas requisições, finalize as atuais,
  feche conexões e respeite timeout máximo.
- [ ] **Torne builds reproduzíveis.** Fixe dependências, use imagem mínima e
  registre versão ou commit do artefato.
- [ ] **Execute migrations de forma controlada.** Garanta compatibilidade com
  versão anterior durante rollout gradual.
- [ ] **Use estratégia segura de deploy.** Rolling, blue-green ou canary deve
  permitir rollback rápido.
- [ ] **Não dependa de estado local da instância.** Sessões, uploads e jobs que
  precisam sobreviver usam armazenamento apropriado.
- [ ] **Documente runbooks.** Cubra falhas comuns, rollback, rotação de segredo e
  recuperação de dados.

## Testes e qualidade

- [ ] **Teste regras de negócio com unidades rápidas.** Cubra casos válidos,
  limites e falhas.
- [ ] **Teste integração com dependências reais.** Valide banco, cache, fila e
  serialização em ambiente isolado.
- [ ] **Teste o contrato HTTP.** Confira status, headers, schema, autenticação,
  autorização, paginação e erros.
- [ ] **Teste autorização negativa.** Garanta que outro usuário ou tenant não
  acesse recurso alheio.
- [ ] **Teste idempotência e concorrência.** Repita requests e execute disputas
  controladas.
- [ ] **Teste migrations.** Valide upgrade, compatibilidade, rollback possível e
  tempo em volume representativo.
- [ ] **Teste carga nas rotas críticas.** Compare capacidade e latência aos SLOs.
- [ ] **Use análise estática e auditoria de dependências.** Bloqueie vulnerabilidades
  relevantes, segredos e erros de tipagem no CI.
- [ ] **Mantenha testes determinísticos.** Isole relógio, aleatoriedade, rede e
  dados compartilhados.

## Portão antes de publicar

- [ ] Contrato documentado e validado contra implementação.
- [ ] Autenticação, autorização e isolamento por recurso testados.
- [ ] Entradas, uploads, limites e respostas validados.
- [ ] Erros não expõem stack trace, segredo ou dado pessoal.
- [ ] Paginação, filtros, ordenação e rate limit funcionam nos limites.
- [ ] Migrations e rollback ou plano de recuperação revisados.
- [ ] Logs, métricas, traces, dashboards e alertas disponíveis.
- [ ] Testes automatizados, lint, análise estática e auditoria passam no CI.
- [ ] Deploy gradual, health checks e graceful shutdown verificados.
- [ ] Documentação, changelog e comunicação de breaking change atualizados.
