#!/usr/bin/env bash
# Compact workflow status summary for agent startup context.
# Usage: ./scripts/workspace-status.sh
#        make workflow-status

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v yq &>/dev/null; then
  echo "ERROR: yq is required. See https://github.com/mikefarah/yq" >&2
  exit 1
fi

# Count entries in array_key where field==value
_count() {
  local file="$1" arr="$2" field="$3" val="$4"
  yq "[.${arr}[] | select(.${field} == \"${val}\")] | length" "$file" 2>/dev/null || echo 0
}

# List id + title for matching entries (indented)
_list() {
  local file="$1" arr="$2" field="$3" val="$4"
  yq ".${arr}[] | select(.${field} == \"${val}\") | \"    \" + .id + \" · \" + (.title // .summary // .objective // .id)" \
    "$file" 2>/dev/null || true
}

# Length of an array key (returns 0 on missing key or empty)
_len() {
  local n
  n=$(yq ".${2} // [] | length" "$1" 2>/dev/null) || n=0
  echo "${n:-0}"
}

SEP="─────────────────────────────────────────"
branch="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
dirty_flag=""
[[ -n "$(git -C "$REPO_ROOT" status --porcelain 2>/dev/null)" ]] && dirty_flag=" (dirty)"

echo "=== WORKSPACE STATUS === $(date '+%Y-%m-%d') | branch: ${branch}${dirty_flag}"
echo "$SEP"

# ── Work Queue ──────────────────────────────────────────────────
WQ="$REPO_ROOT/2-build/WORK_QUEUE.yaml"
if [[ -f "$WQ" ]]; then
  echo "WORK QUEUE"
  for st in in_progress blocked awaiting_human_review needs_rework; do
    n=$(_count "$WQ" tasks status "$st")
    if [[ "$n" -gt 0 ]]; then
      printf "  %-32s (%d)\n" "$st" "$n"
      _list "$WQ" tasks status "$st"
    fi
  done
  todo=$(_count "$WQ" tasks status todo)
  accepted=$(_count "$WQ" tasks status accepted)
  done_=$(_count "$WQ" tasks status done)
  echo "  todo: ${todo}  accepted: ${accepted}  done: ${done_}"
  echo ""
fi

# ── Task Readiness ───────────────────────────────────────────────
TR="$REPO_ROOT/1-design/TASK_READINESS.yaml"
if [[ -f "$TR" ]] && [[ "$(_len "$TR" tasks)" -gt 0 ]]; then
  rtb=$(_count "$TR" tasks readiness ready_for_build)
  nd=$(_count "$TR" tasks readiness needs_detail)
  if [[ "$rtb" -gt 0 || "$nd" -gt 0 ]]; then
    echo "TASK READINESS"
    [[ "$rtb" -gt 0 ]] && printf "  ready_for_build:  %d\n" "$rtb"
    [[ "$nd"  -gt 0 ]] && printf "  needs_detail:     %d\n" "$nd"
    echo ""
  fi
fi

# ── Design States ────────────────────────────────────────────────
DS="$REPO_ROOT/1-design/DESIGN_STATES.yaml"
if [[ -f "$DS" ]] && [[ "$(_len "$DS" features)" -gt 0 ]]; then
  echo "DESIGN STATES"
  for state in needs_redesign spec_draft spec_review concept ready complete; do
    n=$(_count "$DS" features design_state "$state")
    if [[ "$n" -gt 0 ]]; then
      if [[ "$state" == "needs_redesign" ]]; then
        printf "  %-22s (%d)  ← needs attention\n" "$state" "$n"
        _list "$DS" features design_state "$state"
      else
        printf "  %-22s (%d)\n" "$state" "$n"
      fi
    fi
  done
  echo ""
fi

# ── Attention ────────────────────────────────────────────────────
echo "ATTENTION"

GD="$REPO_ROOT/3-verify/GAPS_AND_DEVIATIONS.yaml"
if [[ -f "$GD" ]]; then
  open_gd=$(_count "$GD" entries status open)
  printf "  Gaps/Deviations open:   %d\n" "$open_gd"
fi

DI="$REPO_ROOT/4-sync/DESIGN_INPUTS.yaml"
if [[ -f "$DI" ]]; then
  open_di=$(_count "$DI" items status open)
  printf "  Design Inputs open:     %d\n" "$open_di"
fi

FM="$REPO_ROOT/3-verify/FEEDBACK_MATRIX.yaml"
if [[ -f "$FM" ]] && [[ "$(_len "$FM" entries)" -gt 0 ]]; then
  open_fm=$(_count "$FM" entries status open)
  printf "  Feedback open:          %d\n" "$open_fm"
fi

echo "$SEP"
