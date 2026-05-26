#!/usr/bin/env bash
# Verify that each canonical register's schema_version matches the expected
# version declared in meta/schemas/register-schema-versions.yaml.
# A mismatch means a schema migration was applied (or skipped) without updating
# the register, or the register predates versioning and needs a one-time fix.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REGISTRY="$REPO_ROOT/meta/schemas/register-schema-versions.yaml"

if ! command -v yq &>/dev/null || ! yq --version 2>&1 | grep -q "version v[4-9]"; then
  echo "ERROR: yq v4+ (mikefarah) is required. Run 'make install-tools'." >&2
  exit 1
fi

if [[ ! -f "$REGISTRY" ]]; then
  echo "ERROR: Missing $REGISTRY" >&2
  exit 1
fi

failed=0
count=$(yq '.registers | length' "$REGISTRY")

for i in $(seq 0 $((count - 1))); do
  rel_path=$(yq ".registers[$i].file" "$REGISTRY")
  expected=$(yq ".registers[$i].schema_version" "$REGISTRY")
  abs_path="$REPO_ROOT/$rel_path"

  if [[ ! -f "$abs_path" ]]; then
    echo "SKIP: $rel_path not present (optional or not yet created)"
    continue
  fi

  actual=$(yq '.schema_version // "missing"' "$abs_path")

  if [[ "$actual" == "missing" ]]; then
    echo "SCHEMA VERSION MISSING: $rel_path has no schema_version field (expected $expected)"
    failed=1
  elif [[ "$actual" != "$expected" ]]; then
    echo "SCHEMA VERSION MISMATCH: $rel_path is at schema_version $actual, expected $expected"
    echo "  Apply the schema_change migration from upgrade-notes.md and set schema_version: $expected"
    failed=1
  fi
done

if [[ "$failed" -eq 0 ]]; then
  echo "register schema versions OK"
fi

exit "$failed"
