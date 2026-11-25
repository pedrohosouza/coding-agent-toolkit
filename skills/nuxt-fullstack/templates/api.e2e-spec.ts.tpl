import { fileURLToPath } from 'node:url'
import { fetch, setup } from '@nuxt/test-utils/e2e'
import { beforeEach, describe, expect, it } from 'vitest'
import { create{{EntityName}} } from '../../factories/{{entity-name}}.factory'
import { createAuthenticatedClient } from '../../helpers/create-authenticated-client'
import { resetDatabase } from '../../helpers/reset-database'

describe('{{EntityNames}} (e2e)', async () => {
  const missingId = '0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77'

  await setup({
    rootDir: fileURLToPath(new URL('../../..', import.meta.url)),
    server: true
  })

  beforeEach(async () => {
    await resetDatabase()
  })

  describe('authentication', () => {
    it('responds 401 without a session', async () => {
      const response = await fetch('/api/{{entity-names}}')

      expect(response.status).toBe(401)
    })
  })

  describe('GET /api/{{entity-names}}', () => {
    it('lists only the {{entity-names}} of the user with pagination', async () => {
      const client = await createAuthenticatedClient()
      const other = await createAuthenticatedClient()
      await create{{EntityName}}(client.userId)
      await create{{EntityName}}(client.userId)
      await create{{EntityName}}(other.userId)

      const response = await client.request('/api/{{entity-names}}')

      expect(response.status).toBe(200)
      expect(response.body.data).toHaveLength(2)
      expect(response.body.pagination).toMatchObject({ page: 1, totalItems: 2 })
    })
  })

  describe('GET /api/{{entity-names}}/:id', () => {
    it('returns the {{entityName}}', async () => {
      const client = await createAuthenticatedClient()
      const {{entityName}} = await create{{EntityName}}(client.userId)

      const response = await client.request(`/api/{{entity-names}}/${{{entityName}}.id}`)

      expect(response.status).toBe(200)
      expect(response.body.data.id).toBe({{entityName}}.id)
    })

    it('responds 400 for an invalid id', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request('/api/{{entity-names}}/not-a-uuid')

      expect(response.status).toBe(400)
    })

    it('responds 404 when the {{entityName}} does not exist', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request(`/api/{{entity-names}}/${missingId}`)

      expect(response.status).toBe(404)
      expect(response.body.error.code).toBe('NOT_FOUND')
    })

    it('responds 404 when the {{entityName}} belongs to another user', async () => {
      const owner = await createAuthenticatedClient()
      const intruder = await createAuthenticatedClient()
      const {{entityName}} = await create{{EntityName}}(owner.userId)

      const response = await intruder.request(
        `/api/{{entity-names}}/${{{entityName}}.id}`
      )

      expect(response.status).toBe(404)
    })
  })

  describe('POST /api/{{entity-names}}', () => {
    it('creates the {{entityName}} for the session user', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request('/api/{{entity-names}}', {
        method: 'POST',
        body: { name: 'Example' }
      })

      expect(response.status).toBe(201)
      expect(response.body.data.id).toEqual(expect.any(String))
    })

    it('responds 400 with field details for an invalid body', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request('/api/{{entity-names}}', {
        method: 'POST',
        body: { name: '' }
      })

      expect(response.status).toBe(400)
      expect(response.body.error.code).toBe('VALIDATION_ERROR')
      expect(response.body.error.details).toEqual(
        expect.arrayContaining([expect.objectContaining({ field: 'name' })])
      )
    })

    it('responds 400 for an unknown body field', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request('/api/{{entity-names}}', {
        method: 'POST',
        body: { name: 'Example', userId: 'other-user' }
      })

      expect(response.status).toBe(400)
      expect(response.body.error.code).toBe('VALIDATION_ERROR')
    })

    it('responds 400 for an invalid id param', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request('/api/{{entity-names}}/not-a-uuid')

      expect(response.status).toBe(400)
      expect(response.body.error.code).toBe('VALIDATION_ERROR')
    })

    it('responds 400 for an invalid query', async () => {
      const client = await createAuthenticatedClient()

      const response = await client.request(
        '/api/{{entity-names}}?perPage=101'
      )

      expect(response.status).toBe(400)
      expect(response.body.error.code).toBe('VALIDATION_ERROR')
    })
  })

  describe('PATCH /api/{{entity-names}}/:id', () => {
    it('updates the {{entityName}}', async () => {
      const client = await createAuthenticatedClient()
      const {{entityName}} = await create{{EntityName}}(client.userId)

      const response = await client.request(`/api/{{entity-names}}/${{{entityName}}.id}`, {
        method: 'PATCH',
        body: { name: 'Renamed' }
      })

      expect(response.status).toBe(200)
    })

    it('responds 404 when the {{entityName}} belongs to another user', async () => {
      const owner = await createAuthenticatedClient()
      const intruder = await createAuthenticatedClient()
      const {{entityName}} = await create{{EntityName}}(owner.userId)

      const response = await intruder.request(
        `/api/{{entity-names}}/${{{entityName}}.id}`,
        { method: 'PATCH', body: { name: 'Renamed' } }
      )

      expect(response.status).toBe(404)
    })
  })

  describe('DELETE /api/{{entity-names}}/:id', () => {
    it('deletes the {{entityName}}', async () => {
      const client = await createAuthenticatedClient()
      const {{entityName}} = await create{{EntityName}}(client.userId)

      const removed = await client.request(`/api/{{entity-names}}/${{{entityName}}.id}`, {
        method: 'DELETE'
      })
      const fetched = await client.request(`/api/{{entity-names}}/${{{entityName}}.id}`)

      expect(removed.status).toBe(204)
      expect(fetched.status).toBe(404)
    })

    it('responds 404 when the {{entityName}} belongs to another user', async () => {
      const owner = await createAuthenticatedClient()
      const intruder = await createAuthenticatedClient()
      const {{entityName}} = await create{{EntityName}}(owner.userId)

      const response = await intruder.request(
        `/api/{{entity-names}}/${{{entityName}}.id}`,
        { method: 'DELETE' }
      )

      expect(response.status).toBe(404)
    })
  })
})
