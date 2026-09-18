---
name: frontend-standards
description: Padrões obrigatórios para interfaces. Use SEMPRE em componentes, páginas, formulários,
layouts, estilos, chamadas à API ou estados de UI. Cobre reuso, tipagem, responsividade,
acessibilidade, mídia, erros e temas.
---

# Boas Práticas de Frontend

Padrões a seguir ao construir ou modificar a interface. São convenções do
projeto, não sugestões — aplicar por padrão. Quando uma regra não couber em um
caso específico, **registrar a exceção** (comentário/PR) em vez de ignorá-la
silenciosamente.

## Componentes reutilizáveis

- Componentes desacoplados e componíveis; preferir composição a props de
  configuração excessivas.
- Todas as props tipadas e com valores default sensatos.
- Componentes compartilhados documentados (Storybook ou equivalente).

## Contratos tipados

- TypeScript em **strict mode**.
- Tipos **gerados a partir da API** (OpenAPI / GraphQL codegen / tRPC) — não
  escrever à mão.
- Tipagem end-to-end: request → response → UI.
- Validação de schema em runtime nas bordas (Zod / Yup).

## Gerenciamento de estado

- Separar **estado servidor** de **estado cliente**.
- Lib de estado servidor (TanStack Query / SWR) com cache e invalidação
  explícitos.
- Lib de estado cliente (Zustand / Redux / Context) só para estado genuinamente
  do cliente.
- Uma única fonte de verdade — nunca duplicar estado.

## Semântica HTML

- Tags semânticas corretas (`header`, `nav`, `main`, `section`, `article`,
  `footer`).
- Hierarquia de headings coerente (`h1` → `h6`).
- Landmarks e roles quando necessário.
- Semântica como base de acessibilidade (foco, teclado, contraste).

## Responsividade

- **Mobile-first.**
- Breakpoints consistentes derivados de design tokens.
- Unidades relativas (`rem`/`em`/`%`, `clamp`) em vez de pixels fixos.
- Verificar em múltiplos viewports/dispositivos.

## Formulários

- Validação com feedback claro e imediato.
- Máscaras e formatação de inputs onde relevante.
- Estados de erro por campo, mais erro geral quando necessário.

## Página 404 personalizada

- Layout consistente com o resto da aplicação.
- Caminho claro de volta (home / navegação).
- Tratar também outras rotas de erro (500, 403).

## Otimização de imagens/vídeos/assets

- Formatos modernos (WebP / AVIF, vídeo comprimido).
- Lazy loading de mídia.
- Imagens dimensionadas corretamente e responsivas (`srcset`).
- Compressão e minificação de assets.
- Prevenir layout shift definindo dimensões.

## Estados de UI

- Sempre tratar os quatro: **loading, empty, error, success**.
- Skeletons no lugar de spinners.
- Optimistic updates onde fizer sentido.
- Feedback de ações (toasts, botões disabled/loading).
- Prevenção de double-submit.

## Comunicação com API

- Cliente HTTP centralizado.
- Interceptors para auth, retry e tratamento de erro.
- Mapear erros da API de forma consistente para estados no front.
- Tratar paginação e rate limiting.
- Retry com backoff, respeitando `Retry-After`.

## Tema e design

- Tudo derivado de design tokens (cor, espaçamento, tipografia).
- Suporte a dark mode / temas.
- Consistência visual através do design system.