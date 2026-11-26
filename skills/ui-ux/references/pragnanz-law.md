# Lei de Prägnanz (Simplicidade Perceptual)

## Princípio

As pessoas interpretam imagens e layouts complexos na forma mais simples possível. Interfaces com formas, alinhamentos e hierarquia simples são compreendidas mais rápido; complexidade visual exige esforço para ser decodificada.

## Quando aplicar

- Telas visualmente poluídas, com muitas cores, bordas, sombras e tamanhos.
- Dashboards, landing pages e telas de entrada do produto.
- Ícones, ilustrações e gráficos.
- Revisão de consistência visual de um design system.

## Regras práticas

- Limite a escala tipográfica a poucos tamanhos (ex.: 4–6) e 2–3 pesos.
- Paleta: neutros + uma cor primária + cores semânticas (sucesso, alerta, erro, info).
- Raio de borda, sombra e espessura de borda padronizados por tokens.
- Uma hierarquia clara por tela: um título principal, seções, conteúdo.
- Prefira formas geométricas simples para ícones e indicadores.
- Gráficos: um tipo de gráfico por pergunta; remova grades, bordas e legendas desnecessárias.

## Padrões de implementação

- Tokens de design: tipografia, cores, espaçamento, raio e sombra.
- Componentes com poucas variantes bem definidas.
- Ícones de uma única biblioteca com tamanho e traço padronizados.
- Revisão visual: aplique "squint test" (desfocar a tela) para verificar se a hierarquia continua clara.

## Exemplo antes/depois

- Antes: dashboard com 8 widgets, cada um com cor de cabeçalho diferente, sombras fortes, bordas arredondadas distintas e 5 tamanhos de fonte nos títulos.
- Depois: widgets com mesmo card neutro, títulos em um único estilo, cor reservada para dados e alertas, KPIs principais maiores no topo.

## Anti-padrões e sinais de violação

- Mais de duas famílias tipográficas.
- Dezenas de tamanhos de fonte ou cores hardcoded no código.
- Combinação de bordas, sombras e fundos no mesmo elemento.
- Gráficos 3D, gradientes decorativos e efeitos que não carregam informação.
- Ao desfocar a tela, não se percebe o que é principal.

## Conflitos e limites

- Simplicidade visual não pode remover informações necessárias à tarefa nem reduzir contraste abaixo de WCAG.
- Interfaces de especialistas (trading, monitoramento) precisam de densidade; simplifique a forma, não o conteúdo.
- Marca e personalidade são legítimas; aplique-as de forma consistente em vez de variar a cada tela.

## Checklist de revisão

- [ ] A escala tipográfica e a paleta são limitadas e definidas por tokens?
- [ ] Cada elemento usa no máximo uma técnica de delimitação?
- [ ] A hierarquia continua clara ao desfocar a tela?
- [ ] Gráficos e ícones usam formas simples sem efeitos decorativos?
- [ ] A simplificação manteve informação e contraste necessários?
