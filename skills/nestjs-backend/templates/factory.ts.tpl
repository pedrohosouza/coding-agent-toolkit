import type { INestApplication } from '@nestjs/common';
import { PrismaService } from '../../src/common/modules/prisma/services/prisma.service.js';

interface {{EntityName}}Overrides {
  name?: string;
}

export function create{{EntityName}}(
  app: INestApplication,
  overrides: {{EntityName}}Overrides = {},
) {
  return app.get(PrismaService).{{entityName}}.create({
    data: { name: overrides.name ?? `{{EntityName}} ${crypto.randomUUID()}` },
  });
}
