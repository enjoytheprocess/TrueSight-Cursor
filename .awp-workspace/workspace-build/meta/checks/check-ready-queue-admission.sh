#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
READINESS_FILE="$REPO_ROOT/1-design/TASK_READINESS.yaml"
DESIGN_FILE="$REPO_ROOT/1-design/DESIGN_STATES.yaml"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$READINESS_FILE" || ! -f "$DESIGN_FILE" || ! -f "$QUEUE_FILE" ]]; then
  echo "Missing required file(s) for admission check." >&2
  exit 1
fi

had_errors=0

# ---------------------------------------------------------------------------
# Load DESIGN_STATES
# ---------------------------------------------------------------------------
declare -A design_states=()

while IFS=$'\t' read -r feature design_state; do
  [[ -z "$feature" ]] && continue
  if [[ -n "${design_states[$feature]:-}" ]]; then
    echo "ERROR: duplicate feature in DESIGN_STATES.yaml for $feature" >&2
    had_errors=1; continue
  fi
  case "$design_state" in
    concept|spec_draft|spec_review|ready|needs_redesign) ;;
    *)
      echo "ERROR: $feature has invalid design_state '$design_state' in DESIGN_STATES.yaml" >&2
      had_errors=1; continue
      ;;
  esac
  design_states["$feature"]="$design_state"
done < <(yq '.features[] | .feature_id + "\t" + (.design_state // "")' "$DESIGN_FILE")

# ---------------------------------------------------------------------------
# Load WORK_QUEUE phase/status
# ---------------------------------------------------------------------------
declare -A queue_phase=()
declare -A queue_status=()
declare -A queue_tasks=()

while IFS=$'\t' read -r task phase status; do
  [[ -z "$task" ]] && continue
  queue_tasks["$task"]=1
  queue_phase["$task"]="$phase"
  queue_status["$task"]="$status"
done < <(yq '.tasks[] | .id + "\t" + (.phase // "") + "\t" + (.status // "")' "$QUEUE_FILE")

# ---------------------------------------------------------------------------
# Validate each TASK_READINESS row
# ---------------------------------------------------------------------------
declare -A readiness_tasks=()

while IFS=$'\t' read -r task feature advisor_track advisor_status readiness blocking_unknowns irg_s irg_a irg_i irg_r irg_v; do
  [[ -z "$task" ]] && continue
  readiness_tasks["$task"]=1

  # feature_id: none is allowed for setup/meta tasks that don't map to a product feature
  has_feature=1
  if [[ -z "$feature" || "$feature" == "none" ]]; then
    has_feature=0
  fi

  design_state=""
  if [[ $has_feature -eq 1 ]]; then
    design_state="${design_states[$feature]:-}"
    if [[ -z "$design_state" ]]; then
      echo "ERROR: $task references $feature but no design-state row exists" >&2
      had_errors=1; continue
    fi
  fi

  # Qualitative mode: all irg fields absent — skip numeric validation
  is_qualitative=0
  if [[ -z "$irg_s" && -z "$irg_a" && -z "$irg_i" && -z "$irg_r" && -z "$irg_v" ]]; then
    is_qualitative=1
  fi

  total=0
  if [[ $is_qualitative -eq 0 ]]; then
    for score in "$irg_s" "$irg_a" "$irg_i" "$irg_r" "$irg_v"; do
      case "$score" in
        0|1|2) ;;
        *) echo "ERROR: $task has invalid IRG score '$score'" >&2; had_errors=1 ;;
      esac
    done
    total=$((irg_s + irg_a + irg_i + irg_r + irg_v))
  fi

  if [[ "$advisor_track" == "none" && "$advisor_status" != "not_required" ]]; then
    echo "ERROR: $task has advisor_status=$advisor_status but advisor_track=none" >&2
    had_errors=1
  fi

  if [[ "$readiness" == "ready_for_build" ]]; then
    if [[ $is_qualitative -eq 0 ]]; then
      if (( total < 8 )); then
        echo "ERROR: $task is ready_for_build but IRG total is $total/10 (need >= 8)" >&2
        had_errors=1
      fi
      if [[ "$irg_a" != "2" ]]; then
        echo "ERROR: $task is ready_for_build but IRG Acceptance (A) is not 2 — acceptance criteria must be fully defined before build" >&2
        had_errors=1
      fi
      if [[ "$irg_i" != "2" ]]; then
        echo "ERROR: $task is ready_for_build but IRG Interfaces (I) is not 2 — interface contracts must be clear before build" >&2
        had_errors=1
      fi
    fi
    if [[ "$blocking_unknowns" != "none" ]]; then
      echo "ERROR: $task is ready_for_build but blocking_unknowns is not none ($blocking_unknowns)" >&2
      had_errors=1
    fi
    if [[ $has_feature -eq 1 && "$design_state" != "ready" ]]; then
      echo "ERROR: $task is ready_for_build but linked feature design state is $design_state" >&2
      had_errors=1
    fi
    if [[ "$advisor_track" != "none" && "$advisor_status" == "pending" ]]; then
      echo "ERROR: $task is ready_for_build but advisor_status is still pending" >&2
      had_errors=1
    fi
    phase="${queue_phase[$task]:-}"
    if [[ -n "$phase" && "$phase" == "design" ]]; then
      echo "ERROR: $task is ready_for_build but still phase=design in WORK_QUEUE — promote to phase=build" >&2
      had_errors=1
    fi
  fi

  if [[ "$readiness" == "needs_detail" && $is_qualitative -eq 0 ]]; then
    feature_ready=$([[ $has_feature -eq 0 || "$design_state" == "ready" ]] && echo 1 || echo 0)
    if (( total >= 8 )) && [[ "$irg_a" == "2" && "$irg_i" == "2" \
        && "$blocking_unknowns" == "none" && "$feature_ready" == "1" \
        && "$advisor_status" != "pending" ]]; then
      echo "ERROR: $task is needs_detail but its IRG and linked design state indicate ready_for_build" >&2
      had_errors=1
    fi
  fi

  wq_status="${queue_status[$task]:-}"
  if [[ "$wq_status" == "needs_rework" && "$readiness" != "needs_detail" ]]; then
    echo "ERROR: $task has status=needs_rework in WORK_QUEUE but readiness=$readiness (must be needs_detail)" >&2
    had_errors=1
  fi

done < <(yq '.tasks[] | .id + "\t" + (.feature_id // "") + "\t" + (.advisor_track // "") + "\t" + (.advisor_status // "") + "\t" + (.readiness // "") + "\t" + (.blocking_unknowns // "") + "\t" + ((.irg.S // "")|tostring) + "\t" + ((.irg.A // "")|tostring) + "\t" + ((.irg.I // "")|tostring) + "\t" + ((.irg.R // "")|tostring) + "\t" + ((.irg.V // "")|tostring)' "$READINESS_FILE")

# ---------------------------------------------------------------------------
# Cross-file: WORK_QUEUE terminal statuses require readiness record
# ---------------------------------------------------------------------------
for task in "${!queue_tasks[@]}"; do
  wq_status="${queue_status[$task]}"
  case "$wq_status" in
    awaiting_human_review|accepted|done)
      if [[ -z "${readiness_tasks[$task]:-}" ]]; then
        echo "ERROR: $task has status=$wq_status in WORK_QUEUE but has no row in TASK_READINESS" >&2
        had_errors=1
      fi
      ;;
  esac
done

if [[ $had_errors -ne 0 ]]; then
  exit 1
fi

echo "Ready queue admission check passed."
