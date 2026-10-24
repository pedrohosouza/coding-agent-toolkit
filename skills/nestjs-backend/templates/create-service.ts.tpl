import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { {{ENTITY_NAME}}_SELECT } from '../constants/{{entity-name}}-select.constant.js';
import type { Create{{EntityName}}Dto } from '../dtos/create-{{entity-name}}.dto.js';

@Injectable()
export class Create{{EntityName}}Service {
  constructor(private readonly prismaService: PrismaService) {}

  async execute(dto: Create{{EntityName}}Dto) {
    return this.prismaService.{{entityName}}.create({
      data: { name: dto.name },
      select: {{ENTITY_NAME}}_SELECT,
    });
  }
}
