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

mapfile -t rows < <(manifest_parse_tsv "$MANIFEST")
for row in "${rows[@]}"; do
  IFS=$'\t' read -r name repo path ref type verify <<< "$row"
  abs_path="$REPO_ROOT/$path"

  echo "== $name =="
  mkdir -p "$(dirname "$abs_path")"

  if [[ ! -d "$abs_path/.git" ]]; then
    echo "Cloning $repo -> $path"
    git clone "$repo" "$abs_path"
  fi

  git -C "$abs_path" fetch --all --prune

  if [[ "$ref" == "HEAD" ]]; then
    default_branch="$(git -C "$abs_path" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
    default_branch="${default_branch:-main}"
    git -C "$abs_path" checkout "$default_branch"
    git -C "$abs_path" pull --ff-only origin "$default_branch"
  else
    git -C "$abs_path" checkout --detach "$ref"
  fi

done
