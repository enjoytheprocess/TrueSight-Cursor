#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"
LOCKS_FILE="$REPO_ROOT/2-build/LOCKS.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$QUEUE_FILE" ]]; then
  echo "Missing queue file." >&2
  exit 1
fi

if [[ ! -f "$LOCKS_FILE" ]]; then
  echo "SKIP: 2-build/LOCKS.yaml not present."
  exit 0
fi

declare -A required_lock_task required_lock_owner queue_mode queue_status
declare -A active_lock_task active_lock_owner

while IFS=$'\t' read -r task mode status lock_id owner; do
  [[ -z "$task" ]] && continue
  queue_mode["$task"]="$mode"
  queue_status["$task"]="$status"

  if [[ "$mode" == "parallel" && "$status" == "in_progress" ]]; then
    if [[ -z "$lock_id" || "$lock_id" == "none" ]]; then
      echo "ERROR: $task is parallel and in_progress but lock_id is '$lock_id'" >&2
      exit 1
    fi
    if [[ -z "$owner" || "$owner" == "unassigned" ]]; then
      echo "ERROR: $task is parallel and in_progress but owner is '$owner'" >&2
      exit 1
    fi
    required_lock_task["$lock_id"]="$task"
    required_lock_owner["$lock_id"]="$owner"
  fi
done < <(yq '.tasks[] | .id + "\t" + (.mode // "") + "\t" + (.status // "") + "\t" + (.lock_id // "") + "\t" + (.owner // "")' "$QUEUE_FILE")

while IFS=$'\t' read -r lock_id task_id owner status; do
  [[ -z "$lock_id" ]] && continue
  if [[ "$status" == "active" ]]; then
    if [[ -n "${active_lock_task[$lock_id]:-}" ]]; then
      echo "ERROR: duplicate active lock row for $lock_id" >&2
      exit 1
    fi
    active_lock_task["$lock_id"]="$task_id"
    active_lock_owner["$lock_id"]="$owner"
  fi
done < <(yq '.locks[] | .id + "\t" + (.task_id // "") + "\t" + (.owner // "") + "\t" + (.status // "")' "$LOCKS_FILE")

for lock_id in "${!required_lock_task[@]}"; do
  if [[ -z "${active_lock_task[$lock_id]:-}" ]]; then
    echo "ERROR: queue requires active lock $lock_id but it is missing from LOCKS.yaml" >&2
    exit 1
  fi

  if [[ "${required_lock_task[$lock_id]}" != "${active_lock_task[$lock_id]}" ]]; then
    echo "ERROR: lock $lock_id task_id mismatch between queue (${required_lock_task[$lock_id]}) and LOCKS.yaml (${active_lock_task[$lock_id]})" >&2
    exit 1
  fi

  if [[ "${required_lock_owner[$lock_id]}" != "${active_lock_owner[$lock_id]}" ]]; then
    echo "ERROR: lock $lock_id owner mismatch between queue (${required_lock_owner[$lock_id]}) and LOCKS.yaml (${active_lock_owner[$lock_id]})" >&2
    exit 1
  fi
done

for lock_id in "${!active_lock_task[@]}"; do
  task="${active_lock_task[$lock_id]}"
  if [[ -z "${queue_mode[$task]:-}" ]]; then
    echo "ERROR: active lock $lock_id references unknown task $task" >&2
    exit 1
  fi

  if [[ "${queue_mode[$task]}" != "parallel" || "${queue_status[$task]}" != "in_progress" ]]; then
    echo "ERROR: active lock $lock_id references $task but queue mode/status is ${queue_mode[$task]}/${queue_status[$task]}" >&2
    exit 1
  fi
done

echo "Lock discipline check passed."
