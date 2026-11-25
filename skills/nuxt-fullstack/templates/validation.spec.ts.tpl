import { describe, expect, it } from 'vitest'
import {
  create{{EntityName}}Schema,
  list{{EntityNames}}QuerySchema,
  update{{EntityName}}Schema
} from '#shared/schemas/{{entity-name}}.validation'

describe('create{{EntityName}}Schema', () => {
  it('accepts a valid name', () => {
    const result = create{{EntityName}}Schema.safeParse({ name: 'Example' })

    expect(result.success).toBe(true)
  })

  it('trims the name', () => {
    const result = create{{EntityName}}Schema.safeParse({ name: '  Example  ' })

    expect(result.data).toEqual({ name: 'Example' })
  })

  it('rejects a name shorter than 3 characters', () => {
    const result = create{{EntityName}}Schema.safeParse({ name: 'ab' })

    expect(result.error?.issues[0]?.message).toBe('Use ao menos 3 caracteres.')
  })

  it('rejects a name longer than 120 characters', () => {
    const result = create{{EntityName}}Schema.safeParse({ name: 'a'.repeat(121) })

    expect(result.error?.issues[0]?.message).toBe(
      'Use no máximo 120 caracteres.'
    )
  })

  it('rejects unknown fields', () => {
    const result = create{{EntityName}}Schema.safeParse({
      name: 'Example',
      userId: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b01'
    })

    expect(result.success).toBe(false)
  })

  it('accepts a partial update payload', () => {
    const result = update{{EntityName}}Schema.safeParse({})

    expect(result.success).toBe(true)
  })

  it('applies pagination defaults to the list query', () => {
    const result = list{{EntityNames}}QuerySchema.safeParse({})

    expect(result.data).toMatchObject({
      page: 1,
      perPage: 10,
      sort: 'createdAt',
      order: 'desc'
    })
  })

  it('rejects unknown query params', () => {
    const result = list{{EntityNames}}QuerySchema.safeParse({ foo: 'bar' })

    expect(result.success).toBe(false)
  })

  it('rejects a perPage above 100', () => {
    const result = list{{EntityNames}}QuerySchema.safeParse({ perPage: '101' })

    expect(result.success).toBe(false)
  })
})
