#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
READINESS_FILE="$REPO_ROOT/1-design/TASK_READINESS.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$READINESS_FILE" ]]; then
  echo "Missing TASK_READINESS.yaml" >&2
  exit 1
fi

failed=0

required_fields=(id feature_id title component spec_link irg blocking_unknowns readiness advisor_track advisor_status quality_requirements decision_links notes)

for field in "${required_fields[@]}"; do
  count=$(yq "[.tasks[] | select(has(\"$field\") | not)] | length" "$READINESS_FILE")
  if [[ "$count" -gt "0" ]]; then
    echo "MISSING FIELD: '$field' absent in $count task(s)"
    failed=1
  fi
done

for dim in S A I R V; do
  count=$(yq "[.tasks[] | select(.irg | has(\"$dim\") | not)] | length" "$READINESS_FILE")
  if [[ "$count" -gt "0" ]]; then
    echo "MISSING IRG DIMENSION: '$dim' absent in $count task(s)"
    failed=1
  fi
done

while IFS=$'\t' read -r id readiness advisor_status s a i r v; do
  [[ -z "$id" ]] && continue
  case "$readiness" in
    needs_detail|ready_for_build) ;;
    *) echo "ERROR: $id has invalid readiness '$readiness'"; failed=1 ;;
  esac
  case "$advisor_status" in
    not_required|pending|complete) ;;
    *) echo "ERROR: $id has invalid advisor_status '$advisor_status'"; failed=1 ;;
  esac
  for score in "$s" "$a" "$i" "$r" "$v"; do
    case "$score" in
      0|1|2) ;;
      *) echo "ERROR: $id has invalid IRG score '$score'"; failed=1 ;;
    esac
  done
done < <(yq '.tasks[] | .id + "\t" + (.readiness // "") + "\t" + (.advisor_status // "") + "\t" + (.irg.S|tostring) + "\t" + (.irg.A|tostring) + "\t" + (.irg.I|tostring) + "\t" + (.irg.R|tostring) + "\t" + (.irg.V|tostring)' "$READINESS_FILE")

if [[ $failed -ne 0 ]]; then
  echo "Task readiness column check failed." >&2
  exit 1
fi

echo "Task readiness column check passed."
