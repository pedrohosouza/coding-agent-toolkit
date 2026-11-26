# Regra do Pico-Fim

## Princípio

As pessoas avaliam uma experiência principalmente pelo seu momento mais intenso (pico, positivo ou negativo) e pelo final, não pela média de todos os momentos. Projete bem os pontos altos, os momentos de frustração e o encerramento dos fluxos.

## Quando aplicar

- Final de fluxos importantes: cadastro, compra, pagamento, envio, importação, publicação.
- Momentos de erro, falha de pagamento, perda de dados ou espera longa.
- Primeira conquista do usuário no produto (primeiro projeto criado, primeira venda).
- Cancelamento e offboarding.

## Regras práticas

- Todo fluxo termina com confirmação clara: o que aconteceu, dados relevantes (número, valor, data) e próximo passo.
- Erros críticos têm mensagem humana, causa, solução e preservação do que foi digitado.
- Celebre conquistas reais de forma proporcional (mensagem, ilustração discreta); evite celebrar ações triviais.
- Cancelamento: simples, sem culpa, com confirmação e informação de acesso a dados.
- Esperas longas: comunicação de progresso e opção de ser notificado ao final.

## Padrões de implementação

- Tela ou estado de sucesso com resumo e CTAs ("Ver pedido", "Criar outro").
- Página de erro com ação de recuperação ("Tentar novamente", "Falar com suporte") e ID para suporte.
- Empty state pós-conclusão ("Tudo em dia!") em vez de lista vazia sem contexto.
- Toast de sucesso com ação de desfazer para operações reversíveis.

## Exemplo antes/depois

- Antes: após pagar a assinatura, usuário é redirecionado à página de faturas sem mensagem; falha de cartão mostra "Erro 402" e limpa o formulário.
- Depois: tela "Assinatura ativada" com plano, valor, próxima cobrança e botão "Ir para o painel"; falha mostra "Seu cartão foi recusado pelo banco. Verifique os dados ou use outro cartão", mantendo os campos preenchidos.

## Anti-padrões e sinais de violação

- Fluxo que termina sem confirmação ou com redirecionamento silencioso.
- Mensagens de erro técnicas ou que culpam o usuário.
- Perda de dados digitados após erro.
- Animações comemorativas em toda ação, banalizando o pico.
- Cancelamento com várias telas de retenção e culpa.

## Conflitos e limites

- Um bom final não compensa um fluxo quebrado; corrija primeiro os picos negativos.
- Animações de celebração devem respeitar `prefers-reduced-motion` e não bloquear o próximo passo.
- Não manipule o final para esconder problemas (ex.: mensagem de sucesso quando a operação ficou pendente).
- Confirmações devem ser anunciadas a leitores de tela (`role="status"` ou foco no título de sucesso).

## Checklist de revisão

- [ ] Todo fluxo importante termina com confirmação e próximo passo?
- [ ] Os piores momentos (erros, falhas) foram tratados com mensagem e recuperação?
- [ ] Dados digitados são preservados após erro?
- [ ] Celebrações são proporcionais e não bloqueiam?
- [ ] O estado final reflete fielmente o resultado real?
