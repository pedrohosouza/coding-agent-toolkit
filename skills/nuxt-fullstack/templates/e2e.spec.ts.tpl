import { expect, test } from './support/fixtures'
import fixture from './fixtures/{{entity-names}}.json' with { type: 'json' }

test.describe('{{EntityNames}} page', () => {
  test('redirects to the login page without a session', async ({ page }) => {
    await page.goto('/{{entity-names}}')

    await expect(page).toHaveURL(/\/auth\/login/)
  })

  test('lists the {{entity-names}} of the user', async ({ authenticatedPage: page }) => {
    for (const item of fixture.items) {
      await page.request.post('/api/{{entity-names}}', { data: item })
    }

    await page.goto('/{{entity-names}}')

    await expect(page.getByText(fixture.items[0].name)).toBeVisible()
    await expect(page.getByText(fixture.items[1].name)).toBeVisible()
  })

  test('shows the empty state when there are no {{entity-names}}', async ({
    authenticatedPage: page
  }) => {
    await page.goto('/{{entity-names}}')

    await expect(page.getByText('Nenhum registro encontrado')).toBeVisible()
  })

  test('creates a {{entityName}} through the form', async ({
    authenticatedPage: page
  }) => {
    await page.goto('/{{entity-names}}')

    await page.getByLabel('Nome').fill(fixture.created.name)
    await page.getByRole('button', { name: 'Salvar' }).click()

    await expect(page.getByText('{{EntityName}} criado')).toBeVisible()
    await expect(page.getByText(fixture.created.name)).toBeVisible()
  })
})
