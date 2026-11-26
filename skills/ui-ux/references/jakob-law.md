# Lei de Jakob

## Princípio

Usuários passam a maior parte do tempo em outros produtos e esperam que o seu funcione do mesmo jeito. Seguir convenções estabelecidas reduz aprendizado; inovar em padrões básicos cobra esforço do usuário sem retorno.

## Quando aplicar

- Definição de layout, navegação, formulários, tabelas, busca, checkout e autenticação.
- Escolha de ícones, posições de ações e terminologia.
- Proposta de componente "criativo" para algo que já tem padrão consolidado.

## Regras práticas

- Logo no canto superior esquerdo leva à home/dashboard.
- Menu de usuário (perfil, configurações, sair) no canto superior direito.
- Busca global no topo; atalho `Ctrl/Cmd+K` ou `/` quando houver command palette.
- Links com aparência de link (cor + sublinhado ou hover claro); botões com aparência de botão.
- Ícones apenas com significado consolidado (lixeira = excluir, lápis = editar, engrenagem = configurações); demais ícones com rótulo de texto.
- Use componentes nativos quando possível (`<select>`, `<input type="date">`, `<dialog>`); preservam teclado e leitor de tela.
- `Esc` fecha modal, `Enter` envia formulário de um campo, clique fora fecha popover.
- Terminologia do domínio do usuário, não do banco de dados.

## Padrões de implementação

- Layout SaaS padrão: sidebar de navegação + header com busca e usuário + área de conteúdo.
- Tabelas com ordenação no cabeçalho, filtros acima, paginação abaixo, ações em massa ao selecionar linhas.
- Formulários com label acima do campo, erro abaixo, ação primária no fim.
- Breadcrumb em hierarquias com mais de dois níveis.

## Exemplo antes/depois

- Antes: app de CRM com navegação em menu radial customizado, ícone de "salvar" como disquete estilizado irreconhecível e "Sair" escondido em Configurações > Conta.
- Depois: sidebar à esquerda com rótulos, botão "Salvar" com texto, menu do avatar no canto superior direito com "Sair".

## Anti-padrões e sinais de violação

- Componentes customizados que reimplementam select/checkbox sem suporte a teclado.
- Scroll horizontal ou gestos não convencionais para navegação principal.
- Ícones sem rótulo cujo significado o usuário precisa adivinhar.
- Ações padrão em posições inesperadas (ex.: "Cancelar" com estilo primário).
- Usuários perguntando "como faço para…" em tarefas triviais.

## Conflitos e limites

- Convenções do domínio vencem convenções genéricas: um ERP pode ter padrões próprios que seus usuários já conhecem.
- Inove onde gera diferencial real (fluxo central do produto), não em navegação, formulários ou login.
- Não copie padrões ruins só porque são comuns (ex.: cancelamento escondido, checkbox de marketing pré-marcado).
- Em plataformas diferentes (web, iOS, Android), siga a convenção de cada uma.

## Checklist de revisão

- [ ] Navegação, busca e menu de usuário estão nas posições esperadas?
- [ ] Ícones sem texto são universalmente reconhecíveis?
- [ ] Componentes customizados mantêm comportamento nativo (teclado, foco, `Esc`)?
- [ ] A terminologia é a do usuário?
- [ ] Alguma inovação de padrão básico exige explicação? Se sim, foi justificada?
