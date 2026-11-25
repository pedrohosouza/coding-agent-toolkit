import { PrismaPg } from '@prisma/adapter-pg'
import { PrismaClient } from '~~/server/generated/prisma/client'
import { paginationExtension } from '~~/server/utils/pagination'

function createExtendedPrismaClient() {
  const { databaseUrl } = useRuntimeConfig()
  const adapter = new PrismaPg({ connectionString: databaseUrl })

  return new PrismaClient({ adapter }).$extends(paginationExtension)
}

export type ExtendedPrismaClient = ReturnType<typeof createExtendedPrismaClient>

const globalForPrisma = globalThis as typeof globalThis & {
  prisma?: ExtendedPrismaClient
}

export const prisma = globalForPrisma.prisma ?? createExtendedPrismaClient()

if (import.meta.dev) {
  globalForPrisma.prisma = prisma
}
