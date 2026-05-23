#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=workspace-layout.sh
source "$SCRIPT_DIR/workspace-layout.sh"
REPO_ROOT="$WORKSPACE_ROOT"
USE_MONOREPO_LAYOUT=0
[[ -f "$WORKSPACE_ROOT/workspace-layout.yaml" ]] && USE_MONOREPO_LAYOUT=1

# ---------------------------------------------------------------------------
# Defaults — all overridable via environment variables
# ---------------------------------------------------------------------------
MODE="${MODE:-single}"
PROJECT_NAME="${PROJECT_NAME:-}"
WORKSPACE_LANGUAGE="${WORKSPACE_LANGUAGE:-English}"
PROJECT_PROBLEM="${PROJECT_PROBLEM:-Describe the core workflow or product problem here.}"
TARGET_USER="${TARGET_USER:-Primary user or operator}"
TASK_ID="${TASK_ID:-SETUP-001}"
MILESTONE_ID="${MILESTONE_ID:-M-001}"
COMPONENT_NAME="${COMPONENT_NAME:-}"
TARGET_WINDOW="${TARGET_WINDOW:-}"
USE_IDEATION="${USE_IDEATION:-1}"
USE_DEPENDENCIES="${USE_DEPENDENCIES:-0}"
USE_LOCKS="${USE_LOCKS:-0}"
USE_SYNC_LOGS="${USE_SYNC_LOGS:-0}"
USE_TEMP_MEASURES="${USE_TEMP_MEASURES:-0}"
USE_SPECIALIST_REGISTERS="${USE_SPECIALIST_REGISTERS:-0}"
USE_QUALITY_REQUIREMENTS="${USE_QUALITY_REQUIREMENTS:-0}"
USE_SIGN_OFF="${USE_SIGN_OFF:-0}"
USE_RELEASE_QUEUE="${USE_RELEASE_QUEUE:-0}"
FORCE="${FORCE:-0}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

render_template() {
  local template_rel="$1"
  local output_rel="$2"

  # Escape values for use as sed replacement strings (| delimiter).
  # Only \, &, and | need escaping; / is safe because the delimiter is |.
  esc() { printf '%s' "$1" | sed 's/[\\&|]/\\&/g'; }

  local vars=(
    PROJECT_NAME COMPONENT_NAME PROJECT_PROBLEM TARGET_USER
    TASK_ID MILESTONE_ID TARGET_WINDOW
    REPO_MODE ADOPTION_PATH CODE_REF
    WORKSPACE_LANGUAGE WORKSPACE_LINK_PREFIX
  )

  local sed_args=()
  local var val
  for var in "${vars[@]}"; do
    val="${!var}"
    sed_args+=(-e "s|__${var}__|$(esc "$val")|g")
  done

  sed "${sed_args[@]}" "$REPO_ROOT/$template_rel" > "$REPO_ROOT/$output_rel"
}

render_template_to() {
  local template_rel="$1"
  local output_path="$2"

  esc() { printf '%s' "$1" | sed 's/[\\&|]/\\&/g'; }

  local vars=(
    PROJECT_NAME COMPONENT_NAME PROJECT_PROBLEM TARGET_USER
    TASK_ID MILESTONE_ID TARGET_WINDOW
    REPO_MODE ADOPTION_PATH CODE_REF
    WORKSPACE_LANGUAGE WORKSPACE_LINK_PREFIX
  )

  local sed_args=()
  local var val
  for var in "${vars[@]}"; do
    val="${!var}"
    sed_args+=(-e "s|__${var}__|$(esc "$val")|g")
  done

  mkdir -p "$(dirname "$output_path")"
  sed "${sed_args[@]}" "$REPO_ROOT/$template_rel" > "$output_path"
}

# Deploy an optional file from a template. Skips if the file already exists
# and FORCE is not set — preserves user customisations on re-init.
deploy_optional() {
  local template_rel="$1"
  local output_rel="$2"
  local abs_path="$REPO_ROOT/$output_rel"

  if [[ -f "$abs_path" ]] && [[ "$FORCE" != "1" ]]; then
    return 0
  fi

  render_template "$template_rel" "$output_rel"
  echo "  $output_rel"
}

