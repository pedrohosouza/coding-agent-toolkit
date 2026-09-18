# Checklist de Boas Práticas para Frontend

Use esta lista na criação, revisão e publicação de interfaces. Adapte ferramentas
à stack, mas preserve contratos, acessibilidade, segurança e experiência.

## Arquitetura e organização

- [ ] **Organize código por domínio ou funcionalidade.** Mantenha componente,
  teste, estilo e lógica relacionada próximos quando isso facilitar manutenção.
- [ ] **Separe responsabilidades.** Componentes visuais não devem concentrar
  acesso à API, regra de negócio, navegação e transformação complexa.
- [ ] **Prefira composição.** Combine componentes pequenos em vez de criar um
  componente com muitas props condicionais.
- [ ] **Extraia abstrações após repetição real.** Não crie camada genérica sem
  casos concretos que provem seu contrato.
- [ ] **Defina limites de dependência.** Domínio não deve depender de detalhes de
  framework, transporte ou componente visual.
- [ ] **Evite imports circulares.** Exponha APIs públicas claras por módulo e
  mantenha fluxo de dependência previsível.
- [ ] **Centralize constantes e convenções compartilhadas.** Evite valores
  mágicos espalhados pela interface.
- [ ] **Remova código morto.** Não deixe componentes, flags, estilos e dependências
  sem uso.

## Componentes reutilizáveis

- [ ] **Crie componentes desacoplados e componíveis.** Cada componente deve ter
  responsabilidade clara e API pequena.
- [ ] **Tipifique todas as props.** Evite `any` e represente estados impossíveis
  com unions discriminadas quando adequado.
- [ ] **Defina defaults seguros.** Props opcionais devem produzir comportamento
  previsível.
- [ ] **Controle variantes com contrato explícito.** Use nomes semânticos como
  `primary`, `danger` e `compact`, não detalhes visuais arbitrários.
- [ ] **Permita extensão sem quebrar acessibilidade.** Preserve `className`, refs,
  atributos HTML e eventos quando fizer sentido.
- [ ] **Documente componentes compartilhados.** Use Storybook ou equivalente com
  variantes, estados e exemplos.
- [ ] **Não replique componentes do design system.** Evolua a fonte comum antes
  de criar cópia local.
- [ ] **Mantenha componentes determinísticos.** Mesmas props e estado devem gerar
  a mesma interface, sem efeito colateral durante renderização.

## TypeScript e contratos

- [ ] **Ative TypeScript em `strict mode`.** Não enfraqueça regras globalmente para
  resolver erro local.
- [ ] **Gere tipos a partir da API.** Use OpenAPI, GraphQL codegen, tRPC ou contrato
  equivalente em vez de duplicar tipos manualmente.
- [ ] **Mantenha tipagem ponta a ponta.** Preserve tipos desde request e response
  até estado e componente.
- [ ] **Valide dados externos em runtime.** Use schema para API, storage, query
  string, eventos e conteúdo de terceiros.
- [ ] **Não use assertion para esconder incerteza.** Faça narrowing e trate valor
  ausente ou inválido.
- [ ] **Modele domínio, não só payload.** Converta DTOs quando formato da API não
  representa diretamente a necessidade da interface.
- [ ] **Trate datas, moeda e números explicitamente.** Não dependa de parsing ou
  timezone implícito do navegador.

## Estado

- [ ] **Separe estado do servidor e estado do cliente.** Cache remoto não deve ser
  duplicado em store global.
- [ ] **Use biblioteca própria para estado do servidor.** Configure cache,
  stale time, invalidação e deduplicação com TanStack Query, SWR ou equivalente.
- [ ] **Use estado local por padrão.** Eleve ou globalize somente quando múltiplas
  áreas realmente compartilharem o dado.
- [ ] **Mantenha uma única fonte de verdade.** Derive valores calculáveis em vez
  de sincronizar cópias.
- [ ] **Não armazene estado derivado em effects.** Calcule durante renderização ou
  memorize apenas quando houver custo comprovado.
- [ ] **Use máquina de estados para fluxos complexos.** Torne transições e estados
  inválidos explícitos.
- [ ] **Persista apenas o necessário.** Versione dados de storage e remova dados
  antigos ou sensíveis.
- [ ] **Sincronize estado relevante com URL.** Filtros, página, ordenação e busca
  compartilhável devem sobreviver ao refresh e ao botão voltar.

## Comunicação com API

- [ ] **Centralize o cliente HTTP.** Configure base URL, autenticação, serialização,
  timeout e erro em um ponto previsível.
