#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"
DEPENDENCIES_FILE="$REPO_ROOT/2-build/TASK_DEPENDENCIES.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$QUEUE_FILE" ]]; then
  echo "Missing queue file." >&2
  exit 1
fi

if [[ ! -f "$DEPENDENCIES_FILE" ]]; then
  echo "SKIP: 2-build/TASK_DEPENDENCIES.yaml not present."
  exit 0
fi

normalize_dep_list() {
  local value="${1:-}"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  if [[ -z "$value" || "$value" == "none" ]]; then
    printf 'none'
    return
  fi
  printf '%s\n' "$value" \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
    | sed '/^$/d' \
    | sort -u \
    | paste -sd ',' -
}

dep_groups_overlap() {
  local left="${1:-}"
  local right="${2:-}"
  local left_item right_item

  [[ "$left" == "none" || "$right" == "none" ]] && return 1

  IFS=',' read -r -a left_items <<< "$left"
  IFS=',' read -r -a right_items <<< "$right"
  for left_item in "${left_items[@]}"; do
    for right_item in "${right_items[@]}"; do
      [[ "$left_item" == "$right_item" ]] && return 0
    done
  done
  return 1
}

declare -A queue_exists queue_build queue_design
declare -A dep_exists dep_build dep_design dep_unblocks

while IFS=$'\t' read -r task build_dependencies design_dependencies; do
  [[ -z "$task" ]] && continue
  queue_exists["$task"]=1
  queue_build["$task"]="$(normalize_dep_list "$build_dependencies")"
  queue_design["$task"]="$(normalize_dep_list "$design_dependencies")"
done < <(yq '.tasks[] | .id + "\t" + (.build_dependencies // "") + "\t" + (.design_dependencies // "")' "$QUEUE_FILE")

while IFS=$'\t' read -r task build design unblocks; do
  [[ -z "$task" ]] && continue
  if [[ -n "${dep_exists[$task]:-}" ]]; then
    echo "ERROR: duplicate dependency register row for $task" >&2
    exit 1
  fi
  dep_exists["$task"]=1
  dep_build["$task"]="$(normalize_dep_list "$build")"
  dep_design["$task"]="$(normalize_dep_list "$design")"
  dep_unblocks["$task"]="$(normalize_dep_list "$unblocks")"
done < <(yq '.tasks[] | .id + "\t" + (.build_depends_on // "") + "\t" + (.design_depends_on // "") + "\t" + (.unblocks // "")' "$DEPENDENCIES_FILE")

for task in "${!queue_exists[@]}"; do
  if [[ -z "${dep_exists[$task]:-}" ]]; then
    echo "ERROR: $task exists in WORK_QUEUE.yaml but not in TASK_DEPENDENCIES.yaml" >&2
    exit 1
  fi

  if [[ "${queue_build[$task]}" != "${dep_build[$task]}" ]]; then
    echo "ERROR: $task build_dependencies differ between queue (${queue_build[$task]}) and dependency register (${dep_build[$task]})" >&2
    exit 1
  fi

  if [[ "${queue_design[$task]}" != "${dep_design[$task]}" ]]; then
    echo "ERROR: $task design_dependencies differ between queue (${queue_design[$task]}) and dependency register (${dep_design[$task]})" >&2
    exit 1
  fi

  if dep_groups_overlap "${queue_build[$task]}" "${queue_design[$task]}"; then
    echo "ERROR: $task lists the same task in both build_dependencies and design_dependencies" >&2
    exit 1
  fi
done

for task in "${!dep_exists[@]}"; do
  if [[ -z "${queue_exists[$task]:-}" ]]; then
    echo "ERROR: $task exists in TASK_DEPENDENCIES.yaml but not in WORK_QUEUE.yaml" >&2
    exit 1
  fi

  for dep_group in "${dep_build[$task]}" "${dep_design[$task]}" "${dep_unblocks[$task]}"; do
    [[ "$dep_group" == "none" ]] && continue
    IFS=',' read -r -a dep_items <<< "$dep_group"
    for dep in "${dep_items[@]}"; do
      if [[ -z "${queue_exists[$dep]:-}" ]]; then
        echo "ERROR: $task references unknown dependency task $dep" >&2
        exit 1
      fi
    done
  done
done

echo "Task dependency consistency check passed."
