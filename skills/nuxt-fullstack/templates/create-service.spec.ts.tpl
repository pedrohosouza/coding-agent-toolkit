import { beforeEach, describe, expect, it, vi } from 'vitest'
import { prisma } from '~~/server/utils/prisma'
import { Create{{EntityName}}Service } from '~~/server/services/{{entity-names}}/create-{{entity-name}}.service'

vi.mock('~~/server/utils/prisma', () => ({
  prisma: { {{entityName}}: { create: vi.fn() } }
}))

describe('Create{{EntityName}}Service', () => {
  const userId = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b01'
  let service: Create{{EntityName}}Service

  beforeEach(() => {
    vi.clearAllMocks()
    service = new Create{{EntityName}}Service()
  })

  it('creates the {{entityName}} for the given user', async () => {
    const created = {
      id: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77',
      createdAt: new Date(),
      updatedAt: new Date()
    }
    vi.mocked(prisma.{{entityName}}.create).mockResolvedValue(created as never)

    const result = await service.execute(userId, { name: 'Example' })

    expect(result).toEqual(created)
    expect(prisma.{{entityName}}.create).toHaveBeenCalledWith(
      expect.objectContaining({ data: { name: 'Example', userId } })
    )
  })
})
