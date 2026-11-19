import { mountSuspended } from '@nuxt/test-utils/runtime'
import { flushPromises } from '@vue/test-utils'
import { describe, expect, it } from 'vitest'
import {{EntityName}}FormPanel from '~/components/{{entity-name}}/{{EntityName}}FormPanel.vue'

describe('{{EntityName}}FormPanel', () => {
  it('emits the payload when the form is valid', async () => {
    const wrapper = await mountSuspended({{EntityName}}FormPanel, {
      props: { loading: false }
    })

    await wrapper.find('input').setValue('Example')
    await wrapper.find('form').trigger('submit')
    await flushPromises()

    expect(wrapper.emitted('submit')).toEqual([[{ name: 'Example' }]])
  })

  it('does not emit and shows the message when the form is invalid', async () => {
    const wrapper = await mountSuspended({{EntityName}}FormPanel, {
      props: { loading: false }
    })

    await wrapper.find('input').setValue('ab')
    await wrapper.find('form').trigger('submit')
    await flushPromises()

    expect(wrapper.emitted('submit')).toBeUndefined()
    expect(wrapper.text()).toContain('Use ao menos 3 caracteres.')
  })

  it('disables the submit button while loading', async () => {
    const wrapper = await mountSuspended({{EntityName}}FormPanel, {
      props: { loading: true }
    })

    expect(wrapper.find('button[type="submit"]').attributes('disabled')).toBeDefined()
  })

  it('shows field errors received from the API', async () => {
    const wrapper = await mountSuspended({{EntityName}}FormPanel, {
      props: { loading: false, errors: [] }
    })

    await wrapper.setProps({
      errors: [{ name: 'name', message: 'Nome já cadastrado.' }]
    })
    await flushPromises()

    expect(wrapper.text()).toContain('Nome já cadastrado.')
  })
})