ensure_placeholder_file() {
  local rel_path="$1"
  local marker="$2"
  local abs_path="$REPO_ROOT/$rel_path"

  if [[ "$FORCE" == "1" ]]; then
    return 0
  fi

  if [[ ! -f "$abs_path" ]]; then
    echo "ERROR: expected file not found: $rel_path" >&2
    exit 1
  fi

  if ! grep -qF "$marker" "$abs_path"; then
    echo "ERROR: $rel_path no longer looks like the shipped placeholder. Re-run with FORCE=1 to overwrite it intentionally." >&2
    exit 1
  fi
}

# Interactive prompt helpers — only called when stdin is a TTY.
prompt_value() {
  local prompt_text="$1"
  local default_val="${2:-}"
  local value=""

  if [[ -n "$default_val" ]]; then
    read -r -p "$prompt_text [$default_val]: " value
    printf '%s' "${value:-$default_val}"
  else
    while [[ -z "$value" ]]; do
      read -r -p "$prompt_text (required): " value
    done
    printf '%s' "$value"
  fi
}

prompt_yesno() {
  local prompt_text="$1"
  local default_yn="${2:-n}"
  local hint value

  if [[ "$default_yn" == "y" ]]; then
    hint="Y/n"
  else
    hint="y/N"
  fi

  read -r -p "$prompt_text [$hint]: " value
  value="${value:-$default_yn}"

  if [[ "${value,,}" == "y" ]]; then
    printf '1'
  else
    printf '0'
  fi
}

# ---------------------------------------------------------------------------
# Interactive mode
# Runs when stdin is a terminal and WORKSPACE_INIT_YES is not set.
# All variables can still be pre-set via environment to skip individual prompts.
# ---------------------------------------------------------------------------
if [[ -t 0 ]] && [[ "${WORKSPACE_INIT_YES:-0}" != "1" ]]; then
  echo ""
  echo "=================================="
  echo " AI Workspace Initializer"
  echo "=================================="
  echo ""

  # Project name — required, no useful default
  if [[ -z "$PROJECT_NAME" ]]; then
    PROJECT_NAME="$(prompt_value "Project name" "")"
  fi

  # Language — agents will respond in this language
  WORKSPACE_LANGUAGE="$(prompt_value "Agent response language" "$WORKSPACE_LANGUAGE")"

  # Repository mode — offer a labelled menu
  if [[ "$MODE" == "single" ]]; then
    echo ""
    echo "Repository mode:"
    echo "  1) single     — all product logic in one deployable"
    echo "  2) multi      — independent deployables (API, web, worker, ...)"
    echo "  3) federated  — this repo is the planning hub; components live in separate repos"
    mode_choice=""
    read -r -p "Select [1]: " mode_choice
    case "${mode_choice:-1}" in
      2) MODE="multi" ;;
      3) MODE="federated" ;;
      *) MODE="single" ;;
    esac
  fi

  # Component name — default depends on mode chosen above
  if [[ -z "$COMPONENT_NAME" ]]; then
    component_prompt_default="app"
    [[ "$MODE" == "multi" || "$MODE" == "federated" ]] && component_prompt_default="api"
    COMPONENT_NAME="$(prompt_value "Primary component name" "$component_prompt_default")"
  fi

  # Optional registers
  echo ""
  echo "Optional registers (add now or enable later by re-running with FORCE=1):"
  USE_IDEATION="$(prompt_yesno "  Ideation backlog  (0-ideation/)" "y")"
  USE_DEPENDENCIES="$(prompt_yesno "  Task dependency tracking" "n")"
  USE_LOCKS="$(prompt_yesno "  Parallel lock tracking" "n")"
  USE_TEMP_MEASURES="$(prompt_yesno "  Temp measures     (short-term exceptions with removal targets)" "n")"
  USE_SYNC_LOGS="$(prompt_yesno "  Handoffs log      (ownership transfer history)" "n")"
  USE_SPECIALIST_REGISTERS="$(prompt_yesno "  Specialist records (security, experiment, incident, data migration)" "n")"
  USE_QUALITY_REQUIREMENTS="$(prompt_yesno "  Quality requirements (observability, SLO, testing strategy, data safety)" "n")"
  USE_SIGN_OFF="$(prompt_yesno "  Sign-off log      (formal acceptance audit trail)" "n")"
  USE_RELEASE_QUEUE="$(prompt_yesno "  Release queue     (deployment release candidates; integrates with workspace-deployment)" "n")"
  echo ""
