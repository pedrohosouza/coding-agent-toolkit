# Busca normalizada

Use quando a busca precisa ignorar acentos, maiúsculas e espaços extras (nomes de pessoas, cidades, empresas). O `mode: 'insensitive'` do Prisma ignora só maiúsculas, não acentos.

## Regras

- Guarde uma coluna derivada `normalized<Field>` (ex.: `normalizedName`) ao lado do campo original.
- Preencha-a em toda escrita (create, update e seed) com `normalizeText()`; nunca aceite esse valor do cliente.
- Nunca exponha a coluna `normalized*` no `<ENTITY>_SELECT`.
- Indexe a coluna com `@@index`.
- `<ENTITY>_SEARCHABLE_FIELDS` aponta para a coluna `normalized*`.
- O service normaliza o termo com `normalizeText()` antes de `paginate()`; termo vazio após normalizar vira `undefined`.
- Ordenação continua usando o campo original (`name`).
- `normalizeText()` fica em `server/utils/normalize-text.ts`, função pura compartilhada com os seeds.

## Função

```ts
export function normalizeText(value: string): string {
  return value
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .trim()
}
```

## Schema

```prisma
model City {
  id             String @id @default(dbgenerated("uuidv7()")) @db.Uuid
  name           String
  normalizedName String

  @@index([normalizedName])
  @@map("cities")
}
```

## Constantes

```ts
export const CITY_SEARCHABLE_FIELDS = ['normalizedName'] as const
```

## Service de listagem

```ts
async execute(userId: string, query: ListCitiesQuery) {
  const { page, perPage, search, sort, order } = query
  const normalizedSearch = search ? normalizeText(search) : undefined

  return this.db.city.paginate(
    { where: { userId }, orderBy: { [sort]: order }, select: CITY_SELECT },
    {
      page,
      perPage,
      search: normalizedSearch || undefined,
      searchFields: CITY_SEARCHABLE_FIELDS
    }
  )
}
```

## Escrita

```ts
data: { ...input, normalizedName: normalizeText(input.name) }
```

No update, recalcule `normalizedName` sempre que `name` mudar.