- [ ] **Não espalhe detalhes de transporte pela UI.** Hooks ou serviços expõem
  operações de domínio aos componentes.
- [ ] **Mapeie erros de forma consistente.** Diferencie validação, autenticação,
  autorização, indisponibilidade, conflito e falha inesperada.
- [ ] **Cancele requests obsoletos.** Use `AbortController` ou recurso equivalente
  em busca, troca de rota e desmontagem.
- [ ] **Evite race conditions.** Garanta que resposta antiga não sobrescreva dado
  mais recente.
- [ ] **Use retry somente em falhas transitórias.** Aplique backoff e jitter; não
  repita erro de validação ou operação não idempotente.
- [ ] **Respeite `Retry-After`.** Mostre feedback quando rate limit impedir nova
  tentativa imediata.
- [ ] **Trate paginação corretamente.** Preserve cursor, ordem e filtros entre
  carregamentos.
- [ ] **Faça optimistic update apenas quando reversão for segura.** Restaure estado
  e informe falha ao usuário.
- [ ] **Não faça double-submit.** Desabilite ação enquanto request equivalente
  estiver em andamento e use idempotência quando necessário.
- [ ] **Regenere contratos no CI.** Detecte divergência entre schema publicado e
  cliente gerado.

## Estados de interface

- [ ] **Implemente loading, empty, error e success.** Toda área assíncrona precisa
  representar os quatro estados.
- [ ] **Prefira skeleton estável.** Preserve dimensões do conteúdo e evite layout
  shift; use spinner em ações pequenas ou indeterminadas.
- [ ] **Diferencie primeira carga e atualização.** Não esconda dado útil durante
  refetch em segundo plano.
- [ ] **Crie estado vazio útil.** Explique contexto e ofereça próxima ação quando
  houver.
- [ ] **Mostre erro próximo da causa.** Inclua orientação e opção de tentar
  novamente quando seguro.
- [ ] **Preserve trabalho do usuário após erro.** Não limpe formulário ou edição
  quando request falhar.
- [ ] **Dê feedback imediato.** Botões, toasts e mensagens devem confirmar início,
  sucesso ou falha sem duplicar informação.
- [ ] **Use error boundaries.** Isole falhas inesperadas e ofereça recuperação sem
  derrubar toda a aplicação.
- [ ] **Crie páginas 404, 403 e 500.** Mantenha layout, linguagem e caminho claro
  de volta.

## Formulários

- [ ] **Associe cada campo a um label visível.** Placeholder não substitui label.
- [ ] **Use tipo e atributos nativos corretos.** Configure `type`, `name`,
  `autocomplete`, `inputmode`, `required` e limites.
- [ ] **Valide no cliente e no servidor.** Validação no cliente melhora experiência,
  mas nunca substitui segurança da API.
- [ ] **Use mesma regra do contrato sempre que possível.** Compartilhe ou gere
  schema para reduzir divergência.
- [ ] **Mostre erro específico por campo.** Explique como corrigir e associe a
  mensagem com `aria-describedby`.
- [ ] **Mostre resumo de erros quando necessário.** Leve foco ao resumo em
  formulários longos ou após submissão inválida.
- [ ] **Não valide agressivamente durante digitação.** Escolha momento que ajude
  sem interromper entrada válida ainda incompleta.
- [ ] **Preserve valor digitado.** Erros de validação ou servidor não apagam
  campos.
- [ ] **Marque campos obrigatórios claramente.** Não dependa apenas de cor ou
  asterisco sem explicação.
- [ ] **Formate sem corromper valor.** Máscaras devem aceitar colar, apagar,
  selecionar e usar tecnologias assistivas.
- [ ] **Confirme ações destrutivas.** Informe consequência e identifique o alvo;
  prefira desfazer quando possível.
- [ ] **Proteja contra envio repetido.** Mostre estado de progresso e mantenha texto
  do botão compreensível.

## HTML semântico

- [ ] **Use elementos nativos antes de ARIA.** Prefira `button`, `a`, `input`,
  `dialog` e outros elementos com comportamento pronto.
- [ ] **Estruture landmarks.** Use `header`, `nav`, `main`, `aside` e `footer`
  conforme o conteúdo.
- [ ] **Mantenha hierarquia de headings.** Use um propósito claro para `h1` a `h6`
  sem escolher nível pelo tamanho visual.
- [ ] **Use listas e tabelas para dados correspondentes.** Não simule estrutura
  semântica apenas com `div`.
