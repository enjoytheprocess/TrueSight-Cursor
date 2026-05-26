#!/usr/bin/env bash
# Regenerate AWP register .md views after an agent edits .yaml under .awp-workspace/workspace-build/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
input="$(cat)"

file=""
if command -v jq &>/dev/null; then
  file="$(echo "$input" | jq -r '.file_path // .path // .file // empty' 2>/dev/null || true)"
fi

if [[ -z "$file" ]] || [[ ! "$file" =~ ^\.awp-workspace/[^/]+/.*\.yaml$ ]]; then
  exit 0
fi

if ! command -v make &>/dev/null; then
  echo '{"additional_context":"AWP: install make and run make awp-render after editing .awp-workspace/workspace-build/*.yaml"}' 2>/dev/null || true
  exit 0
fi

if make -C "$ROOT" awp-render >/dev/null 2>&1; then
  exit 0
fi

echo '{"additional_context":"AWP: make awp-render failed — run it manually from the repo root."}' 2>/dev/null || true
exit 0
