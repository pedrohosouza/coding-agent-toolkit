import { beforeEach, describe, expect, it, vi } from 'vitest'
import { prisma } from '~~/server/utils/prisma'
import { {{EntityName}}ExistsValidator } from '~~/server/validators/{{entity-name}}-exists.validator'

vi.mock('~~/server/utils/prisma', () => ({
  prisma: { {{entityName}}: { findFirst: vi.fn() } }
}))

vi.stubGlobal('createError', (input: { statusCode: number; message: string }) =>
  Object.assign(new Error(input.message), input)
)

describe('{{EntityName}}ExistsValidator', () => {
  const userId = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b01'
  const id = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77'
  let validator: {{EntityName}}ExistsValidator

  beforeEach(() => {
    vi.clearAllMocks()
    validator = new {{EntityName}}ExistsValidator()
  })

  it('returns the id when the {{entityName}} belongs to the user', async () => {
    vi.mocked(prisma.{{entityName}}.findFirst).mockResolvedValue({ id } as never)

    await expect(validator.execute(userId, id)).resolves.toEqual({ id })
    expect(prisma.{{entityName}}.findFirst).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id, userId } })
    )
  })

  it('throws a 404 error when the {{entityName}} does not exist for the user', async () => {
    vi.mocked(prisma.{{entityName}}.findFirst).mockResolvedValue(null)

    await expect(validator.execute(userId, id)).rejects.toMatchObject({
      statusCode: 404
    })
  })
})
