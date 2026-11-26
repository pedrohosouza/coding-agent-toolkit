# Navalha de Occam

## Princípio

Entre soluções que resolvem o problema igualmente bem, prefira a que tem menos elementos, suposições e conceitos. Cada componente, opção ou tela adicional precisa justificar seu custo cognitivo e de manutenção.

## Quando aplicar

- Telas com elementos decorativos, textos redundantes ou recursos pouco usados.
- Escolha entre um modal, uma página nova ou uma edição inline.
- Introdução de novos conceitos no produto (tipos, status, papéis).
- Revisão de componentes duplicados ou variações desnecessárias.

## Regras práticas

- Para cada elemento, pergunte: se remover, o usuário perde algo? Se não, remova.
- Não repita a mesma informação em título, subtítulo e texto auxiliar.
- Prefira edição inline a modal para mudanças de um campo; modal a página nova para tarefas curtas; página para tarefas longas.
- Evite novos conceitos no domínio quando um existente resolve (ex.: "tag" em vez de "categoria" + "rótulo" + "grupo").
- Use uma variante de componente por propósito; não crie botões quase iguais.
- Textos de ajuda só onde há dúvida real, não em todo campo.

## Padrões de implementação

- Edição inline com salvar ao `blur` ou `Enter` e `Esc` para cancelar.
- Empty states com uma ação clara em vez de páginas tutoriais longas.
- Design system com conjunto mínimo de variantes (primário, secundário, ghost, perigo).
- Remoção de colunas, filtros e widgets sem uso real.

## Exemplo antes/depois

- Antes: renomear um projeto abre modal com título "Editar projeto", subtítulo "Altere as informações do seu projeto", campo "Nome do projeto" com ajuda "Digite o nome do projeto" e botões "Cancelar", "Redefinir" e "Salvar".
- Depois: clique no nome do projeto torna-o editável inline; `Enter` salva, `Esc` cancela; toast discreto confirma.

## Anti-padrões e sinais de violação

- Textos de ajuda que repetem o label.
- Ícones, ilustrações ou badges sem função.
- Três maneiras diferentes de fazer a mesma ação sem motivo.
- Modal de confirmação para ações reversíveis.
- Conceitos novos que usuários confundem com existentes.

## Conflitos e limites

- Com Tesler: simplicidade visual não deve remover capacidade necessária e empurrar trabalho ao usuário.
- Com acessibilidade: não remova labels visíveis, textos alternativos ou foco visível em nome de "limpeza".
- Com Jakob: às vezes o padrão familiar tem mais elementos, mas é mais simples de entender que uma solução minimalista nova.
- Simplicidade não é ausência de feedback; estados de loading, erro e sucesso continuam obrigatórios.

## Checklist de revisão

- [ ] Todo elemento visível tem função clara?
- [ ] Não há texto redundante entre título, descrição e ajuda?
- [ ] O padrão de interação (inline, modal, página) é o mais leve que resolve?
- [ ] Nenhum conceito novo foi criado sem necessidade?
- [ ] A simplificação preservou acessibilidade e capacidade?