fi

# ---------------------------------------------------------------------------
# Apply fallback defaults for anything still unset after interactive pass
# ---------------------------------------------------------------------------
PROJECT_NAME="${PROJECT_NAME:-New Workspace}"

# ---------------------------------------------------------------------------
# Derive mode-specific values
# ---------------------------------------------------------------------------
root_readme_template=""
root_agents_template=""
case "$MODE" in
  single)
    REPO_MODE="single-component"
    ADOPTION_PATH="direct-use"
    root_readme_template="templates/init/workspace/WORKSPACE_README_TEMPLATE.md"
    root_agents_template="templates/init/workspace/WORKSPACE_AGENTS_TEMPLATE.md"
    ;;
  multi)
    REPO_MODE="multi-component"
    ADOPTION_PATH="direct-use"
    root_readme_template="templates/init/workspace/WORKSPACE_README_TEMPLATE.md"
    root_agents_template="templates/init/workspace/WORKSPACE_AGENTS_TEMPLATE.md"
    ;;
  federated)
    REPO_MODE="federated"
    ADOPTION_PATH="sideload/adapt"
    root_readme_template="templates/init/workspace/WORKSPACE_README_FEDERATED_TEMPLATE.md"
    root_agents_template="templates/init/workspace/WORKSPACE_AGENTS_FEDERATED_TEMPLATE.md"
    ;;
  *)
    echo "ERROR: MODE must be one of: single, multi, federated" >&2
    exit 1
    ;;
esac

if [[ -z "$COMPONENT_NAME" ]]; then
  case "$MODE" in
    multi|federated) COMPONENT_NAME="api" ;;
    *)               COMPONENT_NAME="app" ;;
  esac
fi

[[ -z "$TARGET_WINDOW" ]] && TARGET_WINDOW="TBD"

if [[ "$MODE" == "federated" ]]; then
  CODE_REF="repo:${COMPONENT_NAME}@HEAD:src"
elif [[ "$USE_MONOREPO_LAYOUT" == "1" ]]; then
  CODE_REF="${COMPONENT_REL}/src"
else
  CODE_REF="components/${COMPONENT_NAME}/src"
fi

# Export derived variables so render_template can read them via ${!var}
export REPO_MODE ADOPTION_PATH CODE_REF WORKSPACE_LANGUAGE WORKSPACE_LINK_PREFIX

# ---------------------------------------------------------------------------
# Guard: prevent accidental overwrites of already-customised core files
# ---------------------------------------------------------------------------
ensure_placeholder_file "README.md" "Reusable starter repo for AI-assisted software projects."
ensure_placeholder_file "AGENTS.md" "Runtime instructions for AI agents working in this repository."
ensure_placeholder_file "1-design/PROJECT_BRIEF.md" "Project name: New Workspace"
ensure_placeholder_file "1-design/FEATURE_REGISTRY.yaml" "add your first feature when design begins"
ensure_placeholder_file "1-design/DESIGN_STATES.yaml" "add your first feature when design begins"
ensure_placeholder_file "1-design/TASK_READINESS.yaml" "seeded by make init; mark done when setup is complete"
ensure_placeholder_file "1-design/ROADMAP.yaml" "seeded by make init; replace with your first real capability"
ensure_placeholder_file "2-build/WORK_QUEUE.yaml" "seeded by make init; complete this task to finish workspace setup"
ensure_placeholder_file "3-verify/TRACEABILITY_MATRIX.yaml" "add features as traceability is established"
ensure_placeholder_file "3-verify/FEEDBACK_MATRIX.yaml"     "add entries when human testing begins"
ensure_placeholder_file "3-verify/GAPS_AND_DEVIATIONS.yaml" "add entries as gaps and deviations surface"
ensure_placeholder_file "3-verify/acceptance-gate.md"       "Acceptance Gate"
ensure_placeholder_file "4-sync/DESIGN_INPUTS.yaml"         "populated by Sync from GAPS_AND_DEVIATIONS entries"

