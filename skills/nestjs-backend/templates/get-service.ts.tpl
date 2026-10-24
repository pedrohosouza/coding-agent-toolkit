import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { {{ENTITY_NAME}}_SELECT } from '../constants/{{entity-name}}-select.constant.js';
import { {{EntityName}}ExistsValidator } from '../validators/{{entity-name}}-exists.validator.js';

@Injectable()
export class Get{{EntityName}}Service {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly {{entityName}}ExistsValidator: {{EntityName}}ExistsValidator,
  ) {}

  async execute(id: string) {
    await this.{{entityName}}ExistsValidator.execute(id);

    return this.prismaService.{{entityName}}.findUniqueOrThrow({
      where: { id },
      select: {{ENTITY_NAME}}_SELECT,
    });
  }
}
