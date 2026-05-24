#!/usr/bin/env bash
# Monorepo layout for TrueSight: AWP registers in .awp-workspace/; components at repo root.
# Source from other scripts after SCRIPT_DIR is set.

_layout_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$_layout_dir/.." && pwd)"
MONOREPO_ROOT="$(cd "$WORKSPACE_ROOT/.." && pwd)"

_layout_file="$WORKSPACE_ROOT/workspace-layout.yaml"
if [[ -f "$_layout_file" ]] && command -v yq &>/dev/null; then
  WORKSPACE_LINK_PREFIX="${WORKSPACE_LINK_PREFIX:-$(yq -r '.workspace_link_prefix // ".awp-workspace"' "$_layout_file")}"
  DESIGN_DOCS_ROOT="${DESIGN_DOCS_ROOT:-$(yq -r '.design_docs_root // "docs"' "$_layout_file")}"

  if yq -e '.components | length > 0' "$_layout_file" >/dev/null 2>&1; then
    COMPONENT_NAME="${COMPONENT_NAME:-$(yq -r '.primary_component // .components[0].name // "backend"' "$_layout_file")}"
    COMPONENT_REL="${COMPONENT_REL:-$(yq -r ".components[] | select(.name == \"${COMPONENT_NAME}\") | .path" "$_layout_file")}"
    if [[ -z "$COMPONENT_REL" || "$COMPONENT_REL" == "null" ]]; then
      COMPONENT_REL="$(yq -r '.components[0].path // "backend"' "$_layout_file")"
      COMPONENT_NAME="$(yq -r '.components[0].name // "backend"' "$_layout_file")"
    fi
  else
    COMPONENT_NAME="${COMPONENT_NAME:-$(yq -r '.component.name // "backend"' "$_layout_file")}"
    COMPONENT_REL="${COMPONENT_REL:-$(yq -r '.component.path // "backend"' "$_layout_file")}"
  fi
else
  COMPONENT_NAME="${COMPONENT_NAME:-backend}"
  COMPONENT_REL="${COMPONENT_REL:-backend}"
  WORKSPACE_LINK_PREFIX="${WORKSPACE_LINK_PREFIX:-.awp-workspace}"
  DESIGN_DOCS_ROOT="${DESIGN_DOCS_ROOT:-docs}"
fi

COMPONENT_ROOT="$MONOREPO_ROOT/$COMPONENT_REL"
DESIGN_DOCS_PATH="$MONOREPO_ROOT/$DESIGN_DOCS_ROOT"
export WORKSPACE_ROOT MONOREPO_ROOT COMPONENT_NAME COMPONENT_REL COMPONENT_ROOT WORKSPACE_LINK_PREFIX DESIGN_DOCS_ROOT DESIGN_DOCS_PATH

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

# Emit registered monorepo components as TSV: name<TAB>path<TAB>type<TAB>verify_command
list_monorepo_components() {
  local layout="$WORKSPACE_ROOT/workspace-layout.yaml"
  [[ -f "$layout" ]] || return 0
  command -v yq &>/dev/null || return 0

  if yq -e '.components | length > 0' "$layout" >/dev/null 2>&1; then
    yq -r '.components[] | [.name, .path, (.type // ""), (.verify_command // "")] | join("\t")' "$layout"
    return 0
  fi

  if yq -e '.component.name' "$layout" >/dev/null 2>&1; then
    yq -r '[.component.name, .component.path, (.component.type // ""), (.component.verify_command // "")] | join("\t")' "$layout"
  fi
}
