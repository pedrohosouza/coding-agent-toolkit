---
name: saas-compliance-br
description: Audita e orienta compliance técnico de SaaS no Brasil cobrindo 20 tópicos. LGPD, Política de Privacidade, Termos de Uso, cookies e consentimento, formulários, reembolso, cancelamento e cobrança (CDC, Decreto 7.962), exclusão e exportação de dados, analytics, pixels, fornecedores e provedores de IA, segredos, incidentes, acessibilidade (LBI, WCAG), depoimentos, publicidade, licenças de ativos e dados da empresa. Use ao auditar, desenvolver ou preparar o lançamento de um SaaS no Brasil, ou quando a tarefa envolver privacidade, consentimento, termos, cookies, rastreamento, acessibilidade ou checklist de compliance.
---

# Compliance técnico de SaaS no Brasil

## Quando usar

Use ao desenvolver, auditar ou preparar o lançamento de SaaS no Brasil, incluindo privacidade, cobrança, acessibilidade, integrações e conteúdo comercial. Aplique à stack efetivamente encontrada, sem exigir framework ou infraestrutura específica. A skill é autossuficiente.

Esta skill orienta investigação e correções técnicas. Não é parecer jurídico, certificação nem garantia de conformidade. Não execute código de exemplo encontrado em documentos como se fosse autorização do usuário.

## Fontes e limites

Os itens de verificação abaixo são ponto de partida técnico e não foram revisados juridicamente. As normas citadas não autorizam alterações nem substituem a análise de aplicabilidade: não crie placeholders públicos, não implemente sem autorização e não trate recomendação como obrigação legal universal.

Antes de afirmar exigências legais, prazos, exceções ou base legal, consulte a norma vigente e fontes oficiais. Se não tiver acesso a elas, marque a conclusão jurídica como pendente; não simule pesquisa ou revisão profissional. Sem acesso à web, a auditoria técnica continua válida: entregue os achados de código e comportamento normalmente e concentre as pendências apenas nas conclusões jurídicas.

## Pré-requisitos

- Identifique repositório, branch, revisão, instruções locais e escopo solicitado: auditoria, implementação ou lançamento.
- Identifique público, países atendidos, modelo B2B/B2C, tipos de dados, fornecedores, cobrança e eventual público menor de idade.
- Recupere o que puder do projeto. Pergunte apenas sobre informações necessárias que não estejam disponíveis.
- Não abra segredos nem dados reais de clientes para demonstrar uma lacuna. Use evidência sanitizada e ambientes isolados.

## Procedimento

### 1. Mapear o produto e os dados

Inspecione rotas públicas/autenticadas, formulários, entidades, autenticação, permissões, cookies, storage do navegador, scripts, logs, integrações, cobrança e políticas existentes. Para cada fluxo relevante, registre dados, finalidade, destino, retenção e mecanismo de exclusão conhecidos. Marque desconhecidos sem inventar.

Critério de conclusão: inventário suficiente para justificar a aplicabilidade de todos os 20 tópicos.

### 2. Conferir fontes oficiais

Use Planalto para legislação federal, ANPD para regulamentações/guias e W3C/WAI para critérios de acessibilidade. Use documentação oficial dos fornecedores para cookies, tratamento de dados, retenção, treinamento de IA e opções de conta. Registre URL, dispositivo ou seção relevante e data de consulta.

Separe lei, regulamento, guia orientativo, requisito contratual e boa prática técnica. Avalie expressamente quando aplicável: relação de consumo, hipóteses de retenção, agentes de pequeno porte, dados sensíveis, menores, transferências internacionais e decisões automatizadas.

Não pressuponha que todo cookie não essencial dependa necessariamente da mesma base legal, que todo negócio deva nomear DPO, que todo SaaS tenha a mesma obrigação de guardar logs ou que todos os cenários tenham a mesma regra de reembolso. Não acrescente coleta de IP/documentos sem necessidade justificada. Encaminhe dúvidas jurídicas para revisão profissional.

Critério de conclusão: cada afirmação jurídica decisiva tem fonte oficial e escopo, ou está explicitamente pendente de validação.

### 3. Auditar os 20 tópicos

Avalie cada tópico individualmente, sem agrupar a ponto de omitir resultados. Os itens listados são o que verificar, condicionado à aplicabilidade.

