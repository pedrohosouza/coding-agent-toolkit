# Skills, Plugins e Ferramentas para Agentes de Código

Este documento centraliza **skills, plugins, marketplaces e utilitários** utilizados nos agentes de desenvolvimento, principalmente **OpenAI Codex** e **Claude Code**.

---

# 1. Skills

## Context7

**Finalidade:** fornecer documentação atualizada de bibliotecas, frameworks e APIs diretamente aos agentes de código.

Principais recursos:

* Busca de documentação atualizada
* Redução de respostas baseadas em APIs antigas
* Consulta de exemplos de código
* Resolução automática de bibliotecas
* Integração via MCP
* Skill automática para consultas de documentação

### Codex

Adicionar o marketplace:

```bash
codex plugin marketplace add upstash/context7
```

Instalar o plugin:

```bash
codex plugin add context7@context7-marketplace
```

### Claude Code

```bash
claude plugin marketplace add upstash/context7
claude plugin install context7@context7-marketplace
```

---

## Grill Me

**Finalidade:** fazer o agente questionar uma implementação, arquitetura ou decisão técnica de forma mais crítica.

Instalação:

```bash
npx skills add https://github.com/mattpocock/skills --skill grill-me
```

Uso recomendado:

* Revisão de arquitetura
* Validação de decisões técnicas
* Questionamento de requisitos
* Identificação de pontos não considerados
* Code review mais crítico

---

## Caveman

**Finalidade:** simplificar explicações técnicas e incentivar soluções menos complexas.

Instalação:

```bash
npx skills add https://github.com/juliusbrussee/caveman --skill caveman
```

Uso recomendado:

* Redução de complexidade
* Refatoração
* Arquitetura simples
* Evitar overengineering
* Explicar soluções técnicas de forma objetiva

---

## Playwright CLI

**Finalidade:** permitir automação e testes utilizando navegador.

Instalação:

```bash
npx skills add https://github.com/microsoft/playwright-cli --skill playwright-cli
```

Uso recomendado:

* Testes E2E
* Validação de interfaces
* Navegação automática
* Testes de formulários
* Captura de screenshots
* Debug de aplicações web

---

## Humanizer

**Finalidade:** melhorar textos produzidos por agentes, evitando respostas excessivamente artificiais ou com aparência típica de IA.

Instalação global:

```bash
npx skills add blader/humanizer --global
```

Uso recomendado:

* Documentação
* README
* Pull Requests
* Issues
* Mensagens para usuários
* Textos de interface
* Comunicação técnica

---

# 2. Marketplaces de Skills

## Marketing Skills

Repositório:

```text
https://github.com/coreyhaines31/marketingskills
```

**Finalidade:** conjunto de skills voltadas para:

* Marketing
* CRO
* Copywriting
* SEO
* Analytics
* Growth Engineering

Compatibilidade declarada principalmente com:

* Claude Code
* Agentes de IA compatíveis com Skills

Para instalação, consultar o README do projeto.

---

## Taste Skill

Repositório:

```text
https://github.com/Leonxlnx/taste-skill
```

**Finalidade:** melhorar o senso visual do agente e evitar interfaces genéricas ou com aparência excessivamente produzida por IA.

Uso recomendado:

* Frontend
* UI/UX
* Redesign
* Landing pages
* Dashboards
* Direção visual
* Revisão estética de interfaces

Consultar o README para selecionar e instalar as skills desejadas.

---

## UI UX Pro Max Skill

Repositório:

```text
https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
```

**Finalidade:** adicionar conhecimento especializado em design e construção de interfaces.

Áreas principais:

* UI/UX
* Design Systems
* Acessibilidade
* Componentes
* Responsividade
* Layout
* Tipografia
* Cores
* Experiência do usuário
* Implementação frontend

Consultar o README para instruções específicas de instalação.

---

# 3. Utils

## MarkItDown

Repositório:

```text
https://github.com/microsoft/markitdown
```

**Finalidade:** converter diferentes tipos de arquivos para Markdown.

Pode trabalhar com formatos como:

* PDF
* Word
* PowerPoint
* Excel
* HTML
* CSV
* Imagens
* Arquivos diversos

Útil para preparar conteúdo antes de enviá-lo para agentes de IA.

---

