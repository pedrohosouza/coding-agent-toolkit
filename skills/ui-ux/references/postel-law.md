# Lei de Postel (Princípio da Robustez)

## Princípio

Seja liberal no que aceita e conservador no que envia. A interface deve tolerar variações razoáveis de entrada do usuário, normalizá-las internamente e devolver saídas consistentes e previsíveis.

## Quando aplicar

- Campos de telefone, documento, data, moeda, CEP, e-mail, URL e busca.
- Colagem de dados vindos de planilhas, e-mails ou outros sistemas.
- Importação de arquivos e integrações.
- Erros de validação frequentes em campos simples.

## Regras práticas

- Aceite com ou sem máscara: `12345678900`, `123.456.789-00`, `123 456 789 00` são o mesmo CPF.
- Remova espaços no início/fim e espaços duplicados antes de validar.
- E-mail: aceite maiúsculas, normalize para minúsculas; não bloqueie domínios válidos e novos TLDs.
- Moeda: aceite `1.234,56`, `1234,56` e `1234.56` quando não houver ambiguidade; exiba sempre no formato local.
- Busca: ignore acentos e caixa ("joao" encontra "João"); tolere erros de digitação quando possível.
- Valide no `blur` ou no envio, não a cada tecla; não mostre erro antes de o usuário terminar de digitar.
- Saída sempre consistente: mesmo formato de data, número e moeda em toda a aplicação.

## Padrões de implementação

- Normalização antes da validação (`trim`, remoção de não dígitos, `toLowerCase`).
- `inputmode="numeric"` em vez de `type="number"` para documentos e códigos (preserva zeros à esquerda).
- Datas: date picker com digitação livre aceita; parse tolerante a `/`, `-` e `.`.
- Importação de CSV com detecção de separador e encoding, e prévia antes de confirmar.
- Mensagem de erro explicando o formato esperado com exemplo.

```html
<input name="cpf" inputmode="numeric" autocomplete="off" placeholder="000.000.000-00">
```

## Exemplo antes/depois

- Antes: campo de telefone rejeita `(11) 98765-4321` colado de um e-mail com "Use apenas números".
- Depois: aceita qualquer formato, remove caracteres não numéricos, valida 10–11 dígitos e exibe formatado como `(11) 98765-4321`.

## Anti-padrões e sinais de violação

- Erro por espaço extra no fim do e-mail.
- Máscara que bloqueia colagem ou apaga o conteúdo colado.
- Validação de nome que rejeita acentos, apóstrofos ou hífens.
- `type="number"` em CEP ou cartão, removendo zeros ou exibindo setas.
- Formatos de data diferentes em telas distintas.

## Conflitos e limites

- Tolerância não é ausência de validação: o backend continua validando estritamente após normalizar.
- Entradas ambíguas (ex.: `01/02/2025` em contexto internacional) devem ser confirmadas, não adivinhadas.
- Em segurança (senha, tokens), não normalize silenciosamente; senha deve ser tratada exatamente como digitada.
- Aceitar entrada livre não justifica armazenar dados sujos; sempre persista o formato canônico.

## Checklist de revisão

- [ ] Campos aceitam variações comuns de formato e colagem?
- [ ] Os dados são normalizados antes da validação e da persistência?
- [ ] Mensagens de erro mostram o formato esperado com exemplo?
- [ ] A saída usa formatos consistentes em toda a aplicação?
- [ ] O backend valida estritamente o valor normalizado?
