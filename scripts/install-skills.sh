#!/usr/bin/env bash
set -uo pipefail

remove=(
  grilling
  caveman
  playwright-cli
  humanizer
  security-audit
  design-taste-frontend
  ui-ux-pro-max
  impeccable
  clean-code
  commit-conventions
  nestjs-backend
  nuxt-frontend-spa
  nuxt-fullstack
  ui-ux
)

install=(
  "pedrohosouza/coding-agent-toolkit"
  "https://github.com/mattpocock/skills --skill grilling"
  "https://github.com/juliusbrussee/caveman --skill caveman"
  "https://github.com/microsoft/playwright-cli --skill playwright-cli"
  "https://github.com/blader/humanizer --skill humanizer"
  "https://github.com/cloudflare/security-audit-skill --skill security-audit"
  "coreyhaines31/marketingskills"
  "https://github.com/leonxlnx/taste-skill --skill design-taste-frontend"
  "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill --skill ui-ux-pro-max"
  "https://github.com/pbakaus/impeccable --skill impeccable"
)

echo "== Reset =="
for skill in "${remove[@]}"; do
  echo ">> remove $skill"
  npx skills remove "$skill" --global --yes >/dev/null 2>&1 || true
done

echo "== Setup =="
failed=()
for args in "${install[@]}"; do
  echo ">> add $args"
  read -r -a parts <<<"$args"
  npx skills add "${parts[@]}" --global --yes || failed+=("$args")
done

echo "== Plugins =="
codex plugin marketplace remove context7-marketplace >/dev/null 2>&1 || true
plugin_cmds=(
  "codex plugin marketplace add upstash/context7"
  "codex plugin add context7@context7-marketplace"
  "claude plugin install context7@anthropic-plugin-directory"
)
for cmd in "${plugin_cmds[@]}"; do
  echo ">> $cmd"
  $cmd || failed+=("$cmd")
done

if ((${#failed[@]})); then
  echo "Failed:" >&2
  printf '  %s\n' "${failed[@]}" >&2
  exit 1
fi
