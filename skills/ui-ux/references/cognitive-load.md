# Carga Cognitiva

## Princípio

Carga cognitiva é o esforço mental necessário para usar a interface. Parte é intrínseca à tarefa; parte é extrínseca, criada pelo design (ruído, inconsistência, ambiguidade). O objetivo é eliminar a carga extrínseca e apoiar a intrínseca.

## Quando aplicar

- Telas densas, formulários complexos, dashboards e configurações.
- Usuários cometendo erros, pedindo ajuda ou demorando em tarefas simples.
- Fluxos que exigem decisões técnicas ou conhecimento que o usuário não tem.

## Regras práticas

- Uma tarefa principal por tela; tarefas secundárias em painéis, abas ou etapas.
- Linguagem do usuário, frases curtas, verbos de ação em botões ("Salvar alterações", não "OK").
- Reconhecer em vez de lembrar: mostre opções, histórico e valores atuais em vez de exigir memória.
- Labels sempre visíveis; placeholder não substitui label.
- Mensagens de erro específicas, próximas ao campo, com como corrigir.
- Remova elementos decorativos, textos redundantes e alertas não acionáveis.
- Consistência: mesmo termo, ícone e posição para a mesma coisa em todo o produto.

## Padrões de implementação

- Divulgação progressiva (accordion, "Mostrar mais", etapas).
- Defaults e valores sugeridos.
- Ajuda contextual (tooltip ou texto auxiliar curto) apenas onde há dúvida real.
- Visualização prévia do resultado antes de confirmar (ex.: prévia de e-mail, de importação).
- Validação inline após o campo perder foco.

```html
<label for="due">Vencimento</label>
<input id="due" type="date" aria-describedby="due-help">
<p id="due-help">Data em que o cliente deve pagar.</p>
```

## Exemplo antes/depois

- Antes: tela de criação de automação mostra todos os gatilhos, condições e ações com termos técnicos ("webhook payload", "cron expression") ao mesmo tempo.
- Depois: frase guiada "Quando [gatilho] acontecer, se [condição], então [ação]"; cada parte abre opções em linguagem simples; agendamento com seletor visual em vez de cron.

## Anti-padrões e sinais de violação

- Placeholder usado como label.
- Jargão técnico ou interno na interface.
- Muitos alertas, banners e tooltips ao mesmo tempo.
- Inconsistência de termos ("cliente", "conta", "contato" para a mesma entidade).
- Usuário precisa consultar documentação para tarefas comuns.

## Conflitos e limites

- Reduzir carga não é esconder tudo: excesso de cliques e telas também cansa; equilibre com Fitts e Hick.
- Especialistas toleram mais densidade; ofereça atalhos e modos avançados sem impor a novatos.
- Acessibilidade cognitiva (WCAG 3.3.x) exige instruções claras e prevenção de erros; não remova ajudas necessárias.

## Checklist de revisão

- [ ] Cada tela tem uma tarefa principal clara?
- [ ] Labels são visíveis e a linguagem é a do usuário?
- [ ] O usuário reconhece em vez de lembrar?
- [ ] Erros são específicos e indicam a correção?
- [ ] Termos, ícones e posições são consistentes?
