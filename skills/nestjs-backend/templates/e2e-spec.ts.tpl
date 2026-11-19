import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { create{{EntityName}} } from '../factories/{{entity-name}}.factory.js';
import { createAuthenticatedAgent } from '../helpers/create-authenticated-agent.js';
import { createTestApp } from '../helpers/create-test-app.js';
import { resetDatabase } from '../helpers/reset-database.js';

describe('{{EntityNames}} (e2e)', () => {
  const missingId = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77';
  let app: INestApplication;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(async () => {
    await resetDatabase(app);
  });

  describe('authentication', () => {
    it('responds 401 without a session', async () => {
      const response = await request(app.getHttpServer()).get(
        '/api/{{entity-names}}',
      );

      expect(response.status).toBe(401);
    });
  });

  describe('GET /{{entity-names}}', () => {
    it('lists {{entity-names}} with pagination', async () => {
      const { agent } = await createAuthenticatedAgent(app);
      await create{{EntityName}}(app);
      await create{{EntityName}}(app);

      const response = await agent.get('/api/{{entity-names}}').expect(200);

      expect(response.body.data).toHaveLength(2);
      expect(response.body.pagination).toMatchObject({
        page: 1,
        totalItems: 2,
      });
    });
  });

  describe('GET /{{entity-names}}/:id', () => {
    it('returns the {{entityName}}', async () => {
      const { agent } = await createAuthenticatedAgent(app);
      const {{entityName}} = await create{{EntityName}}(app);

      const response = await agent
        .get(`/api/{{entity-names}}/${{{entityName}}.id}`)
        .expect(200);

      expect(response.body.data.id).toBe({{entityName}}.id);
    });

    it('responds 400 for an invalid id', async () => {
      const { agent } = await createAuthenticatedAgent(app);

      await agent.get('/api/{{entity-names}}/not-a-uuid').expect(400);
    });

    it('responds 404 when the {{entityName}} does not exist', async () => {
      const { agent } = await createAuthenticatedAgent(app);

      const response = await agent
        .get(`/api/{{entity-names}}/${missingId}`)
        .expect(404);

      expect(response.body.error.code).toBe('NOT_FOUND');
    });
  });

  describe('POST /{{entity-names}}', () => {
    it('creates the {{entityName}}', async () => {
      const { agent } = await createAuthenticatedAgent(app);

      const response = await agent
        .post('/api/{{entity-names}}')
        .send({ name: 'Example' })
        .expect(201);

      expect(response.body.data.id).toEqual(expect.any(String));
    });

    it('responds 400 with field details for an invalid body', async () => {
      const { agent } = await createAuthenticatedAgent(app);

      const response = await agent
        .post('/api/{{entity-names}}')
        .send({ name: '' })
        .expect(400);

      expect(response.body.error.code).toBe('VALIDATION_ERROR');
      expect(response.body.error.details).toEqual(
        expect.arrayContaining([expect.objectContaining({ field: 'name' })]),
      );
    });
  });

  describe('PATCH /{{entity-names}}/:id', () => {
    it('updates the {{entityName}}', async () => {
      const { agent } = await createAuthenticatedAgent(app);
      const {{entityName}} = await create{{EntityName}}(app);

      await agent
        .patch(`/api/{{entity-names}}/${{{entityName}}.id}`)
        .send({ name: 'Renamed' })
        .expect(200);
    });

    it('responds 404 when the {{entityName}} does not exist', async () => {
      const { agent } = await createAuthenticatedAgent(app);

      await agent
        .patch(`/api/{{entity-names}}/${missingId}`)
        .send({ name: 'Renamed' })
        .expect(404);
    });
  });

  describe('DELETE /{{entity-names}}/:id', () => {
    it('deletes the {{entityName}}', async () => {
      const { agent } = await createAuthenticatedAgent(app);
      const {{entityName}} = await create{{EntityName}}(app);

      await agent.delete(`/api/{{entity-names}}/${{{entityName}}.id}`).expect(204);
      await agent.get(`/api/{{entity-names}}/${{{entityName}}.id}`).expect(404);
    });
  });
});
