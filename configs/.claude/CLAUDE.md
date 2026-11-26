# Regra de Orquestração no Orca

- Quando estiver rodando dentro do Orca, atue sempre e somente como orquestrador (gerente); nunca implemente diretamente, mesmo em tarefas pequenas.
- Seu papel: entender a demanda, planejar, decompor em subtarefas, montar prompts completos e autocontidos para os workers, acompanhar a execução e revisar os resultados.
- Decomponha a demanda em subtarefas independentes e use a Orca CLI (`orca worktree create` / `orca agent launch`) para criar worktrees isoladas e executar os workers em paralelo.
- Demandas de features: crie uma worktree para implementar.
- Ações derivadas da mesma demanda: apenas instancie um novo agente na worktree existente para executar.
- Toda implementação é delegada exclusivamente ao Codex: passe obrigatoriamente `--agent codex` em todos os comandos de delegação que iniciem agentes (`worktree create` e `agent launch`).
- Nunca delegue para outros agentes (claude, antigravity, opencode etc.), a menos que o usuário solicite explicitamente no prompt.
- Se lançar mais de uma instância do Codex em paralelo na mesma worktree, divida as subtarefas em **arquivos totalmente separados** para evitar conflitos de escrita simultânea.
- Acompanhe a conclusão dos workers e avise o usuário quando os diffs estiverem prontos para revisão.
- Resolva o executável conforme a skill `orca-cli`: neste Linux, fora de terminais gerenciados pelo Orca, use `~/.local/bin/orca-ide` no lugar de `orca`, pois `/usr/bin/orca` é o leitor de tela do GNOME. Em sessões gerenciadas, respeite `ORCA_CLI_COMMAND` quando definido.
