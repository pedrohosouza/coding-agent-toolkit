# Modelo Mental

## Princípio

Usuários agem com base no que acreditam sobre como o sistema funciona, formado por experiências anteriores e pelo domínio em que trabalham. Quando o modelo da interface diverge do modelo do usuário, surgem erros, desconfiança e retrabalho.

## Quando aplicar

- Nomenclatura de entidades, menus e ações.
- Estrutura de navegação e organização de informações.
- Ações com efeitos não óbvios (excluir, arquivar, sincronizar, publicar, compartilhar).
- Usuários reportando "fiz X e aconteceu Y que eu não esperava".

## Regras práticas

- Use os termos do usuário e do domínio, não os do banco de dados ou da arquitetura ("Clientes", não "Entities").
- Organize a navegação pelas tarefas do usuário, não pela estrutura técnica do sistema.
- Explicite efeitos de ações: "Arquivar (pode ser restaurado)" vs. "Excluir permanentemente".
- Estados do sistema sempre visíveis: rascunho/publicado, sincronizado/pendente, salvo/não salvo.
- Metáforas familiares só se coerentes até o fim (pasta, lixeira, carrinho).
- Escopo claro de ações em contextos múltiplos: em qual organização, projeto ou conta a ação acontece.
- Confirme ações com consequências que o usuário pode não prever, descrevendo o impacto.

## Padrões de implementação

- Indicadores de status (badges) e de salvamento ("Alterações não salvas").
- Seletor de organização/workspace visível no header.
- Confirmação com descrição do impacto ("3 faturas vinculadas também serão canceladas").
- Prévia antes de publicar, enviar ou importar.
- Undo para ações reversíveis em vez de confirmação.

## Exemplo antes/depois

- Antes: botão "Remover" em um membro da equipe que, na verdade, exclui o usuário de todas as organizações; termo "Workspace" no menu e "Tenant" nas mensagens de erro.
- Depois: "Remover desta organização" com modal "Ana perderá acesso aos projetos desta organização. A conta dela não será excluída."; termo "Organização" em toda a interface.

## Anti-padrões e sinais de violação

- Termos técnicos ou internos expostos ao usuário.
- Mesma entidade com nomes diferentes em telas diferentes.
- Ação com efeito colateral não informado.
- Usuário sem saber se as alterações foram salvas.
- Navegação espelhando módulos do backend em vez de tarefas.

## Conflitos e limites

- Modelos mentais variam entre perfis (novato vs. especialista, operador vs. gestor); pesquise e priorize o público principal.
- Alinhar ao modelo mental não significa reproduzir processos ineficientes; melhore o processo e explique a diferença.
- Com Jakob: padrões de mercado formam modelos mentais; divergir exige motivo forte e comunicação clara.
- Não explore expectativas do usuário para induzir ações (ex.: botão "Continuar" que assina um plano).

## Checklist de revisão

- [ ] Os termos da interface são os do usuário e consistentes em todas as telas?
- [ ] A navegação reflete tarefas, não a arquitetura técnica?
- [ ] Efeitos e escopo de cada ação importante estão explícitos?
- [ ] O estado do sistema (salvo, publicado, sincronizado) é visível?
- [ ] Ações com consequências imprevistas têm confirmação descritiva ou undo?
