<script setup lang="ts">
import type { Create{{EntityName}}Input } from '#shared/schemas/{{entity-name}}.validation'

definePageMeta({ middleware: 'auth' })
useSeoMeta({ title: '{{EntityNames}}' })

const {
  create,
  error,
  items,
  pagination,
  pending,
  refresh,
  remove,
  running,
  searchInput,
  setPage,
  validationErrors
} = use{{EntityNames}}()

async function onSubmit(payload: Create{{EntityName}}Input) {
  await create(payload)
}
</script>

<template>
  <main>
    <h1>{{EntityNames}}</h1>

    <{{EntityName}}FormPanel
      :errors="validationErrors"
      :loading="running"
      @submit="onSubmit"
    />

    <UInput v-model="searchInput" placeholder="Buscar" aria-label="Buscar" />

    <USkeleton v-if="pending && items.length === 0" class="h-64 w-full" />

    <UAlert
      v-else-if="error"
      color="error"
      title="Não foi possível carregar os registros"
      :actions="[{ label: 'Tentar novamente', onClick: () => refresh() }]"
    />

    <UAlert
      v-else-if="items.length === 0"
      color="neutral"
      title="Nenhum registro encontrado"
    />

    <ul v-else>
      <li v-for="item in items" :key="item.id">
        {{ item.name }}
        <UButton
          color="error"
          variant="ghost"
          icon="i-lucide-trash-2"
          :aria-label="`Excluir ${item.name}`"
          :disabled="running"
          @click="remove(item.id)"
        />
      </li>
    </ul>

    <UPagination
      v-if="pagination"
      :page="pagination.page"
      :items-per-page="pagination.perPage"
      :total="pagination.totalItems"
      @update:page="setPage"
    />
  </main>
</template>
