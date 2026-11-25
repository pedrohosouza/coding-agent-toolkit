import { beforeEach, describe, expect, it, vi } from 'vitest'
import { z } from 'zod'
import {
  validateBody,
  validateParams,
  validateQuery
} from '~~/server/utils/validation'

const getQuery = vi.fn()
const getRouterParams = vi.fn()
const readBody = vi.fn()

vi.stubGlobal('getQuery', getQuery)
vi.stubGlobal('getRouterParams', getRouterParams)
vi.stubGlobal('readBody', readBody)
vi.stubGlobal('createError', (input: Record<string, unknown>) =>
  Object.assign(new Error(String(input.message)), input)
)

const event = {} as never
const schema = z.strictObject({ id: z.uuid() })

describe('validation util', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('returns the parsed query', () => {
    getQuery.mockReturnValue({ id: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b01' })

    expect(validateQuery(event, schema)).toEqual({
      id: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b01'
    })
  })

  it('throws a 400 with field details for an invalid param', () => {
    getRouterParams.mockReturnValue({ id: 'not-a-uuid' })

    expect(() => validateParams(event, schema)).toThrowError(
      expect.objectContaining({
        statusCode: 400,
        data: { details: [{ field: 'id', issue: expect.any(String) }] }
      })
    )
  })

  it('rejects unknown body fields', async () => {
    readBody.mockResolvedValue({
      id: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b01',
      userId: 'x'
    })

    await expect(validateBody(event, schema)).rejects.toMatchObject({
      statusCode: 400
    })
  })

  it('rejects a missing body', async () => {
    readBody.mockResolvedValue(undefined)

    await expect(validateBody(event, schema)).rejects.toMatchObject({
      statusCode: 400
    })
  })
})