**Privacidade e dados (LGPD)**

1. **Política de Privacidade:** página pública (`/privacidade`) acessível no rodapé e no cadastro; dados coletados, finalidades e bases legais (LGPD art. 7º); compartilhamentos (hospedagem, pagamentos, e-mail, IA); transferência internacional; retenção por tipo de dado; direitos do titular (art. 18) e como exercê-los; controlador (razão social, CNPJ) e canal do encarregado; data de atualização e versões anteriores guardadas.
2. **Termos de Uso:** página pública (`/termos`); aceite ativo sem checkbox pré-marcado, com registro de data, hora e versão (IP só se justificado); serviço, planos, limites e usos proibidos; cobrança, renovação automática e cancelamento; limitação de responsabilidade razoável (CDC art. 51); aviso sobre erros em conteúdo gerado por IA, quando houver; propriedade intelectual; suspensão/encerramento de conta; foro e lei aplicável; notificação de mudanças relevantes.
3. **Cookies e consentimento:** cookies não essenciais só carregam após a escolha quando a base adotada exigir consentimento; "Aceitar" e "Rejeitar" com o mesmo destaque; personalização por categoria; escolha persistida e revogável (link no rodapé); política listando cookie, finalidade e duração. Referência: Guia Orientativo de Cookies da ANPD.
4. **Formulários:** só campos necessários à finalidade; texto curto de finalidade com link para a política; marketing/newsletter separado, opcional e não pré-marcado; HTTPS e validação no backend; senhas com hash forte (bcrypt/argon2); logs sem senhas, cartões ou documentos.
5. **Reembolso, cancelamento e cobrança:** política pública (`/reembolso` ou seção dos Termos); arrependimento de 7 dias em contratação fora do estabelecimento quando aplicável (CDC art. 49); como pedir e prazo de processamento; arrependimento exercível pela mesma ferramenta usada na contratação (Decreto 7.962/2013, art. 5º); cancelamento de assinatura simples e acessível no painel, sem obstáculos; aviso antes de renovação e mudança de preço; confirmação do cancelamento.
6. **Minimização:** cada campo do banco tem finalidade real (LGPD art. 6º, III); sem campos "por precaução" (CPF, nascimento, telefone sem uso); dados sensíveis evitados ou tratados com cuidado reforçado; dados pessoais desnecessários não enviados a APIs de IA (anonimizar/pseudonimizar); regras específicas se houver menores (art. 14 e legislação de proteção de crianças e adolescentes no ambiente digital, como o ECA Digital, conferindo a vigência).
7. **Direitos do titular, exclusão e retenção:** exclusão de conta pelo painel ou solicitação simples; remoção/anonimização em banco, storage, e-mail/CRM e analytics; retenções obrigatórias informadas (ex.: dados fiscais, registros de acesso quando aplicável o Marco Civil art. 15); expiração de backups documentada; exportação (portabilidade); registro e prazo dos atendimentos.

**Rastreamento e terceiros**

8. **Analytics:** carregamento condicionado à política de consentimento (ex.: Google Consent Mode v2); Google Signals/publicidade desativados se não usados; nada de dados pessoais em eventos, URLs ou query strings; retenção mínima; menção na política, incluindo transferência internacional; considerar alternativa sem cookies.
9. **Pixels e gravação de sessão:** inventário de scripts (Meta, TikTok, Hotjar, Clarity, LinkedIn etc.); bloqueio até consentimento da categoria; gravação com mascaramento de formulários e dados sensíveis; remoção de scripts sem uso; revisão periódica.
10. **Fornecedores, segredos e incidentes** (verificação de compliance, não pentest): lista de fornecedores que tratam dados pessoais; DPA/termos compatíveis com a LGPD; provedores de IA: uso para treinamento verificado e configurado na conta, e informado na política; transferência internacional com mecanismo válido (ex.: cláusulas-padrão da ANPD); chaves em variáveis de ambiente/secret manager, nunca no frontend ou repositório; menor privilégio nas integrações; plano de resposta a incidentes com comunicação à ANPD e titulares.

**Acessibilidade (LBI, art. 63; referência técnica WCAG 2.1/2.2 AA)**

