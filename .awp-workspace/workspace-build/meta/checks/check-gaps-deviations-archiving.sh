#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GD_FILE="$REPO_ROOT/3-verify/GAPS_AND_DEVIATIONS.yaml"

if [[ ! -f "$GD_FILE" ]]; then
  echo "SKIP: 3-verify/GAPS_AND_DEVIATIONS.yaml not present."
  exit 0
fi

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

failed=0

# promoted_to_sync entries should have been moved to archive/ immediately after
# Sync created the corresponding DESIGN_INPUTS entry. Finding them in the active
# file means Sync archiving is incomplete.
while IFS=$'\t' read -r id status; do
  [[ -z "$id" ]] && continue
  if [[ "$status" == "promoted_to_sync" ]]; then
    echo "UNARCHIVED: $id has status=promoted_to_sync — move to 3-verify/archive/GAPS_AND_DEVIATIONS.yaml after Sync creates the DESIGN_INPUTS entry"
    failed=1
  fi
done < <(yq '.entries[] | .id + "\t" + (.status // "")' "$GD_FILE")

if [[ $failed -ne 0 ]]; then
  echo "Gaps and deviations archiving check failed." >&2
  exit 1
fi

echo "Gaps and deviations archiving check passed."
