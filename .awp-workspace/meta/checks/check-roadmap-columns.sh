#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ROADMAP_FILE="$REPO_ROOT/1-design/ROADMAP.yaml"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$ROADMAP_FILE" || ! -f "$QUEUE_FILE" ]]; then
  echo "Required roadmap or queue file missing." >&2
  exit 1
fi

failed=0

required_fields=(id objective feature_ids depends_on status notes)

for field in "${required_fields[@]}"; do
  count=$(yq "[.capabilities[] | select(has(\"$field\") | not)] | length" "$ROADMAP_FILE")
  if [[ "$count" -gt "0" ]]; then
    echo "MISSING FIELD: '$field' absent in $count capability(s)"
    failed=1
  fi
done

declare -A capabilities

while IFS=$'\t' read -r id target_window status; do
  [[ -z "$id" ]] && continue
  if [[ -n "${capabilities[$id]:-}" ]]; then
    echo "ERROR: duplicate capability '$id' in ROADMAP.yaml"
    failed=1; continue
  fi
  capabilities["$id"]="$status"
  case "$status" in
    planned|active|at_risk|completed|parked) ;;
    *) echo "ERROR: capability $id has invalid status '$status'"; failed=1 ;;
  esac
done < <(yq '.capabilities[] | .id + "\t" + (.target_window // "") + "\t" + (.status // "")' "$ROADMAP_FILE")

while IFS=$'\t' read -r task feature_id phase status capability target_window; do
  [[ -z "$task" ]] && continue

  is_active=0
  case "$phase" in build|verify|sync) is_active=1 ;; esac
  case "$status" in awaiting_human_review|accepted|done) is_active=1 ;; esac

  # Feature tasks (feature_id != none) must be anchored to a capability when active.
  # Non-feature tasks (feature_id: none) are exempt — they are infrastructure,
  # tooling, or setup work that does not map to a feature capability.
  if [[ $is_active -eq 1 && "$feature_id" != "none" ]]; then
    if [[ -z "$capability" || "$capability" == "none" ]]; then
      echo "ERROR: $task has feature_id=$feature_id but no capability — feature tasks must reference a capability; use feature_id: none to exempt non-feature tasks"
      failed=1
    fi
  fi

  if [[ -n "$capability" && "$capability" != "none" && "$capability" != "BACKLOG" ]]; then
    if [[ -z "${capabilities[$capability]:-}" ]]; then
      echo "ERROR: $task references unknown capability '$capability'"
      failed=1
    fi
  fi
done < <(yq '.tasks[] | .id + "\t" + (.feature_id // "") + "\t" + (.phase // "") + "\t" + (.status // "") + "\t" + (.capability // "") + "\t" + (.target_window // "")' "$QUEUE_FILE")

ROADMAP_DONE_FILE="$REPO_ROOT/1-design/archive/ROADMAP.yaml"
if [[ -f "$ROADMAP_DONE_FILE" ]]; then
  for field in id objective feature_ids depends_on status notes; do
    count=$(yq "[.capabilities[] | select(has(\"$field\") | not)] | length" "$ROADMAP_DONE_FILE")
    if [[ "$count" -gt "0" ]]; then
      echo "MISSING FIELD (DONE): '$field' absent in $count capability(s)"
      failed=1
    fi
  done

  while IFS=$'\t' read -r id status; do
    [[ -z "$id" ]] && continue
    case "$status" in
      planned|active|at_risk|completed|parked) ;;
      *) echo "ERROR (DONE): capability $id has invalid status '$status'"; failed=1 ;;
    esac
  done < <(yq '.capabilities[] | .id + "\t" + (.status // "")' "$ROADMAP_DONE_FILE")
fi

if [[ $failed -ne 0 ]]; then
  echo "Roadmap coverage check failed." >&2
  exit 1
fi

echo "Roadmap coverage check passed."
