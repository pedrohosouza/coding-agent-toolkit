# Configuração

## Regras

- Use `@nestjs/config` com validação no boot.
- Nenhuma classe de domínio, service ou controller acessa `process.env` diretamente.
- Toda variável de ambiente passa por `ConfigService` ou por um serviço de configuração dedicado.
- Toda env nova entra no schema de validação antes do primeiro uso.
- A aplicação falha no boot se uma env obrigatória estiver ausente ou inválida.
- Mantenha `.env.example` atualizado, sem valores reais.
- `.env` e `.env.example` seguem a organização descrita em "Organização do `.env`".
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

## Organização do `.env`

- Variáveis do app vêm primeiro, sem agrupamento por prefixo: `NODE_ENV`, `PORT` e similares.
- As demais variáveis são agrupadas por prefixo (`DATABASE_`, `BETTER_AUTH_`, `CORS_`).
- Uma linha em branco separa o bloco do app e cada grupo de prefixo.
- Dentro de cada grupo, mantenha as variáveis juntas e em ordem lógica.
- `.env` e `.env.example` usam a mesma ordem e os mesmos grupos; o `.env.example` não tem valores reais.

```text
NODE_ENV=development
PORT=3000
CORS_ALLOWED_ORIGINS=

DATABASE_URL=

BETTER_AUTH_SECRET=
BETTER_AUTH_URL=

```
