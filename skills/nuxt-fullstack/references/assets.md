# Imagens, vídeos e assets

## Regras

- Imagens usam apenas WebP (`.webp`).
- Vídeos usam apenas WebM (`.webm`).
- Não use PNG, JPEG, GIF, AVIF, MP4 ou outros formatos; converta antes de adicionar ao projeto.
- Exceção: ícones e logos vetoriais podem ser SVG.
- Comprima vídeos e imagens.
- Use lazy loading para mídia abaixo da dobra (`loading="lazy"`); imagens acima da dobra carregam direto para não prejudicar o LCP.
- Assets estáticos ficam em `public/` (URL fixa) ou `app/assets/` (processados pelo build).
- Defina dimensões para evitar layout shift.
- Use `srcset` para imagens responsivas.
- Minifique e otimize assets.
- Não faça upload de assets pesados sem necessidade.
