import { testPrisma } from '../helpers/prisma'

interface {{EntityName}}Overrides {
  name?: string
}

export function create{{EntityName}}(
  userId: string,
  overrides: {{EntityName}}Overrides = {}
) {
  return testPrisma.{{entityName}}.create({
    data: {
      name: overrides.name ?? `{{EntityName}} ${crypto.randomUUID()}`,
      userId
    }
  })
}
