# Configuração

## Regras

- Use `@nestjs/config` com validação no boot.
- Nenhuma classe de domínio, service ou controller acessa `process.env` diretamente.
- Toda variável de ambiente passa por `ConfigService` ou por um serviço de configuração dedicado.
- Toda env nova entra no schema de validação antes do primeiro uso.
- A aplicação falha no boot se uma env obrigatória estiver ausente ou inválida.
- Mantenha `.env.example` atualizado, sem valores reais.
- Nunca exponha segredos em DTOs, respostas ou repositório.

## Estrutura

```text
src/common/modules/environment/
├── environment.module.ts
└── schemas/
    └── environment-validation.schema.ts
```

- `EnvironmentModule` registra `ConfigModule.forRoot({ isGlobal: true, validationSchema })`.
- O schema usa Joi, com tipo, obrigatoriedade e default explícitos.
- O acesso é sempre por `ConfigService.getOrThrow<T>('NAME')`.

## Exemplos de variáveis

```text
DATABASE_URL=
BETTER_AUTH_SECRET=
BETTER_AUTH_URL=
CORS_ALLOWED_ORIGINS=
```
