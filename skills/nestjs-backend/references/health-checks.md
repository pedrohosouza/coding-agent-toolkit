# Health checks

## Rotas

- `GET /health/liveness`
- `GET /health/readiness`

## Regras

- Use `@nestjs/terminus` obrigatoriamente; não implemente health check manual.
- O `HealthController` usa `@AllowAnonymous()` e `@HealthCheck()` em cada rota.
- Cada rota delega para um service (`CheckLivenessService`, `CheckReadinessService`) com `execute()`.
- Liveness indica apenas que o processo está vivo: `health.check([])`, sem dependências.
- Readiness verifica toda dependência externa de que a API precisa para atender requisições.
- Health checks não expõem detalhes sensíveis (URLs, credenciais, mensagens de erro internas).
- Falha de qualquer indicador retorna `503`.
- Durante graceful shutdown, readiness responde `503`.

## Readiness: toda dependência é verificada

Todo serviço de que a API depende deve ter um indicador no `CheckReadinessService`:

- Banco de dados: `PrismaHealthIndicator.pingCheck`.
- Cache e filas (Redis): ping via indicador customizado.
- Storage de objetos (S3 ou equivalente): indicador customizado.
- APIs externas críticas: `HttpHealthIndicator.pingCheck` ou indicador customizado.
- SMTP e demais integrações sem as quais a API não funciona: indicador customizado.

Regras:

- Ao adicionar uma dependência nova à API, adicione o indicador no mesmo PR.
- Não adicione dependência sem indicador de readiness.
- Cada indicador usa uma chave estável e descritiva: `database`, `redis`, `storage`.
- Indicador customizado fica em `src/modules/health/indicators/<name>.health-indicator.ts`, usando `HealthIndicatorService` do Terminus, e é registrado em `providers` do `HealthModule`.
- Cada verificação tem timeout curto, para que um serviço lento não trave o probe.
- Dependência opcional ou degradável não entra no readiness.

## Estrutura

```text
src/modules/health/
├── health.module.ts
├── controllers/
│   └── health.controller.ts
├── indicators/
└── services/
    ├── check-liveness.service.ts
    └── check-readiness.service.ts
```

## Exemplo

```ts
@AllowAnonymous()
@Controller('health')
export class HealthController {
  constructor(
    private readonly checkLivenessService: CheckLivenessService,
    private readonly checkReadinessService: CheckReadinessService,
  ) {}

  @Get('liveness')
  @HealthCheck()
  async checkLiveness() {
    return this.checkLivenessService.execute();
  }

  @Get('readiness')
  @HealthCheck()
  async checkReadiness() {
    return this.checkReadinessService.execute();
  }
}
```

```ts
@Injectable()
export class CheckReadinessService {
  constructor(
    private readonly health: HealthCheckService,
    private readonly prismaHealthIndicator: PrismaHealthIndicator,
    private readonly prismaService: PrismaService,
  ) {}

  async execute(): Promise<HealthCheckResult> {
    return this.health.check([
      this.prismaHealthIndicator.pingCheck('database', this.prismaService),
    ]);
  }
}
```
