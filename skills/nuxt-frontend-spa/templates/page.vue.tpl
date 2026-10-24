<script setup lang="ts">
interface Props {
  title: string
}

defineProps<Props>()
</script>

<template>
  <main>
    <h1>{{ title }}</h1>

    <slot />
  </main>
</template>
