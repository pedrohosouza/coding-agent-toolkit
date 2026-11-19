import { expect, test } from '@playwright/test'
import fixture from './fixtures/{{entity-names}}.json' with { type: 'json' }

test.beforeEach(async ({ page }) => {
  await page.route('**/api/auth/get-session', (route) =>
    route.fulfill({
      json: {
        session: { id: 'session-1', userId: 'user-1' },
        user: { id: 'user-1', name: 'Test User', email: 'test@example.com' }
      }
    })
  )
})

test.describe('{{EntityNames}} page', () => {
  test('lists the {{entity-names}}', async ({ page }) => {
    await page.route('**/api/{{entity-names}}*', (route) =>
      route.fulfill({ json: fixture })
    )

    await page.goto('/{{entity-names}}')

    await expect(page.getByText(fixture.data[0].name)).toBeVisible()
  })

  test('shows the empty state when there are no {{entity-names}}', async ({
    page
  }) => {
    await page.route('**/api/{{entity-names}}*', (route) =>
      route.fulfill({
        json: { data: [], pagination: fixture.pagination }
      })
    )

    await page.goto('/{{entity-names}}')

    await expect(page.getByText('Nenhum registro encontrado')).toBeVisible()
  })

  test('shows an error when the API fails', async ({ page }) => {
    await page.route('**/api/{{entity-names}}*', (route) =>
      route.fulfill({
        status: 500,
        json: {
          error: { code: 'INTERNAL_SERVER_ERROR', message: 'Internal server error' }
        }
      })
    )

    await page.goto('/{{entity-names}}')

    await expect(page.getByRole('alert')).toBeVisible()
  })
})
