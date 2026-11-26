# Limiar de Doherty

## Princípio

A produtividade e o engajamento aumentam quando o sistema responde em menos de ~400 ms. Quando a operação real é mais lenta, a interface deve responder imediatamente com feedback e manter a percepção de progresso.

## Quando aplicar

- Cliques, envios de formulário, filtros, buscas, uploads e qualquer chamada de rede.
- Telas que carregam dados de API, relatórios pesados, exportações.
- Usuários clicando duas vezes no mesmo botão ou achando que "nada aconteceu".

## Regras práticas

- Até 0,1 s: percebido como instantâneo; feedback visual direto (estado pressionado, toggle) sem indicador de carga.
- Até 1 s: o fluxo de pensamento se mantém; mostre estado de loading no próprio elemento (botão com spinner, desabilitado).
- Até 10 s: limite de atenção; use skeleton ou barra de progresso e mantenha a UI responsiva.
- Acima de 10 s: progresso determinado (percentual ou etapas), possibilidade de cancelar, ou processamento em segundo plano com notificação ao concluir.
- Evite flash de spinner: só exiba indicador após ~300 ms; se exibir, mantenha por tempo mínimo para não piscar.
- Feedback de interação (hover, active, focus) sempre imediato, independente da rede.

## Padrões de implementação

- UI otimista: aplique a mudança localmente, envie em segundo plano, reverta com mensagem em caso de erro.
- Skeletons com a forma do conteúdo final, evitando layout shift.
- Debounce de ~200–300 ms em buscas enquanto digita; cancele requisições obsoletas.
- Prefetch de dados no hover/foco de links prováveis.
- Paginação ou virtualização para listas grandes.
- Jobs longos (exportação, importação) assíncronos com status e notificação.

```html
<button type="submit" :disabled="pending" aria-busy="true">
  <span class="spinner" aria-hidden="true"></span> Salvando…
</button>
```

## Exemplo antes/depois

- Antes: marcar tarefa como concluída espera a resposta da API (~1,5 s) sem feedback; usuário clica de novo e reabre a tarefa.
- Depois: checkbox marca instantaneamente (UI otimista), item vai para "Concluídas"; em erro, volta ao estado anterior com toast "Não foi possível concluir. Tentar novamente".

## Anti-padrões e sinais de violação

- Botão sem estado de loading que permite múltiplos envios.
- Tela em branco enquanto dados carregam.
- Spinner global bloqueando a página inteira para ação local.
- Exportação síncrona que trava a interface por dezenas de segundos.
- Layout que "pula" quando o conteúdo chega.

## Conflitos e limites

- UI otimista não serve para operações irreversíveis ou financeiras (pagamento, exclusão definitiva): aguarde confirmação do servidor.
- Animações para "parecer rápido" não podem atrasar a interação; respeite `prefers-reduced-motion`.
- Atrasos artificiais para "parecer trabalho sério" só são aceitáveis se não prejudicarem a tarefa; prefira velocidade real.
- Anuncie mudanças de estado assíncronas a leitores de tela (`aria-live`).

## Checklist de revisão

- [ ] Toda ação dá feedback visual em até 100 ms?
- [ ] Operações de 1–10 s têm loading local ou skeleton?
- [ ] Operações longas têm progresso, cancelamento ou execução em segundo plano?
- [ ] Botões de envio evitam duplo clique?
- [ ] Erros em UI otimista revertem o estado e informam o usuário?