# ---------------------------------------------------------------------------
# Render core workspace files
# ---------------------------------------------------------------------------
echo "Initializing workspace..."

render_template "$root_readme_template" "README.md"
echo "  README.md"

render_template "$root_agents_template" "AGENTS.md"
echo "  AGENTS.md"

render_template "templates/init/workspace/INIT_PROJECT_BRIEF_TEMPLATE.md" "1-design/PROJECT_BRIEF.md"
echo "  1-design/PROJECT_BRIEF.md"

render_template "templates/init/1-design/INIT_FEATURE_REGISTRY_TEMPLATE.yaml" "1-design/FEATURE_REGISTRY.yaml"
echo "  1-design/FEATURE_REGISTRY.yaml"
render_template "templates/init/1-design/INIT_DESIGN_STATES_TEMPLATE.yaml" "1-design/DESIGN_STATES.yaml"
echo "  1-design/DESIGN_STATES.yaml"
mkdir -p "$REPO_ROOT/1-design/archive"
render_template "templates/init/1-design/INIT_DESIGN_STATES_DONE_TEMPLATE.yaml" "1-design/archive/DESIGN_STATES.yaml"
echo "  1-design/archive/DESIGN_STATES.yaml"

render_template "templates/init/1-design/INIT_TASK_READINESS_TEMPLATE.yaml" "1-design/TASK_READINESS.yaml"
echo "  1-design/TASK_READINESS.yaml"
render_template "templates/init/1-design/INIT_TASK_READINESS_DONE_TEMPLATE.yaml" "1-design/archive/TASK_READINESS.yaml"
echo "  1-design/archive/TASK_READINESS.yaml"

render_template "templates/init/1-design/INIT_ROADMAP_TEMPLATE.yaml" "1-design/ROADMAP.yaml"
echo "  1-design/ROADMAP.yaml"
render_template "templates/init/1-design/INIT_ROADMAP_DONE_TEMPLATE.yaml" "1-design/archive/ROADMAP.yaml"
echo "  1-design/archive/ROADMAP.yaml"

render_template "templates/init/2-build/INIT_WORK_QUEUE_TEMPLATE.yaml" "2-build/WORK_QUEUE.yaml"
echo "  2-build/WORK_QUEUE.yaml"
mkdir -p "$REPO_ROOT/2-build/archive"
render_template "templates/init/2-build/INIT_WORK_QUEUE_DONE_TEMPLATE.yaml" "2-build/archive/WORK_QUEUE.yaml"
echo "  2-build/archive/WORK_QUEUE.yaml"

render_template "templates/init/3-verify/INIT_TRACEABILITY_MATRIX_TEMPLATE.yaml" "3-verify/TRACEABILITY_MATRIX.yaml"
echo "  3-verify/TRACEABILITY_MATRIX.yaml"

render_template "templates/init/3-verify/INIT_FEEDBACK_MATRIX_TEMPLATE.yaml" "3-verify/FEEDBACK_MATRIX.yaml"
echo "  3-verify/FEEDBACK_MATRIX.yaml"
mkdir -p "$REPO_ROOT/3-verify/archive"
render_template "templates/init/3-verify/INIT_FEEDBACK_MATRIX_DONE_TEMPLATE.yaml" "3-verify/archive/FEEDBACK_MATRIX.yaml"
echo "  3-verify/archive/FEEDBACK_MATRIX.yaml"

