import { Transform } from 'class-transformer';
import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { SORT_ORDERS } from '../../../common/constants/sort-orders.constant.js';
import { PaginationQueryDto } from '../../../common/dtos/pagination-query.dto.js';
import type { SortOrder } from '../../../common/types/sort-order.type.js';
import { {{ENTITY_NAME}}_SORTABLE_FIELDS } from '../constants/{{entity-name}}-sortable-fields.constant.js';

export class List{{EntityNames}}QueryDto extends PaginationQueryDto {
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @IsString()
  @MaxLength(100)
  search?: string;

  @IsOptional()
  @IsIn({{ENTITY_NAME}}_SORTABLE_FIELDS)
  sort: (typeof {{ENTITY_NAME}}_SORTABLE_FIELDS)[number] = 'createdAt';

  @IsOptional()
  @IsIn(SORT_ORDERS)
  order: SortOrder = 'desc';
}
