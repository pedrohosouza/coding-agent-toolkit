import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { {{EntityName}}ExistsValidator } from '../validators/{{entity-name}}-exists.validator.js';

@Injectable()
export class Delete{{EntityName}}Service {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly {{entityName}}ExistsValidator: {{EntityName}}ExistsValidator,
  ) {}

  async execute(id: string): Promise<void> {
    await this.{{entityName}}ExistsValidator.execute(id);

    await this.prismaService.{{entityName}}.delete({ where: { id } });
  }
}
