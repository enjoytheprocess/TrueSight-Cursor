#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
READINESS_FILE="$REPO_ROOT/1-design/TASK_READINESS.yaml"
QUEUE_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"
SECURITY_FILE="$REPO_ROOT/3-verify/SECURITY_REVIEWS.md"
EXPERIMENT_FILE="$REPO_ROOT/3-verify/EXPERIMENT_REVIEWS.md"
INCIDENT_FILE="$REPO_ROOT/3-verify/INCIDENT_RESPONSES.md"
DATA_MIGRATION_FILE="$REPO_ROOT/3-verify/DATA_MIGRATION_REVIEWS.md"
API_CONTRACT_FILE="$REPO_ROOT/3-verify/API_CONTRACT_REVIEWS.md"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$READINESS_FILE" ]]; then
  echo "Missing task readiness file." >&2
  exit 1
fi

declare -A queue_status=()

# Load task statuses from WORK_QUEUE
if [[ -f "$QUEUE_FILE" ]]; then
  while IFS=$'\t' read -r task status; do
    [[ -z "$task" ]] && continue
    queue_status["$task"]="$status"
  done < <(yq '.tasks[] | .id + "\t" + (.status // "")' "$QUEUE_FILE")
fi

had_errors=0
uses_security=0
uses_experiment=0
uses_incident=0
uses_data_migration=0
uses_api_contract=0

while IFS=$'\t' read -r task advisor gate; do
  [[ -z "$task" ]] && continue
  [[ "$advisor" == "none" || -z "$advisor" ]] && continue

  status="${queue_status[$task]:-}"

  case "$advisor" in
    security)        uses_security=1 ;;
    experiment)      uses_experiment=1 ;;
    incident)        uses_incident=1 ;;
    data_migration)  uses_data_migration=1 ;;
    api_contract)    uses_api_contract=1 ;;
    *)
      echo "ERROR: $task uses unsupported advisor_track '$advisor'" >&2
      had_errors=1
      continue
      ;;
  esac

  # Gate cannot still be pending when the task is accepted or done
  if [[ "$gate" == "pending" ]] && [[ "$status" == "accepted" || "$status" == "done" ]]; then
    echo "ERROR: $task has advisor_status=pending but status=$status — analysis must be complete before acceptance" >&2
    had_errors=1
  fi

done < <(yq '.tasks[] | .id + "\t" + (.advisor_track // "") + "\t" + (.advisor_status // "")' "$READINESS_FILE")

# Verify backing files exist when a specialist type is in use
if [[ $uses_security -eq 1 ]] && [[ ! -f "$SECURITY_FILE" ]]; then
  echo "ERROR: tasks use advisor_track=security but 3-verify/SECURITY_REVIEWS.md is missing" >&2
  had_errors=1
fi

if [[ $uses_experiment -eq 1 ]] && [[ ! -f "$EXPERIMENT_FILE" ]]; then
  echo "ERROR: tasks use advisor_track=experiment but 3-verify/EXPERIMENT_REVIEWS.md is missing" >&2
  had_errors=1
fi

if [[ $uses_incident -eq 1 ]] && [[ ! -f "$INCIDENT_FILE" ]]; then
  echo "ERROR: tasks use advisor_track=incident but 3-verify/INCIDENT_RESPONSES.md is missing" >&2
  had_errors=1
fi

if [[ $uses_data_migration -eq 1 ]] && [[ ! -f "$DATA_MIGRATION_FILE" ]]; then
  echo "ERROR: tasks use advisor_track=data_migration but 3-verify/DATA_MIGRATION_REVIEWS.md is missing" >&2
  had_errors=1
fi

if [[ $uses_api_contract -eq 1 ]] && [[ ! -f "$API_CONTRACT_FILE" ]]; then
  echo "ERROR: tasks use advisor_track=api_contract but 3-verify/API_CONTRACT_REVIEWS.md is missing" >&2
  had_errors=1
fi

if [[ $had_errors -ne 0 ]]; then
  exit 1
fi

echo "Advisor track check passed."
