#!/usr/bin/env bash
# Monorepo layout for TrueSight: AWP registers in .awp-workspace/, component at backend/.
# Source from other scripts after SCRIPT_DIR is set.

_layout_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$_layout_dir/.." && pwd)"
MONOREPO_ROOT="$(cd "$WORKSPACE_ROOT/.." && pwd)"

_layout_file="$WORKSPACE_ROOT/workspace-layout.yaml"
if [[ -f "$_layout_file" ]] && command -v yq &>/dev/null; then
  COMPONENT_NAME="${COMPONENT_NAME:-$(yq -r '.component.name // "backend"' "$_layout_file")}"
  COMPONENT_REL="${COMPONENT_REL:-$(yq -r '.component.path // "backend"' "$_layout_file")}"
  WORKSPACE_LINK_PREFIX="${WORKSPACE_LINK_PREFIX:-$(yq -r '.workspace_link_prefix // ".awp-workspace"' "$_layout_file")}"
else
  COMPONENT_NAME="${COMPONENT_NAME:-backend}"
  COMPONENT_REL="${COMPONENT_REL:-backend}"
  WORKSPACE_LINK_PREFIX="${WORKSPACE_LINK_PREFIX:-.awp-workspace}"
fi

COMPONENT_ROOT="$MONOREPO_ROOT/$COMPONENT_REL"
export WORKSPACE_ROOT MONOREPO_ROOT COMPONENT_NAME COMPONENT_REL COMPONENT_ROOT WORKSPACE_LINK_PREFIX

resolve_repo_path() {
  local rel="$1"
  if [[ -e "$WORKSPACE_ROOT/$rel" ]]; then
    echo "$WORKSPACE_ROOT/$rel"
    return 0
  fi
  if [[ -e "$MONOREPO_ROOT/$rel" ]]; then
    echo "$MONOREPO_ROOT/$rel"
    return 0
  fi
  return 1
}
