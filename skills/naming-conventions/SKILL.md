---
name: naming-conventions
description: Aplica convenções de nomes em inglês para identificadores e arquivos ao escrever, renomear ou revisar código.
---

# Naming Conventions

Todos os identificadores e nomes de arquivos são escritos em inglês. Preserve
convenções da linguagem, framework e projeto quando forem mais específicas.

## Funções

O verbo deve comunicar comportamento e retorno:

| Prefixo | Semântica |
| --- | --- |
| `get` | Retorna um item esperado; ausência é erro. |
| `find` | Retorna um item opcional; ausência é válida. |
| `list` | Retorna zero ou mais itens. |
| `fetch` / `load` | Torna I/O explícito quando essa distinção for útil. |
| `search` / `query` | Busca por critérios dinâmicos ou texto livre. |
| `create` | Cria uma entidade. |
| `add` / `insert` | Adiciona a uma coleção ou estrutura. |
| `update` / `set` | Altera entidade ou atribui valor. |
| `delete` | Apaga permanentemente. |
| `remove` | Retira sem implicar destruição. |

Para transformação e controle:

- `parse` interpreta entrada bruta; `format` produz representação de saída.
- `serialize` e `deserialize` convertem formatos de transporte ou persistência.
- `build` ou `make` constroem valores compostos.
- `validate` reporta violações; `ensure` garante estado ou falha.
- `handle` e `on` identificam tratadores de eventos.
- Evite `process` quando existir verbo mais específico.

Funções com mesmo prefixo devem manter mesma semântica no projeto.

## Booleanos, coleções e quantidades

- Booleanos formam pergunta com `is`, `has`, `can`, `should` ou `will`.
- Prefira nomes positivos, como `isValid`, a negativos, como `isNotValid`.
- Use plural para coleções e singular para um item.
- Use `count`, `total` ou `size` para quantidades e `index` para posições.
- Restrinja `i`, `j` e `k` a laços curtos e locais.

## Casing

| Elemento | Padrão |
| --- | --- |
| Classes, tipos, interfaces e enums | `PascalCase` |
| Variáveis, funções, métodos e parâmetros | `camelCase` |
| Constantes de módulo | `UPPER_SNAKE_CASE` |
| Arquivos | `kebab-case` |

Componentes e classes podem seguir o nome do símbolo quando a stack exigir.

## Assincronismo

Escolha entre sufixo `Async` e ausência de sufixo conforme a linguagem e o
projeto. Nunca misture as convenções no mesmo código-base.

## Evite

- Nomes vagos como `data`, `info`, `item`, `manager`, `helper` e `util` quando o
  domínio permitir nome mais preciso.
- Abreviações não óbvias, números sequenciais e codificação de tipo no nome.
- Argumentos booleanos que selecionam comportamentos; exponha operações com
  nomes distintos.
- Renomear código fora do escopo apenas para impor preferência estética.
