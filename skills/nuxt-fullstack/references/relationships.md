# Validação de relacionamentos

## Fluxo

1. O schema Zod valida o formato do identificador (`z.uuid()`).
2. O service verifica a existência do recurso pai.
3. O service verifica permissão sobre o recurso relacionado.
4. O service persiste com Prisma; use transação para múltiplas escritas dependentes.

## Validators

- A verificação de existência fica em um validator reutilizável: `server/validators/<entity-name>-exists.validator.ts`, com `execute(userId, id)`.
- O validator filtra por dono (`where: { id, userId }`) e lança `404` quando o recurso não existe ou não pertence ao escopo da sessão.
- O validator retorna só os campos necessários (`select`).
- Services de get, update e delete chamam o validator antes de operar.

## Regras

- Diferencie validação de formato de validação de existência.
- Antes de criar ou atualizar um recurso com FK, verifique se o recurso pai existe e se o usuário pode associá-lo.
- Nunca exponha erro cru de foreign key; o error handler mapeia `P2002` e `P2025`.
- Defina o comportamento de deleção: restrict, cascade ou soft delete; nunca deixe órfãos.
- Mantenha constraints no banco como garantia final.

## Exemplo

```ts
export class CustomerExistsValidator {
  constructor(private readonly db: ExtendedPrismaClient = prisma) {}

  async execute(userId: string, id: string) {
    const customer = await this.db.customer.findFirst({
      where: { id, userId },
      select: { id: true }
    })

    if (!customer) {
      throw createError({ statusCode: 404, message: 'Customer not found' })
    }

    return customer
  }
}
```

## Template

`exists-validator.ts.tpl`.
