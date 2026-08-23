---
name: naming-conventions
description: Convenções de nomenclatura do projeto — prefixos de verbos em funções (get/find/list/fetch/create/update/delete etc.), booleanos, coleções e contadores, casing por tipo, assincronismo e antipadrões a evitar. Use SEMPRE que estiver escrevendo ou renomeando qualquer identificador (variável, função, classe, tipo, arquivo) ou revisando código onde nomes possam ser inconsistentes — mesmo sem pedido explícito. Aplicar por padrão; todo nome é sempre em inglês.
---

# Naming Conventions

> Um bom nome revela a intenção. Se um nome precisa de comentário para ser
> entendido, ele não revela sua intenção. O leitor deve conseguir inferir o que
> algo faz, retorna e como se comporta apenas pelo nome.

Estas regras definem as convenções de nomenclatura adotadas no projeto. Siga-as
por padrão; ao se desviar, deixe explícito o motivo. Todo nome é sempre em inglês.

## Prefixos de verbos em funções

O prefixo comunica o comportamento e a expectativa de retorno. Seja consistente:
funções com o mesmo prefixo devem se comportar de forma equivalente.

### Recuperação de dados

| Prefixo | Quando usar | Retorno |
| --- | --- | --- |
| `get` | Espera-se que o item **exista**. Ausência é um bug. | Um único item. Lança exceção se não encontrar. |
| `find` | O item **pode ou não existir**. Ausência é resultado válido. | `null` / `Optional` / vazio. Nunca lança por ausência. |
| `list` | Retorna uma coleção (0 ou mais itens), com filtros/paginação. | Coleção. Vazia quando não há resultados. |
| `fetch` / `load` | Há **I/O explícito** (rede, disco, banco). | Item ou coleção, conforme o caso. |
| `search` / `query` | Busca com critérios dinâmicos, texto livre ou múltiplos filtros. | Coleção, geralmente ordenada/paginada. |

Regra prática:

- Espera existir 1 → `get`
- Pode existir 1 ou nenhum → `find`
- Retorna vários → `list`

```
getUserById(id)          // erro se não existir → é bug
findUserByEmail(email)   // pode retornar null → esperado
listActiveUsers()        // coleção, 0 ou mais
fetchUserProfile(id)     // deixa claro que há chamada de rede
```

### Criação, alteração e remoção

| Prefixo | Quando usar |
| --- | --- |
| `create` | Cria uma nova entidade do zero. |
| `add` / `insert` | Adiciona um item a uma coleção/estrutura existente. |
| `update` | Altera uma entidade existente. |
| `set` | Atribui um valor a uma propriedade/campo. |
| `delete` | Apaga **permanentemente** (ex.: registro no banco). |
| `remove` | Retira de uma coleção, sem necessariamente destruir. |

Distinguir `delete` de `remove` evita ambiguidade sobre o efeito real da operação.

### Transformação e construção

| Prefixo | Quando usar |
| --- | --- |
| `build` / `make` | Constrói um objeto composto, possivelmente em etapas. |
| `parse` | Interpreta um formato bruto (string, buffer) em estrutura. |
| `format` | Converte estrutura em representação de saída (ex.: texto). |
| `serialize` / `deserialize` | Converte de/para formato de transporte/persistência. |
| `to<Tipo>` | Conversão para outro tipo (`toDTO`, `toJSON`, `toString`). |
| `map` / `transform` | Transforma uma coleção/valor em outra forma. |

### Validação e efeitos

| Prefixo | Quando usar |
| --- | --- |
| `validate` | Verifica regras e reporta erros (retorna resultado ou lança). |
| `ensure` | Garante um estado; corrige ou lança se não for possível. |
| `check` | Verificação simples, geralmente booleana. |
| `handle` / `on` | Tratadores de evento (`onClick`, `handleSubmit`). |
| `process` | Executa um fluxo de processamento sobre uma entrada. |

## Booleanos

1. Use prefixos que formem uma pergunta de sim/não: `is`, `has`, `can`,
   `should`, `will`.
2. Não use condicionais negativas no nome. Prefira `isValid` a `isNotValid`.

```
isActive        hasPermission
canEdit         shouldRetry
```

## Coleções e contadores

1. Use **plural** para arrays/listas e **singular** para itens únicos.
2. Use `count` / `total` / `size` para quantidades.
3. Use `index` para posições; `i`, `j`, `k` apenas em laços curtos e locais.

```
users            // coleção
user             // item único
activeOrders     // coleção filtrada
orderCount       // quantidade
```

## Casing por tipo

| Elemento | Padrão |
| --- | --- |
| Classes, tipos, interfaces, enums | `PascalCase` |
| Variáveis, funções, métodos, parâmetros | `camelCase` |
| Constantes de módulo / valores fixos | `UPPER_SNAKE_CASE` |
| Arquivos | `kebab-case` (componentes/classes podem seguir o nome do símbolo) |

Defina **um** padrão de arquivo por tipo de artefato e mantenha-o em todo o
projeto.

## Assincronismo

1. Escolha **uma** convenção para funções assíncronas e aplique em todo o projeto
   (sufixo `Async`, ou nenhum sufixo confiando no tipo de retorno).
2. Nunca misture as duas abordagens no mesmo código-base.

## Antipadrões a evitar

1. **Nomes genéricos e vagos.** `data`, `info`, `item`, `manager`, `helper`,
   `util`, `handler` — só use quando o escopo realmente for esse; caso contrário,
   seja específico.
2. **Abreviações não óbvias.** Prefira `message` a `msg`, `request` a `req`,
   salvo convenções universais do domínio.
3. **Números sequenciais.** `user1`, `user2` indicam que faltou uma estrutura
   (lista, objeto). Faça distinções significativas.
4. **Codificação de tipo no nome.** Não use notação húngara nem prefixos de tipo
   (`strName`, `iCount`). O tipo é responsabilidade da linguagem, não do nome.
5. **Argumentos de flag booleanos.** Divida em métodos independentes em vez de
   `render(true)`. O nome de cada método deve revelar o comportamento diretamente.

## Consistência

O ponto central: **se você nomeia algo de uma forma, nomeie todas as coisas
semelhantes da mesma forma.** Um `find` que às vezes lança exceção e outras
retorna `null` é pior do que qualquer escolha de prefixo — a previsibilidade é o
que torna os nomes úteis.