- [ ] **Diferencie botão e link.** Botão executa ação; link navega para endereço.
- [ ] **Defina idioma da página.** Configure `lang` corretamente e marque trechos
  em outro idioma quando necessário.
- [ ] **Use ARIA somente para completar semântica.** Não substitua elemento nativo
  funcional por role manual.

## Acessibilidade

- [ ] **Atenda WCAG 2.2 nível AA.** Use o padrão como requisito verificável, não
  como revisão opcional no fim.
- [ ] **Garanta operação por teclado.** Toda ação deve funcionar sem mouse e sem
  keyboard trap.
- [ ] **Mostre foco visível.** Não remova outline sem alternativa de contraste e
  posição equivalentes.
- [ ] **Mantenha ordem de foco lógica.** DOM acompanha leitura visual; evite
  `tabindex` positivo.
- [ ] **Gerencie foco em mudanças de contexto.** Modais, menus, erros e navegação
  precisam mover e restaurar foco corretamente.
- [ ] **Garanta contraste suficiente.** Valide texto, ícones, bordas, foco e todos
  os estados interativos.
- [ ] **Não dependa apenas de cor.** Combine cor com texto, ícone, padrão ou forma.
- [ ] **Forneça nome acessível.** Botões de ícone, inputs e controles precisam de
  rótulo programático claro.
- [ ] **Escreva texto alternativo adequado.** Descreva imagem informativa e use
  `alt=""` em imagem decorativa.
- [ ] **Ofereça legenda e transcrição.** Vídeo e áudio devem ter alternativas
  sincronizadas ou textuais conforme o conteúdo.
- [ ] **Anuncie mudanças assíncronas com cuidado.** Use live regions para feedback
  importante sem gerar ruído.
- [ ] **Respeite preferências do sistema.** Trate `prefers-reduced-motion`, aumento
  de texto, contraste e modo de cor.
- [ ] **Mantenha alvo de toque adequado.** Controles devem ter área confortável e
  espaçamento que evite acionamento acidental.
- [ ] **Teste com tecnologia assistiva.** Combine ferramentas automáticas, teclado
  e leitor de tela.

## Responsividade e layout

- [ ] **Projete mobile-first.** Comece pela restrição menor e amplie de forma
  progressiva.
- [ ] **Use breakpoints do design system.** Escolha pontos pela necessidade do
  conteúdo, não por aparelhos específicos.
- [ ] **Prefira unidades relativas.** Use `rem`, `em`, `%`, `fr`, `minmax()` e
  `clamp()` quando adequados.
- [ ] **Evite largura e altura rígidas sem motivo.** Conteúdo traduzido, zoom e
  texto grande precisam caber.
- [ ] **Não gere scroll horizontal acidental.** Teste tabelas, código, gráficos,
  menus e textos longos.
- [ ] **Use container queries quando o componente depender do espaço local.** Não
  vincule toda adaptação apenas ao viewport.
- [ ] **Teste orientação, zoom e teclado virtual.** Garanta acesso aos controles e
  conteúdo em cenários móveis reais.
- [ ] **Respeite safe areas.** Considere recortes e barras do sistema em layouts
  de tela cheia.

## Design system e tema

- [ ] **Derive estilos de design tokens.** Centralize cor, tipografia, espaçamento,
  radius, borda, sombra, motion e z-index.
- [ ] **Use tokens semânticos.** Prefira `color-text-danger` a nomes presos a uma
  cor como `red-500` no uso do componente.
- [ ] **Mantenha escala consistente.** Evite valores únicos sem justificativa.
- [ ] **Cubra todos os estados.** Defina default, hover, focus, active, disabled,
  selected, loading e error.
- [ ] **Suporte dark mode e temas por tokens.** Não duplique componentes nem use
  inversão automática de cores.
- [ ] **Evite z-index arbitrário.** Defina camadas conhecidas para conteúdo,
  menus, overlays, modais e notificações.
- [ ] **Documente decisões visuais.** Componentes e padrões compartilhados devem
  indicar uso correto e limitações.

## Imagens, vídeo e assets

- [ ] **Escolha formato adequado.** Use AVIF/WebP para fotos, SVG para vetores e
  formatos compatíveis com fallback quando necessário.
- [ ] **Dimensione imagem para o espaço exibido.** Use `srcset` e `sizes` para não
  baixar pixels inúteis.
- [ ] **Defina largura e altura.** Reserve espaço e reduza Cumulative Layout Shift.
- [ ] **Use lazy loading fora da primeira tela.** Não atrase Largest Contentful
  Paint do conteúdo principal.
