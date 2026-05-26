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

printf "%-24s %-12s %-42s %-42s %-8s\n" "COMPONENT" "TYPE" "EXPECTED_REF" "ACTUAL_REF" "DIRTY"
printf "%-24s %-12s %-42s %-42s %-8s\n" "---------" "----" "------------" "----------" "-----"

mapfile -t rows < <(manifest_parse_tsv "$MANIFEST")
for row in "${rows[@]}"; do
  IFS=$'\t' read -r name repo path ref type verify <<< "$row"
  abs_path="$REPO_ROOT/$path"

  if [[ ! -d "$abs_path/.git" ]]; then
    printf "%-24s %-12s %-42s %-42s %-8s\n" "$name" "$type" "$ref" "MISSING" "-"
    continue
  fi

  actual_ref="$(git -C "$abs_path" rev-parse HEAD 2>/dev/null || echo UNKNOWN)"
  dirty="clean"
  if [[ -n "$(git -C "$abs_path" status --porcelain)" ]]; then
    dirty="dirty"
  fi

  if [[ "$ref" == "HEAD" ]]; then
    expected_display="HEAD"
  else
    expected_display="$ref"
  fi

  printf "%-24s %-12s %-42s %-42s %-8s\n" "$name" "$type" "$expected_display" "$actual_ref" "$dirty"
done
