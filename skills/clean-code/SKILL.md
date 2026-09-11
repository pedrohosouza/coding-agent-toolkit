---
name: clean-code
description: Regras de código limpo do projeto — simplicidade (KISS), regras de design (sem else, injeção de dependência, Lei de Deméter), compreensibilidade, funções, comentários, estrutura vertical do código, objetos vs estruturas de dados e code smells. Use SEMPRE que estiver escrevendo lógica nova, refatorando ou revisando código quanto a clareza e manutenibilidade — mesmo sem pedido explícito de "código limpo". Aplicar por padrão; ao se desviar, deixar o motivo explícito.
---

# Code Style — Clean Code

> O código é limpo quando pode ser compreendido facilmente por todos da equipe.
> Código limpo pode ser lido e aprimorado por um desenvolvedor que não seja o
> autor original. Com a compreensibilidade vêm a legibilidade, a facilidade de
> alteração, a extensibilidade e a manutenibilidade.

Estas regras orientam todo código gerado ou modificado neste projeto. Siga-as
por padrão; ao se desviar, deixe explícito o motivo.

## Regras gerais

- Siga as convenções padrão.
- **Escreva todo o código em inglês.** Nomes de variáveis, funções, classes,
   tipos, arquivos, comentários e mensagens de commit são sempre em inglês.
- Mantenha simples (KISS — Keep It Simple, Stupid). Mais simples é sempre
   melhor. Reduza a complexidade ao máximo.
- Regra do escoteiro. Deixe o acampamento mais limpo do que você o encontrou.
- Sempre encontre a causa raiz. Sempre busque a causa raiz de um problema.

## Regras de design

- Mantenha dados configuráveis em níveis altos.
- Prefira polimorfismo a longas cadeias condicionais.
- **Nunca use `else`.** `if` e `switch/case` são permitidos, mas `else` (e
   `else if`) é proibido. Use *early return* / *guard clauses* para sair cedo e
   manter o fluxo linear.
- Separe o código de multithreading.
- Evite excesso de configurabilidade.
- Use injeção de dependência.
- Siga a Lei de Deméter. Uma classe deve conhecer apenas suas dependências
   diretas.

## Dicas de compreensibilidade

- Seja consistente. Se você faz algo de uma determinada forma, faça todas as
   coisas semelhantes da mesma forma.
- Use variáveis explicativas.
- Encapsule condições de contorno. Condições de contorno são difíceis de
   acompanhar; coloque o tratamento delas em um único lugar.
- Prefira objetos de valor dedicados a tipos primitivos.
- Evite dependência lógica. Não escreva métodos que funcionem corretamente
   dependendo de outra coisa na mesma classe.
- Evite condicionais negativas.

## Regras de funções

- Pequenas.
- Façam uma única coisa.
- Usem nomes descritivos.
- Prefira menos argumentos.
- Não tenham efeitos colaterais.
- Não use argumentos de flag. Divida o método em vários métodos independentes
   que possam ser chamados pelo cliente sem a flag.

## Regras de comentários

- Sempre tente se explicar no código.
- Não seja redundante.
- Não adicione ruído óbvio.
- Não use comentários em chaves de fechamento.
- Não deixe código comentado. Apenas remova.
- Use como explicação de intenção.
- Use como esclarecimento do código.
- Use como aviso de consequências.

## Estrutura do código-fonte

- Separe conceitos verticalmente.
- Código relacionado deve aparecer verticalmente denso.
- Declare variáveis próximas ao seu uso.
- Funções dependentes devem ficar próximas.
- Funções semelhantes devem ficar próximas.
- Coloque as funções no sentido descendente.
- Mantenha as linhas curtas.
- Não use alinhamento horizontal.
- Use espaços em branco para associar coisas relacionadas e desassociar as
   fracamente relacionadas.
- Não quebre a indentação.

## Objetos e estruturas de dados

- Oculte a estrutura interna.
- Prefira estruturas de dados.
- Evite estruturas híbridas (metade objeto, metade dado).
- Devem ser pequenos.
- Devem fazer uma única coisa.
- Pequeno número de variáveis de instância.
- A classe base não deve saber nada sobre suas derivadas.
- É melhor ter muitas funções do que passar algum código para uma função
   selecionar um comportamento.
- Prefira métodos não estáticos a métodos estáticos.

## Code Smells

- **Rigidez.** O software é difícil de mudar. Uma pequena alteração causa uma
   cascata de alterações subsequentes.
- **Fragilidade.** O software quebra em vários lugares devido a uma única
   alteração.
- **Imobilidade.** Você não consegue reutilizar partes do código em outros
   projetos por causa dos riscos envolvidos e do alto esforço.
- **Complexidade desnecessária.**
- **Repetição desnecessária.**
- **Opacidade.** O código é difícil de entender.