- [ ] **Priorize somente mídia crítica.** Preload e fetch priority em excesso
  competem com recursos essenciais.
- [ ] **Comprima assets.** Automatize otimização sem perda perceptível relevante.
- [ ] **Forneça poster para vídeo.** Evite download ou quadro vazio antes da ação
  do usuário.
- [ ] **Não reproduza áudio automaticamente.** Dê controle claro de play, pause,
  volume e legenda.
- [ ] **Use CDN e cache com hash de conteúdo.** Assets imutáveis recebem validade
  longa e nome versionado.

## Desempenho

- [ ] **Defina orçamento de desempenho.** Limite JavaScript, CSS, imagens, fontes,
  requests e métricas de usuário.
- [ ] **Monitore Core Web Vitals reais.** Acompanhe LCP, INP e CLS por rota,
  dispositivo e percentil relevante.
- [ ] **Reduza JavaScript enviado.** Remova dependências desnecessárias, importe
  módulos específicos e use tree shaking.
- [ ] **Divida código por rota e funcionalidade.** Carregue recursos pesados apenas
  quando necessários.
- [ ] **Não aplique memoização por hábito.** Use profiling para justificar
  `memo`, `useMemo` ou equivalente.
- [ ] **Virtualize listas grandes.** Preserve navegação por teclado e leitura
  acessível ao otimizar renderização.
- [ ] **Evite layout thrashing.** Agrupe leituras e escritas no DOM e prefira
  animações de `transform` e `opacity`.
- [ ] **Otimize fontes.** Reduza famílias e pesos, faça subset, use preload com
  moderação e configure `font-display`.
- [ ] **Evite bloqueio da thread principal.** Divida tarefas longas e mova cálculo
  pesado para worker quando necessário.
- [ ] **Use SSR, SSG ou streaming conforme objetivo.** Considere SEO, personalização,
  cache e custo operacional.
- [ ] **Meça regressões no CI e em produção.** Dados reais têm prioridade sobre
  percepção local.

## Segurança e privacidade

- [ ] **Trate toda entrada como não confiável.** Escape conteúdo e sanitize HTML
  somente quando renderização rica for necessária.
- [ ] **Nunca injete HTML sem política explícita.** Evite `innerHTML` e equivalentes;
  use sanitizador mantido quando inevitável.
- [ ] **Não guarde token sensível em storage acessível por JavaScript.** Prefira
  cookie `HttpOnly`, `Secure` e `SameSite` quando arquitetura permitir.
- [ ] **Proteja requests autenticados por cookie contra CSRF.** Use token, origem,
  SameSite e validação no servidor conforme risco.
- [ ] **Configure Content Security Policy.** Restrinja scripts, estilos, frames,
  conexões e outros recursos às origens necessárias.
- [ ] **Valide URLs externas.** Bloqueie esquemas perigosos e use `rel="noopener noreferrer"`
  quando contexto exigir.
- [ ] **Não exponha segredo no bundle.** Variável enviada ao navegador é pública,
  mesmo quando nome começa com `SECRET`.
- [ ] **Minimize scripts de terceiros.** Revise necessidade, permissão, impacto,
  política de privacidade e falha.
- [ ] **Não envie PII para analytics sem base e consentimento adequados.** Masque
  campos e respeite preferências do usuário.
- [ ] **Mantenha dependências seguras.** Fixe versões, audite vulnerabilidades e
  remova pacotes abandonados ou sem uso.

## SEO e compartilhamento

- [ ] **Defina título e descrição por página pública.** Mantenha conteúdo único e
  coerente com a página.
- [ ] **Use URL canônica.** Evite indexação duplicada por filtros, parâmetros ou
  versões equivalentes.
- [ ] **Controle indexação.** Configure robots e meta directives sem bloquear
  acidentalmente páginas importantes.
- [ ] **Gere sitemap para conteúdo indexável.** Atualize quando rotas públicas
  mudarem.
- [ ] **Adicione metadados de compartilhamento.** Configure Open Graph e cards
  sociais com imagem dimensionada.
- [ ] **Use dados estruturados válidos quando aplicável.** O markup deve refletir
  conteúdo visível e seguir schema suportado.
- [ ] **Garanta conteúdo principal acessível sem interação desnecessária.** Bots,
  leitores e links diretos devem alcançar a informação.
- [ ] **Trate redirects e status no servidor.** Página inexistente deve responder
  `404`, não apenas renderizar mensagem com `200`.

## Internacionalização

