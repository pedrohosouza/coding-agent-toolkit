#!/usr/bin/env bash
set -uo pipefail

if ! command -v node >/dev/null || ! command -v npx >/dev/null; then
  echo "Node.js e npx precisam estar disponíveis no PATH." >&2
  exit 1
fi

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P) || exit 1
failed=()

install_skills() {
  printf '>> Instalar %s\n' "$*"
  npx --yes skills add "$@" --global --yes || failed+=("$*")
}

install=(
  "https://github.com/mattpocock/skills --skill grilling"
  "https://github.com/juliusbrussee/caveman --skill caveman"
  "https://github.com/microsoft/playwright-cli --skill playwright-cli"
  "https://github.com/blader/humanizer --skill humanizer"
  "https://github.com/cloudflare/security-audit-skill --skill security-audit"
  "coreyhaines31/marketingskills"
  "https://github.com/leonxlnx/taste-skill --skill design-taste-frontend"
  "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill --skill ui-ux-pro-max"
  "https://github.com/pbakaus/impeccable --skill impeccable"
  "https://github.com/kaankiziltug/logo-design-skill --skill logo-design"
)

echo "== Skills =="
install_skills "$repo_dir/skills"
for args in "${install[@]}"; do
  read -r -a parts <<<"$args"
  install_skills "${parts[@]}"
done

echo "== Plugins =="
if command -v codex >/dev/null; then
  echo ">> Configurar Context7 no Codex"
  codex plugin marketplace remove context7-marketplace >/dev/null 2>&1 || true
  if codex plugin marketplace add upstash/context7; then
    codex plugin add context7@context7-marketplace || failed+=("Context7 no Codex")
  else
    failed+=("Marketplace do Context7 no Codex")
  fi
fi

if command -v claude >/dev/null; then
  echo ">> Configurar Context7 no Claude Code"
  claude plugin install context7@claude-plugins-official || failed+=("Context7 no Claude Code")
fi

if ((${#failed[@]})); then
  echo "Falhas na instalação" >&2
  printf '  %s\n' "${failed[@]}" >&2
  exit 1
fi