render_template "templates/init/3-verify/INIT_GAPS_AND_DEVIATIONS_TEMPLATE.yaml" "3-verify/GAPS_AND_DEVIATIONS.yaml"
echo "  3-verify/GAPS_AND_DEVIATIONS.yaml"
render_template "templates/init/3-verify/INIT_GAPS_AND_DEVIATIONS_DONE_TEMPLATE.yaml" "3-verify/archive/GAPS_AND_DEVIATIONS.yaml"
echo "  3-verify/archive/GAPS_AND_DEVIATIONS.yaml"

render_template "templates/init/3-verify/INIT_ACCEPTANCE_GATE_TEMPLATE.md" "3-verify/acceptance-gate.md"
echo "  3-verify/acceptance-gate.md"

render_template "templates/init/4-sync/INIT_DESIGN_INPUTS_TEMPLATE.yaml" "4-sync/DESIGN_INPUTS.yaml"
echo "  4-sync/DESIGN_INPUTS.yaml"

# ---------------------------------------------------------------------------
# Render component files
# ---------------------------------------------------------------------------
if [[ "$MODE" != "federated" ]]; then
  if [[ "$USE_MONOREPO_LAYOUT" == "1" ]]; then
    render_template_to "templates/init/component/INIT_COMPONENT_README_TEMPLATE.md" "$COMPONENT_ROOT/README.md"
    echo "  $COMPONENT_REL/README.md"
    render_template_to "templates/init/component/INIT_COMPONENT_AGENTS_TEMPLATE.md" "$COMPONENT_ROOT/AGENTS.md"
    echo "  $COMPONENT_REL/AGENTS.md"
  else
    mkdir -p "$REPO_ROOT/components/$COMPONENT_NAME"
    render_template "templates/init/component/INIT_COMPONENT_README_TEMPLATE.md" "components/${COMPONENT_NAME}/README.md"
    echo "  components/${COMPONENT_NAME}/README.md"
    render_template "templates/init/component/INIT_COMPONENT_AGENTS_TEMPLATE.md" "components/${COMPONENT_NAME}/AGENTS.md"
    echo "  components/${COMPONENT_NAME}/AGENTS.md"
  fi
fi

if [[ "$MODE" == "federated" ]]; then
  render_template "templates/init/component/INIT_COMPONENT_REPOS_TEMPLATE.md" "components/COMPONENT_REPOS.md"
  echo "  components/COMPONENT_REPOS.md"
  render_template "templates/init/workspace/INIT_WORKSPACE_MANIFEST_TEMPLATE.yaml" "workspace.manifest.yaml"
  echo "  workspace.manifest.yaml"
fi

# ---------------------------------------------------------------------------
# Deploy optional registers — only created when opted in
# ---------------------------------------------------------------------------
if [[ "$USE_IDEATION" == "1" ]]; then
  deploy_optional "templates/init/0-ideation/INIT_IDEATION_BACKLOG_TEMPLATE.yaml" "0-ideation/IDEATION_BACKLOG.yaml"
  mkdir -p "$REPO_ROOT/0-ideation/archive"
  deploy_optional "templates/init/0-ideation/INIT_IDEATION_BACKLOG_DONE_TEMPLATE.yaml" "0-ideation/archive/IDEATION_BACKLOG.yaml"
fi

if [[ "$USE_DEPENDENCIES" == "1" ]]; then
  deploy_optional "templates/init/2-build/INIT_TASK_DEPENDENCIES_TEMPLATE.yaml" "2-build/TASK_DEPENDENCIES.yaml"
  deploy_optional "templates/init/2-build/INIT_TASK_DEPENDENCIES_MD_TEMPLATE.md" "2-build/TASK_DEPENDENCIES.md"
fi

if [[ "$USE_LOCKS" == "1" ]]; then
  deploy_optional "templates/init/2-build/INIT_LOCKS_TEMPLATE.yaml" "2-build/LOCKS.yaml"
  mkdir -p "$REPO_ROOT/2-build/archive"
  deploy_optional "templates/init/2-build/INIT_LOCKS_DONE_TEMPLATE.yaml" "2-build/archive/LOCKS.yaml"
  deploy_optional "templates/init/2-build/INIT_LOCKS_MD_TEMPLATE.md" "2-build/LOCKS.md"
