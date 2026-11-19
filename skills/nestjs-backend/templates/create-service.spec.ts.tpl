import { Test } from '@nestjs/testing';
import { beforeEach, describe, expect, it } from 'vitest';
import { mockDeep } from 'vitest-mock-extended';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { Create{{EntityName}}Service } from './create-{{entity-name}}.service.js';

describe('Create{{EntityName}}Service', () => {
  const prismaService = mockDeep<PrismaService>();
  let service: Create{{EntityName}}Service;

  beforeEach(async () => {
    const moduleRef = await Test.createTestingModule({
      providers: [
        Create{{EntityName}}Service,
        { provide: PrismaService, useValue: prismaService },
      ],
    }).compile();

    service = moduleRef.get(Create{{EntityName}}Service);
  });

  it('creates the {{entityName}} with the given name', async () => {
    const created = {
      id: '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77',
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    prismaService.{{entityName}}.create.mockResolvedValue(created as never);

    const result = await service.execute({ name: 'Example' });

    expect(result).toEqual(created);
    expect(prismaService.{{entityName}}.create).toHaveBeenCalledWith(
      expect.objectContaining({ data: { name: 'Example' } }),
    );
  });
});
