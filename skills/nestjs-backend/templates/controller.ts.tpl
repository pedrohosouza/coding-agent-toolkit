import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { Create{{EntityName}}Dto } from '../dtos/create-{{entity-name}}.dto.js';
import { List{{EntityNames}}QueryDto } from '../dtos/list-{{entity-names}}-query.dto.js';
import { Update{{EntityName}}Dto } from '../dtos/update-{{entity-name}}.dto.js';
import { Create{{EntityName}}Service } from '../services/create-{{entity-name}}.service.js';
import { Delete{{EntityName}}Service } from '../services/delete-{{entity-name}}.service.js';
import { Get{{EntityName}}Service } from '../services/get-{{entity-name}}.service.js';
import { List{{EntityNames}}Service } from '../services/list-{{entity-names}}.service.js';
import { Update{{EntityName}}Service } from '../services/update-{{entity-name}}.service.js';

@Controller('{{entity-names}}')
export class {{EntityNames}}Controller {
  constructor(
    private readonly list{{EntityNames}}Service: List{{EntityNames}}Service,
    private readonly get{{EntityName}}Service: Get{{EntityName}}Service,
    private readonly create{{EntityName}}Service: Create{{EntityName}}Service,
    private readonly update{{EntityName}}Service: Update{{EntityName}}Service,
    private readonly delete{{EntityName}}Service: Delete{{EntityName}}Service,
  ) {}

  @Get()
  async list(@Query() query: List{{EntityNames}}QueryDto) {
    return this.list{{EntityNames}}Service.execute(query);
  }

  @Get(':id')
  async get(@Param('id', ParseUUIDPipe) id: string) {
    return this.get{{EntityName}}Service.execute(id);
  }

  @Post()
  async create(@Body() dto: Create{{EntityName}}Dto) {
    return this.create{{EntityName}}Service.execute(dto);
  }

  @Patch(':id')
  async update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: Update{{EntityName}}Dto,
  ) {
    return this.update{{EntityName}}Service.execute(id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async delete(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    await this.delete{{EntityName}}Service.execute(id);
  }
}
