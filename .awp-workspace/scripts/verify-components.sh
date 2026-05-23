#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="${1:-$REPO_ROOT/workspace.manifest.yaml}"

if [[ ! -f "$MANIFEST" ]]; then
  echo "ERROR: manifest file not found: $MANIFEST" >&2
  exit 1
fi

# shellcheck source=scripts/manifest-lib.sh
source "$SCRIPT_DIR/manifest-lib.sh"
manifest_validate "$MANIFEST" >/dev/null

had_failures=0
mapfile -t rows < <(manifest_parse_tsv "$MANIFEST")
for row in "${rows[@]}"; do
  IFS=$'\t' read -r name repo path ref type verify <<< "$row"
  abs_path="$REPO_ROOT/$path"

  echo "== verify: $name =="

  if [[ ! -d "$abs_path" ]]; then
    echo "FAIL: missing component directory: $path" >&2
    had_failures=1
    continue
  fi

  if [[ "$verify" =~ ^skip: ]]; then
    echo "SKIP: $verify"
    continue
  fi

  if ! (cd "$abs_path" && bash -lc "$verify"); then
    echo "FAIL: verification failed for $name" >&2
    had_failures=1
  fi
done

if [[ $had_failures -ne 0 ]]; then
  exit 1
fi

echo "All component verification commands passed."