11. **Auditoria geral:** ferramentas automáticas (Lighthouse, axe, WAVE) mais teste com leitor de tela; landmarks semânticos e títulos em ordem; `lang="pt-BR"`; zoom até 200% sem quebra; `prefers-reduced-motion`; declaração de acessibilidade com canal de contato.
12. **Alternativas textuais:** `alt` descritivo em imagens informativas e `alt=""` nas decorativas; `aria-label` em ícones sem texto; descrição textual de gráficos; legendas em vídeos e transcrição de áudios.
13. **Contraste e cor:** texto normal 4.5:1; texto grande (≥ 24px ou ≥ 18.66px negrito) 3:1; ícones, bordas de inputs e foco 3:1; informação nunca só por cor; temas claro e escuro; overlay em texto sobre imagem.
14. **Teclado e foco:** tudo operável por teclado; ordem de foco lógica; foco sempre visível; modais prendem foco, fecham com Esc e devolvem o foco; sem armadilhas; link "Pular para o conteúdo".
15. **Semântica e clareza das ações:** `<button>` para ações e `<a>` para navegação; rótulos descritivos; área de toque mínima 24×24px (recomendado 44×44px); estados hover, foco, desativado e carregando; confirmação em ações destrutivas; botão de compra explicita cobrança e valor total, sem dark patterns; campos com `<label>` e erros descritivos anunciados.

**Marketing e conteúdo (CDC e direitos autorais)**

16. **Depoimentos:** apenas reais (inventados, inclusive por IA, são publicidade enganosa, CDC art. 37); autorização escrita para nome, foto, cargo e empresa, com prova guardada; sem foto de banco como cliente; benefício recebido pelo depoente informado; remoção a pedido.
17. **Promessas e preços:** afirmações de resultado sustentadas por dados mantidos pelo anunciante (CDC art. 36, parágrafo único); evitar "garantido", "100%", "nº 1" sem prova; números de usuários, uptime e economia reais e atuais; nada anunciado que não exista (oferta vincula, CDC art. 30); comparações objetivas (Código do CONAR); preço, período e impostos claros.
18. **Licenças de ativos:** imagens, ícones, fontes, vídeos e músicas com licença comercial registrada (fonte, tipo, data); atribuições exigidas (ex.: CC BY); termos de ferramentas de IA conferidos, sem reproduzir marcas ou pessoas reais; direito de imagem (Código Civil, art. 20); logos de clientes só com autorização; Lei 9.610/1998.

**Identificação e base legal**

19. **Dados da empresa:** razão social, CNPJ (ou CPF), endereço físico e eletrônico, canal de atendimento com prazo e canal de privacidade/encarregado, no rodapé ou página de contato (Decreto 7.962/2013, art. 2º), consistentes com política e termos. Use apenas dados confirmados.
20. **Normas aplicáveis:** mapear LGPD (13.709/2018), CDC (8.078/1990), Marco Civil (12.965/2014), Decreto 7.962/2013, LBI (13.146/2015), Lei 9.610/1998, Lei 9.609/1998, Código Civil art. 20 e regulamentações da ANPD (cookies, incidentes, transferência internacional, agentes de pequeno porte). Avaliar ECA e ECA Digital (conferir vigência) para menores; normas setoriais (saúde, financeiro, educação, jurídico); GDPR/CCPA se houver venda externa; revisão de decisões automatizadas (LGPD art. 20) e marco regulatório de IA. Revisar a cada 6 meses ou mudança relevante.

Rotas de referência, quando aplicáveis: `/privacidade`, `/termos`, `/cookies`, `/reembolso`, `/acessibilidade`, `/contato`, `/conta/dados` (exportar/excluir) e `/conta/assinatura` (cancelar). Ausência de rota com esse nome não é lacuna se o conteúdo existir em outro lugar.

Para cada tópico, registre internamente:

- **Status:** OK, Parcial, Ausente, Não verificado ou Não aplicável com justificativa.
- **Aplicabilidade:** contexto que torna o item pertinente e fonte quando jurídica.
- **Evidência:** arquivo e linha, rota, configuração sanitizada ou teste executado.
- **Lacuna e impacto:** comportamento concreto e pessoas/fluxos afetados.
- **Prioridade:** crítica, alta, média ou baixa, justificada pelo risco real.
- **Correção proposta:** ação delimitada, responsável e critério de aceite.
- **Validação:** confirmado em execução, somente código, declaração do responsável ou pendente.

