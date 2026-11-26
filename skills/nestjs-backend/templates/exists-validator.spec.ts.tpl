import { NotFoundException } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { beforeEach, describe, expect, it } from 'vitest';
import { mockDeep } from 'vitest-mock-extended';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { {{EntityName}}ExistsValidator } from './{{entity-name}}-exists.validator.js';

describe('{{EntityName}}ExistsValidator', () => {
  const userId = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b11';
  const id = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77';
  const prismaService = mockDeep<PrismaService>();
  let validator: {{EntityName}}ExistsValidator;

  beforeEach(async () => {
    const moduleRef = await Test.createTestingModule({
      providers: [
        {{EntityName}}ExistsValidator,
        { provide: PrismaService, useValue: prismaService },
      ],
    }).compile();

    validator = moduleRef.get({{EntityName}}ExistsValidator);
  });

  it('returns the id when the {{entityName}} exists', async () => {
    prismaService.{{entityName}}.findFirst.mockResolvedValue({ id } as never);

    await expect(validator.execute(userId, id)).resolves.toEqual({ id });
    expect(prismaService.{{entityName}}.findFirst).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id, userId } }),
    );
  });

  it('throws NotFoundException when the {{entityName}} does not exist or belongs to another user', async () => {
    prismaService.{{entityName}}.findFirst.mockResolvedValue(null);

    await expect(validator.execute(userId, id)).rejects.toBeInstanceOf(
      NotFoundException,
    );
  });
});
