# Respostas padronizadas

Toda resposta HTTP segue um envelope único. Controllers e services retornam o dado puro; o envelope é aplicado por componentes globais.

## Recurso específico

```json
{
  "data": {
    "id": "0197e1c2-6f4a-7b3d-9a10-2c5f8e1d4b77",
    "name": "Example"
  }
}
```

## Lista paginada

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "perPage": 10,
    "totalItems": 1543,
    "totalPages": 155,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
```

## Erro

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "issue": "email must be an email"
      }
    ]
  }
}
```

## Componentes

```text
src/common/
├── classes/paginated-result.class.ts
├── constants/http-error-codes.constant.ts
├── constants/validation-error-code.constant.ts
├── factories/validation-exception.factory.ts
├── filters/http-exception.filter.ts
├── interceptors/response-envelope.interceptor.ts
└── interfaces/
    ├── api-response.interface.ts
    ├── api-error-detail.interface.ts
    ├── api-error-response.interface.ts
    ├── paginated-api-response.interface.ts
    └── pagination-meta.interface.ts
```

### Interfaces

```ts
export interface ApiResponse<T> {
  data: T;
}

export interface PaginatedApiResponse<T> {
  data: T[];
  pagination: PaginationMeta;
}

export interface ApiErrorDetail {
  field: string;
  issue: string;
}

export interface ApiErrorResponse {
  error: {
    code: string;
    message: string;
    details?: ApiErrorDetail[];
  };
}
```

### Sucesso: `ResponseEnvelopeInterceptor`

```ts
@Injectable()
export class ResponseEnvelopeInterceptor implements NestInterceptor {
  intercept(
    _context: ExecutionContext,
    next: CallHandler,
  ): Observable<
    | ApiResponse<unknown>
    | PaginatedApiResponse<unknown>
    | StreamableFile
    | undefined
  > {
    return next.handle().pipe(
      map((value: unknown) => {
        if (value === undefined) {
          return undefined;
        }

        if (value instanceof StreamableFile) {
          return value;
        }

        if (value instanceof PaginatedResult) {
          return { data: value.data, pagination: value.pagination };
        }

        return { data: value };
      }),
    );
  }
}
```

- `undefined` não recebe envelope (respostas `204`).
- `StreamableFile` (downloads e exports) não recebe envelope.
- `PaginatedResult` (retorno de `paginate()`) vira `{ data, pagination }`.
- Qualquer outro valor vira `{ data: value }`.

### Erro de validação: `createValidationException`

O `ValidationPipe` usa `exceptionFactory` para gerar `BadRequestException` com `code: 'VALIDATION_ERROR'`, `message: 'Validation failed'` e `details` achatados em `{ field, issue }`. Campos aninhados usam caminho com ponto (`items.0.quantity`).

### Erro geral: `HttpExceptionFilter`

```ts
export const HTTP_ERROR_CODES: Readonly<Record<number, string>> = {
  [HttpStatus.BAD_REQUEST]: 'BAD_REQUEST',
  [HttpStatus.UNAUTHORIZED]: 'UNAUTHORIZED',
  [HttpStatus.FORBIDDEN]: 'FORBIDDEN',
  [HttpStatus.NOT_FOUND]: 'NOT_FOUND',
  [HttpStatus.CONFLICT]: 'CONFLICT',
  [HttpStatus.PAYLOAD_TOO_LARGE]: 'PAYLOAD_TOO_LARGE',
  [HttpStatus.UNPROCESSABLE_ENTITY]: 'UNPROCESSABLE_ENTITY',
  [HttpStatus.TOO_MANY_REQUESTS]: 'TOO_MANY_REQUESTS',
  [HttpStatus.INTERNAL_SERVER_ERROR]: 'INTERNAL_SERVER_ERROR',
  [HttpStatus.SERVICE_UNAVAILABLE]: 'SERVICE_UNAVAILABLE',
};
```

- `@Catch()` captura toda exceção e responde com `ApiErrorResponse` via `HttpAdapterHost`.
- `HttpException`: usa o status da exceção; o `code` vem do payload (`code`) ou de `HTTP_ERROR_CODES[status]`; `details` só entra quando for uma lista de `{ field, issue }`.
- Exceção que não é `HttpException`: responde `500` com `INTERNAL_SERVER_ERROR` e a mensagem fixa `Internal server error`, sem stack trace nem detalhe do banco.
- Todo status novo usado pela API entra em `HTTP_ERROR_CODES`.

### Registro no `main.ts`

```ts
app.useGlobalPipes(
  new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
    exceptionFactory: createValidationException,
  }),
);
app.useGlobalInterceptors(new ResponseEnvelopeInterceptor());
app.useGlobalFilters(new HttpExceptionFilter(app.get(HttpAdapterHost)));
app.enableShutdownHooks();
```

## Regras

- Controllers e services nunca montam `{ data }` manualmente; retornam o dado e deixam o interceptor aplicar o envelope.
- Listagens retornam `PaginatedResult`, nunca `{ data, pagination }` montado à mão.
- Nunca retorne `200` com erro no corpo.
- Lance exceções semânticas do NestJS (`NotFoundException`, `ConflictException`, etc.); nunca `new Error()`.
- Use `200` para leitura e atualização com corpo.
- Use `201` para criação.
- Use `204` para deleção sem corpo (`@HttpCode(HttpStatus.NO_CONTENT)`).
- Use `400` para requisição malformada e falha de validação de DTO (`VALIDATION_ERROR`).
- Use `401` para não autenticado.
- Use `403` para sem permissão.
- Use `404` para recurso inexistente.
- Use `409` para conflito.
- Use `413` para payload grande demais.
- Use `422` para regra semântica violada, como relacionamento inexistente.
- Use `429` para rate limit.
- Use `500` para erro interno, sem stack trace ou detalhes do banco.
- Use `503` para readiness indisponível.