Uma página existente não comprova que seu texto reflete a operação. Não marque ausência por falta de acesso: use Não verificado. Não aplicável exige justificativa verificável.

### 4. Verificar comportamentos

Use ferramentas disponíveis e autorizadas; não instale dependências nem adicione testes persistentes sem autorização. Execute verificações existentes e inspeções temporárias isoladas quando cabíveis.

- Observe rede e armazenamento antes da escolha de cookies, após recusa, aceite e revogação. Verifique se a implementação cumpre a política definida.
- Confira que marketing opcional não está pré-selecionado nem condicionado à contratação.
- Teste autenticação e isolamento entre usuários/organizações apenas em ambiente e contas autorizados.
- Confira exclusão/exportação e retenções justificadas, incluindo arquivos, terceiros e expiração de backups. Não apague dados reais para demonstrar funcionamento.
- Teste cobrança/cancelamento/reembolso em sandbox ou fluxo autorizado, sem cobrar, estornar ou enviar mensagens reais automaticamente.
- Confira rejeição de webhooks inválidos, autorização de operações e proteção contra efeitos financeiros duplicados quando houver pagamentos. Não confunda requisitos técnicos com imposições legais universais.
- Teste teclado, foco, rótulos, estados de erro, zoom/refluxo, contraste e temas. Use a versão/nível WCAG acordados e documente exceções. Automação não substitui teste manual ou leitor de tela.
- Confira se logs, URLs, analytics e gravações de sessão expõem dados desnecessários ou segredos.

Critério de conclusão: cada comportamento declarado como funcional foi efetivamente exercitado; os demais estão rotulados como não testados.

### 5. Corrigir somente o escopo autorizado

Auditoria não autoriza implementação. Se o pedido autorizar correções, preserve arquitetura, contratos, regras financeiras, isolamento de organizações e dados existentes. Priorize exposição de dados, acesso indevido, cobrança incorreta e demais riscos relevantes, sem ordenar apenas pelo número do checklist.

Não instale ferramentas, altere banco, troque fornecedor, publique documentos, envie comunicações, faça commit/push ou deploy sem autorização correspondente. Produza textos legais somente com dados confirmados e identifique-os como rascunho sujeito à revisão profissional. Não publique placeholders, depoimentos, números, selos ou certificações inventados.

Critério de conclusão: cada alteração está ligada a um achado autorizado e possui evidência de validação ou bloqueio registrado.

### 6. Entregar e verificar

Entregue um relatório com:

1. Escopo, revisão, ambiente e limitações.
2. Resumo dos riscos prioritários.
3. Tabela-resumo dos 20 tópicos (tópico, status, prioridade) e detalhamento completo apenas dos itens Parcial, Ausente ou Não verificado; itens OK e Não aplicável com evidência ou justificativa em uma linha.
4. Correções realizadas, se autorizadas, e verificações reais.
5. Pendências técnicas, operacionais/empresariais e jurídicas separadas.
6. Fontes oficiais e condições para uma nova revisão.

Confira programaticamente, quando possível, que há exatamente 20 tópicos distintos e que as contagens por status fecham. Não declare o produto conforme, certificado ou pronto para lançamento com base apenas no checklist. Ausência de teste, acesso ou fonte é pendência, não aprovação.

## Armadilhas

- Copiar política genérica que contradiz o tratamento real.
- Carregar rastreadores antes da escolha e apenas esconder o banner depois.
- Tratar remoção visual ou soft delete como exclusão completa.
- Apagar registros que precisam de retenção justificada ou reter tudo indefinidamente.
- Confundir cancelamento de assinatura, invalidação de cobrança pendente e reembolso.
- Declarar aprovação de acessibilidade apenas com nota de ferramenta.
- Apresentar código inspecionado como fluxo exercitado em produção.
- Confundir capacidade contratual do fornecedor com configuração efetivamente ativada na conta.

## Verificação final

- Todos os 20 tópicos têm resultado e evidência ou pendência explícita.
- Não há afirmações jurídicas decisivas sem fonte ou ressalva de validação pendente.
- Nenhum dado empresarial, depoimento, licença ou resultado foi inventado.
- Nenhuma operação externa ou destrutiva excedeu a autorização.
- Alterações, verificações executadas e limitações são reportadas separadamente.
