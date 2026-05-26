#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=workspace-layout.sh
source "$SCRIPT_DIR/workspace-layout.sh"
REPO_ROOT="$WORKSPACE_ROOT"
GIT_ROOT="$MONOREPO_ROOT"
ALLOW_PATHS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --allow-path)
      shift
      ALLOW_PATHS="${1:-}"
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: ./scripts/check-docs-boundary.sh [--allow-path path1,path2]" >&2
      exit 2
      ;;
  esac
  shift
done

mapfile -t changed_files < <({
  git -C "$GIT_ROOT" diff --name-only
  git -C "$GIT_ROOT" diff --name-only --cached
  git -C "$GIT_ROOT" ls-files --others --exclude-standard
} | sort -u)

if [[ ${#changed_files[@]} -eq 0 ]]; then
  echo "No working-tree changes detected."
  exit 0
fi

IFS=',' read -r -a extra_allow <<< "$ALLOW_PATHS"

is_allowed() {
  local path="$1"

  [[ "$path" == .awp-workspace/workspace-build/* ]] && return 0
  [[ "$path" == backend/* ]] && return 0
  [[ "$path" == frontend/* ]] && return 0
  [[ "$path" == docs/* ]] && return 0
  [[ "$path" == .cursor/* ]] && return 0
  [[ "$path" == scripts/* ]] && return 0

  case "$path" in
    README.md|AGENTS.md|cursor.md|Makefile|.gitignore|.cursorignore|upgrade-notes.md|template-release.yaml)
      return 0
      ;;
    docs/*|examples/*|0-ideation/*|1-design/*|2-build/*|3-verify/*|4-sync/*|templates/*)
      return 0
      ;;
    meta/README.md|meta/schemas/*|meta/templates/*)
      return 0
      ;;
    components/COMPONENT_REPOS.md|components/.gitkeep|components/*/README.md|components/*/AGENTS.md)
      return 0
      ;;
  esac

  for p in "${extra_allow[@]}"; do
    [[ -z "$p" ]] && continue
    if [[ "$path" == "$p" || "$path" == "$p"/* ]]; then
      return 0
    fi
  done

  return 1
}

violations=0
for path in "${changed_files[@]}"; do
  if ! is_allowed "$path"; then
    echo "BOUNDARY VIOLATION: $path"
    violations=1
  fi
done

if [[ $violations -ne 0 ]]; then
  echo "Docs-boundary check failed." >&2
  exit 1
fi

echo "Docs-boundary check passed."
