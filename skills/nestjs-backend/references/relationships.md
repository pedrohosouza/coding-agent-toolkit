# Validação de relacionamentos

## Fluxo

1. O DTO valida o formato do identificador.
2. O service verifica a existência do recurso pai.
3. O service verifica permissão sobre o recurso relacionado.
4. O service persiste usando Prisma; use transação para múltiplas escritas dependentes.

## Validators

- A verificação de existência fica em um validator reutilizável: `validators/<entity>-exists.validator.ts`, com `execute()`.
- O validator lança `NotFoundException` quando o recurso não existe ou não pertence ao escopo do usuário.
- O validator retorna apenas os campos necessários (`select`).
- Services de get, update e delete chamam o validator antes de operar.

## Regras

- Diferencie validação de formato de validação de existência.
- Antes de criar ou atualizar um recurso com FK, verifique se o recurso pai existe.
- Verifique se o usuário pode usar ou associar o recurso relacionado.
- Nunca exponha erro cru de foreign key ao cliente.
- Defina comportamento de deleção: restrict, cascade ou soft delete.
- Nunca deixe registros órfãos.
- Mantenha constraints no banco como garantia final.

## Exemplo

```ts
@Injectable()
export class CustomerExistsValidator {
  constructor(private readonly prismaService: PrismaService) {}

  async execute(id: string) {
    const customer = await this.prismaService.customer.findUnique({
      where: { id },
      select: { id: true },
    });

    if (!customer) {
      throw new NotFoundException('Customer not found');
    }

    return customer;
  }
}
```
