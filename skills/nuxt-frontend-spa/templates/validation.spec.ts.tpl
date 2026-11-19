import { describe, expect, it } from 'vitest'
import { {{entityName}}Schema } from '~/schemas/{{entity-name}}.validation'

describe('{{entityName}}Schema', () => {
  it('accepts a valid name', () => {
    const result = {{entityName}}Schema.safeParse({ name: 'Example' })

    expect(result.success).toBe(true)
  })

  it('trims the name', () => {
    const result = {{entityName}}Schema.safeParse({ name: '  Example  ' })

    expect(result.data).toEqual({ name: 'Example' })
  })

  it('rejects a name shorter than 3 characters', () => {
    const result = {{entityName}}Schema.safeParse({ name: 'ab' })

    expect(result.error?.issues[0]?.message).toBe('Use ao menos 3 caracteres.')
  })

  it('rejects a name longer than 120 characters', () => {
    const result = {{entityName}}Schema.safeParse({ name: 'a'.repeat(121) })

    expect(result.error?.issues[0]?.message).toBe(
      'Use no máximo 120 caracteres.'
    )
  })
})
