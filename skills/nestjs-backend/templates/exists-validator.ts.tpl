import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';

@Injectable()
export class {{EntityName}}ExistsValidator {
  constructor(private readonly prismaService: PrismaService) {}

  async execute(id: string) {
    const {{entityName}} = await this.prismaService.{{entityName}}.findUnique({
      where: { id },
      select: { id: true },
    });

    if (!{{entityName}}) {
      throw new NotFoundException('{{EntityName}} not found');
    }

    return {{entityName}};
  }
}
