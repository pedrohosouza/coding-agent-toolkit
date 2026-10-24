# Validação de entrada

## Regras

- Todo input externo passa por DTO.
- Use `ValidationPipe` global.
- Use `whitelist: true`.
- Use `forbidNonWhitelisted: true`.
- Use `transform: true`.
- Valide body, query, params e headers.
- Use allowlist, nunca blocklist.
- Rejeite campos desconhecidos.
- Normalize dados antes do service.
- Não valide no controller; valide na borda via pipe/DTO.
- Erros seguem o envelope padrão de erro.
- Todo identificador em body, query ou header usa `@IsUUID()`; todo `:id` de rota usa `ParseUUIDPipe`.
- DTOs ficam em `dtos/`, um por arquivo; DTOs de listagem estendem `PaginationQueryDto`.

## Exemplo

```ts
export class CreateOrderDto {
  @IsUUID()
  customerId!: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateOrderItemDto)
  items!: CreateOrderItemDto[];
}
```
