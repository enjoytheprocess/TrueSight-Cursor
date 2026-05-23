#!/usr/bin/env bash

set -euo pipefail

CHECK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$CHECK_DIR/../.." && pwd)"
# shellcheck source=../../scripts/workspace-layout.sh
source "$REPO_ROOT/scripts/workspace-layout.sh"

violations=0

check_component_dir() {
  local dir="$1"
  local label="$2"

  if [[ ! -f "$dir/README.md" ]]; then
    echo "MISSING: $label/README.md"
    violations=1
  fi

  if [[ ! -f "$dir/AGENTS.md" ]]; then
    echo "MISSING: $label/AGENTS.md"
    violations=1
  fi
}

if [[ -f "$WORKSPACE_ROOT/workspace-layout.yaml" ]]; then
  check_component_dir "$COMPONENT_ROOT" "$COMPONENT_REL"
else
  COMPONENTS_DIR="$REPO_ROOT/components"
  if [[ ! -d "$COMPONENTS_DIR" ]]; then
    echo "No components directory found."
    exit 0
  fi

  for dir in "$COMPONENTS_DIR"/*; do
    [[ ! -d "$dir" ]] && continue
    name="$(basename "$dir")"
    [[ "$name" == ".git" ]] && continue
    check_component_dir "$dir" "components/$name"
  done
fi

if [[ $violations -ne 0 ]]; then
  echo "Component doc contract check failed." >&2
  exit 1
fi

echo "Component doc contract check passed."