- [ ] **Não espalhe texto de interface no código.** Use catálogo de mensagens com
  chaves estáveis.
- [ ] **Formate data, número e moeda por locale.** Use APIs de internacionalização,
  não concatenação manual.
- [ ] **Suporte plural e gênero conforme idioma.** Não monte frases com fragmentos
  que tradutor não consiga reorganizar.
- [ ] **Permita expansão de texto.** Layout não deve quebrar com tradução maior.
- [ ] **Considere escrita RTL.** Use propriedades CSS lógicas e teste direção
  quando idiomas suportados exigirem.
- [ ] **Defina fallback de tradução.** Ausência de chave deve ser observável e não
  exibir identificador interno em produção.

## Observabilidade e analytics

- [ ] **Capture erros inesperados.** Inclua release, rota, navegador e contexto
  técnico sem registrar dados sensíveis.
- [ ] **Use source maps protegidos.** Permita diagnóstico sem publicar fonte quando
  política do projeto não permitir.
- [ ] **Meça desempenho real.** Envie Web Vitals e tempos de operações críticas.
- [ ] **Defina eventos com contrato.** Nome, propriedades, momento e finalidade
  devem ser consistentes e versionados.
- [ ] **Evite eventos duplicados.** Navegação, rerender e retry não devem inflar
  conversões.
- [ ] **Respeite consentimento.** Só inicialize ferramentas opcionais após escolha
  válida do usuário.
- [ ] **Inclua contexto de correlação.** Propague request ID para facilitar ligação
  entre erro no navegador e API.

## Testes

- [ ] **Teste comportamento, não implementação.** Interaja como usuário e evite
  assertions sobre detalhes internos frágeis.
- [ ] **Cubra componentes puros com testes unitários.** Priorize regras, formatos e
  variações relevantes.
- [ ] **Teste integração de fluxos.** Valide formulário, cache, roteamento, erros e
  comunicação entre componentes.
- [ ] **Teste jornadas críticas ponta a ponta.** Inclua login, cadastro, compra ou
  ação principal do produto.
- [ ] **Teste acessibilidade automaticamente e manualmente.** Use axe ou equivalente,
  teclado e leitor de tela.
- [ ] **Teste responsividade.** Cubra viewports pequenos, grandes, zoom e conteúdo
  extremo.
- [ ] **Faça teste visual dos componentes críticos.** Detecte mudança não planejada
  em layout e tema.
- [ ] **Teste falhas e lentidão da API.** Verifique timeout, offline, retry, estado
  vazio e erro parcial.
- [ ] **Evite snapshots grandes.** Prefira assertions focadas no comportamento e
  saída importante.
- [ ] **Mantenha testes determinísticos.** Controle relógio, rede, locale, timezone
  e dados.

## Compatibilidade e entrega

- [ ] **Defina navegadores suportados.** Use dados de público e necessidade do
  produto, não suposição.
- [ ] **Use progressive enhancement.** Funcionalidade essencial deve continuar
  disponível quando recurso avançado falhar ou não existir.
- [ ] **Transpile e adicione polyfills conscientemente.** Não aumente todo bundle
  por navegador fora do suporte.
- [ ] **Fixe dependências e builds.** O mesmo commit deve gerar artefato equivalente.
- [ ] **Use feature flags com ciclo de vida.** Tenha responsável, valor padrão,
  métricas e data para remoção.
- [ ] **Separe configuração por ambiente.** Valide variáveis no build ou startup e
  nunca inclua segredo.
- [ ] **Publique assets com hash.** Permita cache longo e rollback sem colisão.
- [ ] **Tenha rollback seguro.** Frontend e API devem continuar compatíveis durante
  deploy gradual.

## Portão antes de publicar

- [ ] Loading, empty, error e success revisados em todos os fluxos assíncronos.
- [ ] Navegação por teclado, foco, contraste e leitor de tela verificados.
- [ ] Layout testado em mobile, desktop, zoom e conteúdo longo.
- [ ] Formulários preservam dados, explicam erros e evitam double-submit.
- [ ] Contrato gerado, validação runtime e tratamento de erros atualizados.
- [ ] Nenhum segredo, PII ou HTML inseguro aparece no bundle, log ou analytics.
- [ ] Core Web Vitals e orçamento de bundle permanecem dentro da meta.
- [ ] Testes unitários, integração, ponta a ponta, lint e typecheck passam no CI.
- [ ] 404, 403, 500, offline e indisponibilidade têm recuperação clara.
- [ ] Documentação, changelog, feature flags e plano de rollback atualizados.
