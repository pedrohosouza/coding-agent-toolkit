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

1. Siga as convenções padrão.
2. **Escreva todo o código em inglês.** Nomes de variáveis, funções, classes,
   tipos, arquivos, comentários e mensagens de commit são sempre em inglês.
3. Mantenha simples (KISS — Keep It Simple, Stupid). Mais simples é sempre
   melhor. Reduza a complexidade ao máximo.
4. Regra do escoteiro. Deixe o acampamento mais limpo do que você o encontrou.
5. Sempre encontre a causa raiz. Sempre busque a causa raiz de um problema.

## Regras de design

1. Mantenha dados configuráveis em níveis altos.
2. Prefira polimorfismo a longas cadeias condicionais.
3. **Nunca use `else`.** `if` e `switch/case` são permitidos, mas `else` (e
   `else if`) é proibido. Use *early return* / *guard clauses* para sair cedo e
   manter o fluxo linear.
4. Separe o código de multithreading.
5. Evite excesso de configurabilidade.
6. Use injeção de dependência.
7. Siga a Lei de Deméter. Uma classe deve conhecer apenas suas dependências
   diretas.

## Dicas de compreensibilidade

1. Seja consistente. Se você faz algo de uma determinada forma, faça todas as
   coisas semelhantes da mesma forma.
2. Use variáveis explicativas.
3. Encapsule condições de contorno. Condições de contorno são difíceis de
   acompanhar; coloque o tratamento delas em um único lugar.
4. Prefira objetos de valor dedicados a tipos primitivos.
5. Evite dependência lógica. Não escreva métodos que funcionem corretamente
   dependendo de outra coisa na mesma classe.
6. Evite condicionais negativas.

## Regras de funções

1. Pequenas.
2. Façam uma única coisa.
3. Usem nomes descritivos.
4. Prefira menos argumentos.
5. Não tenham efeitos colaterais.
6. Não use argumentos de flag. Divida o método em vários métodos independentes
   que possam ser chamados pelo cliente sem a flag.

## Regras de comentários

1. Sempre tente se explicar no código.
2. Não seja redundante.
3. Não adicione ruído óbvio.
4. Não use comentários em chaves de fechamento.
5. Não deixe código comentado. Apenas remova.
6. Use como explicação de intenção.
7. Use como esclarecimento do código.
8. Use como aviso de consequências.

## Estrutura do código-fonte

1. Separe conceitos verticalmente.
2. Código relacionado deve aparecer verticalmente denso.
3. Declare variáveis próximas ao seu uso.
4. Funções dependentes devem ficar próximas.
5. Funções semelhantes devem ficar próximas.
6. Coloque as funções no sentido descendente.
7. Mantenha as linhas curtas.
8. Não use alinhamento horizontal.
9. Use espaços em branco para associar coisas relacionadas e desassociar as
   fracamente relacionadas.
10. Não quebre a indentação.

## Objetos e estruturas de dados

1. Oculte a estrutura interna.
2. Prefira estruturas de dados.
3. Evite estruturas híbridas (metade objeto, metade dado).
4. Devem ser pequenos.
5. Devem fazer uma única coisa.
6. Pequeno número de variáveis de instância.
7. A classe base não deve saber nada sobre suas derivadas.
8. É melhor ter muitas funções do que passar algum código para uma função
   selecionar um comportamento.
9. Prefira métodos não estáticos a métodos estáticos.

## Code Smells

1. **Rigidez.** O software é difícil de mudar. Uma pequena alteração causa uma
   cascata de alterações subsequentes.
2. **Fragilidade.** O software quebra em vários lugares devido a uma única
   alteração.
3. **Imobilidade.** Você não consegue reutilizar partes do código em outros
   projetos por causa dos riscos envolvidos e do alto esforço.
4. **Complexidade desnecessária.**
5. **Repetição desnecessária.**
6. **Opacidade.** O código é difícil de entender.