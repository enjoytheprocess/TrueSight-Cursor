#!/usr/bin/env bash
# After agent turn: remind or run docs-check when AWP YAML changed
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cat >/dev/null

if ! git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

mapfile -t changed < <(git -C "$ROOT" diff --name-only 2>/dev/null; git -C "$ROOT" diff --name-only --cached 2>/dev/null)
yaml_changed=0
for f in "${changed[@]}"; do
  [[ "$f" =~ ^\.awp-workspace/[^/]+/.*\.yaml$ ]] && yaml_changed=1 && break
done

if [[ "$yaml_changed" -eq 0 ]]; then
  exit 0
fi

if command -v make &>/dev/null && make -C "$ROOT" awp-render >/dev/null 2>&1; then
  if make -C "$ROOT" awp-docs-check >/dev/null 2>&1; then
    exit 0
  fi
  msg="AWP registers changed. make awp-render ran; make awp-docs-check failed — fix violations before commit."
else
  msg="AWP registers changed. Run: make awp-render && make awp-docs-check"
fi

if command -v jq &>/dev/null; then
  jq -n --arg m "$msg" '{followup_message: $m}'
else
  printf '%s\n' "{\"followup_message\":\"$msg\"}"
fi
exit 0