fi

if [[ "$USE_TEMP_MEASURES" == "1" ]]; then
  deploy_optional "templates/init/2-build/INIT_TEMP_MEASURES_TEMPLATE.yaml" "2-build/TEMP_MEASURES.yaml"
  mkdir -p "$REPO_ROOT/2-build/archive"
  deploy_optional "templates/init/2-build/INIT_TEMP_MEASURES_DONE_TEMPLATE.yaml" "2-build/archive/TEMP_MEASURES.yaml"
fi

if [[ "$USE_SYNC_LOGS" == "1" ]]; then
  deploy_optional "templates/init/4-sync/INIT_HANDOFFS_TEMPLATE.md" "4-sync/HANDOFFS.md"
fi

if [[ "$USE_SPECIALIST_REGISTERS" == "1" ]]; then
  deploy_optional "templates/init/3-verify/INIT_SECURITY_REVIEWS_TEMPLATE.md"        "3-verify/SECURITY_REVIEWS.md"
  deploy_optional "templates/init/3-verify/INIT_EXPERIMENT_REVIEWS_TEMPLATE.md"      "3-verify/EXPERIMENT_REVIEWS.md"
  deploy_optional "templates/init/3-verify/INIT_INCIDENT_RESPONSES_TEMPLATE.md"      "3-verify/INCIDENT_RESPONSES.md"
  deploy_optional "templates/init/3-verify/INIT_DATA_MIGRATION_REVIEWS_TEMPLATE.md"  "3-verify/DATA_MIGRATION_REVIEWS.md"
  deploy_optional "templates/init/3-verify/INIT_API_CONTRACT_REVIEWS_TEMPLATE.md"    "3-verify/API_CONTRACT_REVIEWS.md"
fi

if [[ "$USE_QUALITY_REQUIREMENTS" == "1" ]]; then
  deploy_optional "templates/init/1-design/INIT_QUALITY_REQUIREMENTS_TEMPLATE.yaml" "1-design/QUALITY_REQUIREMENTS.yaml"
  mkdir -p "$REPO_ROOT/1-design/archive"
  deploy_optional "templates/init/1-design/INIT_QUALITY_REQUIREMENTS_DONE_TEMPLATE.yaml" "1-design/archive/QUALITY_REQUIREMENTS.yaml"
fi

if [[ "$USE_SIGN_OFF" == "1" ]]; then
  deploy_optional "templates/init/3-verify/INIT_SIGN_OFF_TEMPLATE.md" "3-verify/SIGN_OFF.md"
fi

if [[ "$USE_RELEASE_QUEUE" == "1" ]]; then
  deploy_optional "templates/init/4-sync/INIT_RELEASE_QUEUE_TEMPLATE.yaml" "4-sync/RELEASE_QUEUE.yaml"
  mkdir -p "$REPO_ROOT/4-sync/archive"
  deploy_optional "templates/init/4-sync/INIT_RELEASE_QUEUE_DONE_TEMPLATE.yaml" "4-sync/archive/RELEASE_QUEUE.yaml"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Done."
echo "  Project:   $PROJECT_NAME"
echo "  Mode:      $REPO_MODE"
echo "  Component: $COMPONENT_NAME"
echo "  Milestone: $MILESTONE_ID ($TARGET_WINDOW)"
echo ""
echo "Next steps:"
echo "  1. Open SETUP-001 in 2-build/WORK_QUEUE.yaml and 1-design/TASK_READINESS.yaml."
echo "     Confirm the component name ($COMPONENT_NAME) is correct, then complete the task."
echo "  2. Replace the placeholder capability in 1-design/ROADMAP.yaml with your first real capability."
echo "  3. Add your first feature to 1-design/DESIGN_STATES.yaml and WORK_QUEUE.yaml."
echo "  4. Run 'make docs-check' before starting build work."
