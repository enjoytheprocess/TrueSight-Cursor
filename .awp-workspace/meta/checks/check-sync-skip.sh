#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GD_FILE="$REPO_ROOT/3-verify/GAPS_AND_DEVIATIONS.yaml"
WQ_FILE="$REPO_ROOT/2-build/WORK_QUEUE.yaml"

if [[ ! -f "$GD_FILE" ]]; then
  echo "SKIP: 3-verify/GAPS_AND_DEVIATIONS.yaml not present."
  exit 0
fi

if [[ ! -f "$WQ_FILE" ]]; then
  echo "SKIP: 2-build/WORK_QUEUE.yaml not present."
  exit 0
fi

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

untriaged=$(yq '[.entries[] | select(.status == "open" or .status == "resolved_in_loop")] | length' "$GD_FILE")

if [[ "$untriaged" -eq 0 ]]; then
  echo "Sync skip check passed (no untriaged G&D entries)."
  exit 0
fi

active_tasks=$(yq '[.tasks[] | select(.status == "in_progress" or .status == "awaiting_human_review" or .status == "accepted")] | length' "$WQ_FILE")

if [[ "$active_tasks" -eq 0 ]]; then
  echo "SYNC_SKIP: $untriaged untriaged G&D entr$([ "$untriaged" -eq 1 ] && echo y || echo ies) (open or resolved_in_loop) found with no active Build/Verify tasks."
  echo "Sync must triage GAPS_AND_DEVIATIONS before the next Design session." >&2
  exit 1
fi

echo "Sync skip check passed ($untriaged untriaged entr$([ "$untriaged" -eq 1 ] && echo y || echo ies), $active_tasks active task$([ "$active_tasks" -eq 1 ] && echo "" || echo s) — loop in progress)."
