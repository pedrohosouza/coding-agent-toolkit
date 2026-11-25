import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { normalizeText } from '../../server/utils/normalize-text'
import type { Seed } from './types/seed.type'

interface {{EntityName}}SeedRecord {
  name: string
}

const {{ENTITY_NAME}}_DATA_PATH = join(
  import.meta.dirname,
  'data',
  '{{entity-names}}.json'
)

function read{{EntityNames}}(): {{EntityName}}SeedRecord[] {
  return JSON.parse(
    readFileSync({{ENTITY_NAME}}_DATA_PATH, 'utf-8')
  ) as {{EntityName}}SeedRecord[]
}

export const seed{{EntityNames}}: Seed = async (prisma) => {
  const data = read{{EntityNames}}().map(({{entityName}}) => ({
    ...{{entityName}},
    normalizedName: normalizeText({{entityName}}.name)
  }))

  const { count } = await prisma.{{entityName}}.createMany({
    data,
    skipDuplicates: true
  })

  console.log(`{{entity-names}}: ${count} inserted, ${data.length - count} skipped`)
}
