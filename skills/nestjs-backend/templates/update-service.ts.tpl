import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { {{ENTITY_NAME}}_SELECT } from '../constants/{{entity-name}}-select.constant.js';
import type { Update{{EntityName}}Dto } from '../dtos/update-{{entity-name}}.dto.js';
import { {{EntityName}}ExistsValidator } from '../validators/{{entity-name}}-exists.validator.js';

@Injectable()
export class Update{{EntityName}}Service {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly {{entityName}}ExistsValidator: {{EntityName}}ExistsValidator,
  ) {}

  async execute(id: string, dto: Update{{EntityName}}Dto) {
    await this.{{entityName}}ExistsValidator.execute(id);

    return this.prismaService.{{entityName}}.update({
      where: { id },
      data: { name: dto.name },
      select: {{ENTITY_NAME}}_SELECT,
    });
  }
}
