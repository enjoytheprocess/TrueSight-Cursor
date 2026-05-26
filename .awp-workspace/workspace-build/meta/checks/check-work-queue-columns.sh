#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$QUEUE_FILE" ]]; then
  echo "Missing WORK_QUEUE.yaml" >&2
  exit 1
fi

failed=0

required_fields=(id feature_id title component spec_link advisor_status advisor_track quality_requirements decision_links priority phase capability mode lock_id status build_dependencies design_dependencies validation notes)

for field in "${required_fields[@]}"; do
  count=$(yq "[.tasks[] | select(has(\"$field\") | not)] | length" "$QUEUE_FILE")
  if [[ "$count" -gt "0" ]]; then
    echo "MISSING FIELD: '$field' absent in $count task(s)"
    failed=1
  fi
done

while IFS=$'\t' read -r id phase mode status advisor_status advisor_track; do
  [[ -z "$id" ]] && continue
  case "$phase" in
    design|build|verify|sync) ;;
    *) echo "ERROR: $id has invalid phase '$phase'"; failed=1 ;;
  esac
  case "$mode" in
    sequential|parallel) ;;
    *) echo "ERROR: $id has invalid mode '$mode'"; failed=1 ;;
  esac
  case "$status" in
    todo|in_progress|blocked|awaiting_human_review|accepted|done|needs_rework) ;;
    *) echo "ERROR: $id has invalid status '$status'"; failed=1 ;;
  esac
  case "$advisor_status" in
    not_required|pending|complete) ;;
    *) echo "ERROR: $id has invalid advisor_status '$advisor_status'"; failed=1 ;;
  esac
  case "$advisor_track" in
    none|security|experiment|incident|data_migration|api_contract) ;;
    *) echo "ERROR: $id has invalid advisor_track '$advisor_track'"; failed=1 ;;
  esac
done < <(yq '.tasks[] | .id + "\t" + (.phase // "") + "\t" + (.mode // "") + "\t" + (.status // "") + "\t" + (.advisor_status // "") + "\t" + (.advisor_track // "")' "$QUEUE_FILE")

DONE_FILE="$REPO_ROOT/2-build/archive/WORK_QUEUE.yaml"
if [[ -f "$DONE_FILE" ]]; then
  for field in "${required_fields[@]}"; do
    count=$(yq "[.tasks[] | select(has(\"$field\") | not)] | length" "$DONE_FILE")
    if [[ "$count" -gt "0" ]]; then
      echo "MISSING FIELD (DONE): '$field' absent in $count task(s)"
      failed=1
    fi
  done

  while IFS=$'\t' read -r id phase mode status advisor_status advisor_track; do
    [[ -z "$id" ]] && continue
    case "$phase" in
      design|build|verify|sync) ;;
      *) echo "ERROR (DONE): $id has invalid phase '$phase'"; failed=1 ;;
    esac
    case "$mode" in
      sequential|parallel) ;;
      *) echo "ERROR (DONE): $id has invalid mode '$mode'"; failed=1 ;;
    esac
    case "$status" in
      todo|in_progress|blocked|awaiting_human_review|accepted|done|needs_rework) ;;
      *) echo "ERROR (DONE): $id has invalid status '$status'"; failed=1 ;;
    esac
    case "$advisor_status" in
      not_required|pending|complete) ;;
      *) echo "ERROR (DONE): $id has invalid advisor_status '$advisor_status'"; failed=1 ;;
    esac
    case "$advisor_track" in
      none|security|experiment|incident|data_migration|api_contract) ;;
      *) echo "ERROR (DONE): $id has invalid advisor_track '$advisor_track'"; failed=1 ;;
    esac
  done < <(yq '.tasks[] | .id + "\t" + (.phase // "") + "\t" + (.mode // "") + "\t" + (.status // "") + "\t" + (.advisor_status // "") + "\t" + (.advisor_track // "")' "$DONE_FILE")
fi

if [[ $failed -ne 0 ]]; then
  echo "Queue column check failed." >&2
  exit 1
fi

echo "Queue column check passed."
