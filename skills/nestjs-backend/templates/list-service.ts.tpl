import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/modules/prisma/services/prisma.service.js';
import { {{ENTITY_NAME}}_SEARCHABLE_FIELDS } from '../constants/{{entity-name}}-searchable-fields.constant.js';
import { {{ENTITY_NAME}}_SELECT } from '../constants/{{entity-name}}-select.constant.js';
import type { List{{EntityNames}}QueryDto } from '../dtos/list-{{entity-names}}-query.dto.js';

@Injectable()
export class List{{EntityNames}}Service {
  constructor(private readonly prismaService: PrismaService) {}

  async execute(query: List{{EntityNames}}QueryDto) {
    const { page, perPage, search, sort, order } = query;

    return this.prismaService.{{entityName}}.paginate(
      {
        orderBy: { [sort]: order },
        select: {{ENTITY_NAME}}_SELECT,
      },
      {
        page,
        perPage,
        search,
        searchFields: {{ENTITY_NAME}}_SEARCHABLE_FIELDS,
      },
    );
  }
}
