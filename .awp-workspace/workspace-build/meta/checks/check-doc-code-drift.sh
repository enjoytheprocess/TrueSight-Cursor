#!/usr/bin/env bash

set -euo pipefail

CHECK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$CHECK_DIR/../.." && pwd)"
# shellcheck source=../../scripts/workspace-layout.sh
source "$REPO_ROOT/scripts/workspace-layout.sh"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"
TRACE_FILE="$REPO_ROOT/3-verify/TRACEABILITY_MATRIX.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$QUEUE_FILE" || ! -f "$TRACE_FILE" ]]; then
  echo "Missing queue or traceability file." >&2
  exit 1
fi

declare -A trace_status trace_spec trace_code trace_test
failed=0

trim_ref() {
  local ref="$1"
  ref="${ref#"${ref%%[![:space:]]*}"}"
  ref="${ref%"${ref##*[![:space:]]}"}"
  printf '%s' "$ref"
}

is_external_ref() {
  local ref="$1"
  [[ "$ref" =~ ^repo:[^:@]+(@[^:]+)?:[^[:space:]]+$ ]] || [[ "$ref" =~ ^https?://[^[:space:]]+$ ]]
}

validate_ref_list() {
  local refs="$1"
  local kind="$2"
  local task="$3"
  local feature="$4"
  local had_error=0
  local raw ref

  IFS=',' read -r -a ref_list <<< "$refs"
  for raw in "${ref_list[@]}"; do
    ref="$(trim_ref "$raw")"
    [[ -z "$ref" || "$ref" == "none" ]] && continue
    if is_external_ref "$ref"; then continue; fi
    if ! resolve_repo_path "$ref" >/dev/null 2>&1; then
      echo "ERROR: $task references $feature but traceability $kind entry does not resolve locally: $ref" >&2
      had_error=1
    fi
  done
  return "$had_error"
}

# Load traceability matrix from YAML
# Use | as separator — avoids IFS whitespace-collapsing of empty fields
while IFS='|' read -r feature spec code test status; do
  [[ -z "$feature" ]] && continue
  trace_status["$feature"]="$status"
  trace_spec["$feature"]="$spec"
  trace_code["$feature"]="$code"
  trace_test["$feature"]="$test"
done < <(yq '.features[] | .id + "|" + (.spec_link // "") + "|" + ((.code_links // []) | join(",")) + "|" + ((.test_links // []) | join(",")) + "|" + (.drift_status // "")' "$TRACE_FILE")

# Check each WORK_QUEUE task
while IFS=$'\t' read -r task feature_id phase status validation; do
  [[ -z "$task" ]] && continue

  is_active=0
  case "$phase" in build|verify|sync) is_active=1 ;; esac
  case "$status" in awaiting_human_review|accepted|done) is_active=1 ;; esac
  [[ $is_active -eq 0 ]] && continue

  # feature_id: none = setup/meta task; no traceability required
  [[ -z "$feature_id" || "$feature_id" == "none" ]] && continue

  if [[ -z "$validation" || "$validation" == "none" || "$validation" == "n/a" || "$validation" == "N/A" ]]; then
    echo "ERROR: $task requires a validation entry for drift control"
    failed=1
  fi

  drift_status="${trace_status[$feature_id]:-}"
  spec="${trace_spec[$feature_id]:-}"
  code="${trace_code[$feature_id]:-}"
  test="${trace_test[$feature_id]:-}"

  if [[ -z "$drift_status" ]]; then
    echo "ERROR: $task references $feature_id but no traceability row exists" >&2
    failed=1; continue
  fi

  if [[ -z "$spec" || "$spec" == "n/a" || "$spec" == "N/A" ]]; then
    echo "ERROR: $task references $feature_id but traceability spec_link is empty" >&2
    failed=1
  elif ! is_external_ref "$spec" && ! resolve_repo_path "$spec" >/dev/null 2>&1; then
    echo "ERROR: $task references $feature_id but traceability spec_link does not resolve locally: $spec" >&2
    failed=1
  fi

  if [[ -z "$code" || "$code" == "n/a" || "$code" == "N/A" ]]; then
    echo "ERROR: $task references $feature_id but traceability code_links are empty" >&2
    failed=1
  elif [[ "$drift_status" != "review_needed" ]] && ! validate_ref_list "$code" "code_links" "$task" "$feature_id"; then
    failed=1
  fi

  if [[ "$status" == "accepted" || "$status" == "done" ]]; then
    if [[ -z "$test" || "$test" == "n/a" || "$test" == "N/A" ]]; then
      echo "ERROR: $task references $feature_id but traceability test_links are empty" >&2
      failed=1
    elif [[ "$drift_status" != "review_needed" ]] && ! validate_ref_list "$test" "test_links" "$task" "$feature_id"; then
      failed=1
    fi
  fi

  if [[ "$drift_status" == "drift_detected" ]]; then
    echo "ERROR: $task is active while drift_detected for $feature_id" >&2
    failed=1
  fi

  if [[ "$status" == "accepted" || "$status" == "done" ]] && [[ "$drift_status" != "aligned" ]]; then
    echo "ERROR: $task has status $status but drift_status for $feature_id is $drift_status (must be aligned)" >&2
    failed=1
  fi

done < <(yq '.tasks[] | .id + "\t" + (.feature_id // "") + "\t" + (.phase // "") + "\t" + (.status // "") + "\t" + (.validation // "")' "$QUEUE_FILE")

if [[ $failed -ne 0 ]]; then
  echo "Doc-code drift check failed." >&2
  exit 1
fi

echo "Doc-code drift check passed."
