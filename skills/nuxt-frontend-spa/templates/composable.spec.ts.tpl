import { mockNuxtImport, registerEndpoint } from '@nuxt/test-utils/runtime'
import { defineEventHandler, readBody, setResponseStatus } from 'h3'
import { beforeEach, describe, expect, it, vi } from 'vitest'

const toast = vi.hoisted(() => ({ add: vi.fn() }))

mockNuxtImport('useToast', () => () => toast)

const {{entityName}} = {
  id: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77',
  name: 'Example',
  createdAt: '2026-01-01T00:00:00.000Z',
  updatedAt: '2026-01-01T00:00:00.000Z'
}

const pagination = {
  page: 1,
  perPage: 10,
  totalItems: 1,
  totalPages: 1,
  hasNextPage: false,
  hasPreviousPage: false
}

describe('use{{EntityNames}}', () => {
  beforeEach(() => {
    toast.add.mockClear()
  })

  it('loads the {{entity-names}} list', async () => {
    registerEndpoint('/api/{{entity-names}}', {
      method: 'GET',
      handler: () => ({ data: [{{entityName}}], pagination })
    })

    const { items, pagination: loaded } = use{{EntityNames}}()

    await vi.waitFor(() => expect(items.value).toHaveLength(1))
    expect(items.value[0]?.name).toBe('Example')
    expect(loaded.value?.totalItems).toBe(1)
  })

  it('creates a {{entityName}} and shows a success toast', async () => {
    const received = vi.fn()
    registerEndpoint('/api/{{entity-names}}', {
      method: 'GET',
      handler: () => ({ data: [], pagination })
    })
    registerEndpoint('/api/{{entity-names}}', {
      method: 'POST',
      handler: defineEventHandler(async (event) => {
        received(await readBody(event))
        return { data: {{entityName}} }
      })
    })

    const { create } = use{{EntityNames}}()
    const created = await create({ name: 'Example' })

    expect(created).toBe(true)
    expect(received).toHaveBeenCalledWith({ name: 'Example' })
    expect(toast.add).toHaveBeenCalledWith(
      expect.objectContaining({ color: 'success' })
    )
  })

  it('exposes field errors and shows an error toast on validation failure', async () => {
    registerEndpoint('/api/{{entity-names}}', {
      method: 'GET',
      handler: () => ({ data: [], pagination })
    })
    registerEndpoint('/api/{{entity-names}}', {
      method: 'POST',
      handler: defineEventHandler((event) => {
        setResponseStatus(event, 400)
        return {
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Validation failed',
            details: [{ field: 'name', issue: 'name should not be empty' }]
          }
        }
      })
    })

    const { create, validationErrors } = use{{EntityNames}}()
    const created = await create({ name: '' })

    expect(created).toBe(false)
    expect(validationErrors.value).toEqual([
      expect.objectContaining({ name: 'name' })
    ])
    expect(toast.add).toHaveBeenCalledWith(
      expect.objectContaining({ color: 'error' })
    )
  })
})
