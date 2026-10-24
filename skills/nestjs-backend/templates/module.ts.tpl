import { Module } from '@nestjs/common';
import { {{EntityNames}}Controller } from './controllers/{{entity-names}}.controller.js';
import { Create{{EntityName}}Service } from './services/create-{{entity-name}}.service.js';
import { Delete{{EntityName}}Service } from './services/delete-{{entity-name}}.service.js';
import { Get{{EntityName}}Service } from './services/get-{{entity-name}}.service.js';
import { List{{EntityNames}}Service } from './services/list-{{entity-names}}.service.js';
import { Update{{EntityName}}Service } from './services/update-{{entity-name}}.service.js';
import { {{EntityName}}ExistsValidator } from './validators/{{entity-name}}-exists.validator.js';

@Module({
  controllers: [{{EntityNames}}Controller],
  providers: [
    {{EntityName}}ExistsValidator,
    List{{EntityNames}}Service,
    Get{{EntityName}}Service,
    Create{{EntityName}}Service,
    Update{{EntityName}}Service,
    Delete{{EntityName}}Service,
  ],
})
export class {{EntityNames}}Module {}
