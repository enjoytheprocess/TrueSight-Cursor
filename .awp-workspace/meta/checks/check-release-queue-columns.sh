#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
QUEUE_FILE="$REPO_ROOT/4-sync/RELEASE_QUEUE.yaml"

if [[ ! -f "$QUEUE_FILE" ]]; then
  echo "SKIP: 4-sync/RELEASE_QUEUE.yaml not present (optional)."
  exit 0
fi

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

entry_count=$(yq '.entries | length' "$QUEUE_FILE")
if [[ "$entry_count" -eq 0 ]]; then
  echo "Release queue column check passed (no entries)."
  exit 0
fi

failed=0

required_fields=(id release_version release_type release_state task_ids capability_ids components created_date target_date notes)

for field in "${required_fields[@]}"; do
  count=$(yq "[.entries[] | select(has(\"$field\") | not)] | length" "$QUEUE_FILE")
  if [[ "$count" -gt "0" ]]; then
    echo "MISSING FIELD: '$field' absent in $count release queue entry/entries"
    failed=1
  fi
done

# Validate each component entry has name and version
while IFS=$'\t' read -r entry_id comp_name comp_version; do
  [[ -z "$entry_id" ]] && continue
  if [[ -z "$comp_name" ]]; then
    echo "ERROR: $entry_id has a component entry missing 'name'"; failed=1
  fi
  if [[ -z "$comp_version" ]]; then
    echo "ERROR: $entry_id has a component entry missing 'version'"; failed=1
  fi
done < <(yq '.entries[] | .id as $id | .components[]? | [$id, (.name // ""), (.version // "")] | join("\t")' "$QUEUE_FILE")

while IFS=$'\t' read -r id release_type release_state; do
  [[ -z "$id" ]] && continue
  case "$release_type" in
    feature|bugfix|performance|architecture|mixed) ;;
    *) echo "ERROR: $id has invalid release_type '$release_type'"; failed=1 ;;
  esac
  case "$release_state" in
    candidate|released|abandoned) ;;
    *) echo "ERROR: $id has invalid release_state '$release_state'"; failed=1 ;;
  esac
done < <(yq '.entries[] | .id + "\t" + (.release_type // "") + "\t" + (.release_state // "")' "$QUEUE_FILE")

if [[ $failed -ne 0 ]]; then
  echo "Release queue column check failed." >&2
  exit 1
fi

echo "Release queue column check passed."
