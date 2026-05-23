#!/usr/bin/env bash
set -euo pipefail

# migrate-plan.sh — show which register schema migrations need to be applied.
#
# Compares the schema_version in each live register YAML against the expected
# version in meta/schemas/register-schema-versions.yaml, then extracts the
# matching schema_change blocks from upgrade-notes.md so the sideload agent
# knows exactly what to apply.
#
# Usage (from repo root):
#   ./scripts/migrate-plan.sh [path/to/upgrade-notes.md]
#
# The optional argument defaults to upgrade-notes.md in the repo root.
# When upgrading from a sideload bundle, pass the bundle's upgrade-notes.md:
#   ./scripts/migrate-plan.sh .workspace-template-inbox/<version>/upgrade-notes.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
UPGRADE_NOTES="${1:-$REPO_ROOT/upgrade-notes.md}"
SCHEMA_VERSIONS_FILE="$REPO_ROOT/meta/schemas/register-schema-versions.yaml"

if [[ ! -f "$SCHEMA_VERSIONS_FILE" ]]; then
  echo "ERROR: $SCHEMA_VERSIONS_FILE not found" >&2
  exit 1
fi

if [[ ! -f "$UPGRADE_NOTES" ]]; then
  echo "ERROR: $UPGRADE_NOTES not found" >&2
  exit 1
fi

# ── Parse register-schema-versions.yaml ──────────────────────────────────────
# Simple line-by-line scan; avoids a yq/python dependency for parsing.
declare -a migration_files=()
declare -a ok_files=()

current_file=""
while IFS= read -r line; do
  # Match:   - file: "path/to/file.yaml"
  if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*file:[[:space:]]*\"?([^\"#[:space:]]+)\"? ]]; then
    current_file="${BASH_REMATCH[1]}"
    continue
  fi
  # Match:     schema_version: N
  if [[ "$line" =~ ^[[:space:]]*schema_version:[[:space:]]*([0-9]+) && -n "$current_file" ]]; then
    expected="${BASH_REMATCH[1]}"
    live="$REPO_ROOT/$current_file"
    if [[ ! -f "$live" ]]; then
      ok_files+=("  skip      $current_file  (not present in this repo)")
      current_file=""
      continue
    fi
    actual=$(grep -m1 '^schema_version:' "$live" 2>/dev/null | awk '{print $2}') || true
    actual="${actual:-0}"
    if [[ "$actual" -lt "$expected" ]]; then
      migration_files+=("$current_file:::$actual:::$expected")
    else
      ok_files+=("  ok  v$actual  $current_file")
    fi
    current_file=""
  fi
done < "$SCHEMA_VERSIONS_FILE"

# ── Status summary ────────────────────────────────────────────────────────────
echo "=== Register migration status ==="
echo ""
for entry in "${ok_files[@]}"; do
  echo "$entry"
done

if [[ "${#migration_files[@]}" -gt 0 ]]; then
  echo ""
  for entry in "${migration_files[@]}"; do
    IFS=':::' read -r file actual expected <<< "$entry"
    echo "  MIGRATE  $file  (v${actual} → v${expected})"
  done
fi

echo ""

if [[ "${#migration_files[@]}" -eq 0 ]]; then
  echo "All registers are at the expected schema version. No migrations needed."
  exit 0
fi

# ── Extract matching schema_change blocks ─────────────────────────────────────
echo "=== Applicable schema_change blocks ==="
echo ""
echo "Apply these blocks in the order they appear (oldest release first)."
echo "After each migration, set schema_version in the register file to the block's schema_version value."
echo ""

# Build a list of file names to match against block content
declare -a target_files=()
for entry in "${migration_files[@]}"; do
  IFS=':::' read -r file actual expected <<< "$entry"
  target_files+=("$file")
done

if ! command -v python3 &>/dev/null; then
  echo "python3 not found. Search upgrade-notes.md manually for schema_change blocks"
  echo "that reference the following files:"
  for f in "${target_files[@]}"; do
    echo "  $f"
  done
  exit 0
fi

python3 - "$UPGRADE_NOTES" "${target_files[@]}" <<'PYEOF'
import sys
import re

notes_file = sys.argv[1]
target_files = set(sys.argv[2:])

with open(notes_file) as f:
    content = f.read()

# Extract ```yaml ... ``` code fences that contain schema_change blocks
blocks = re.findall(r'```yaml(.*?)```', content, re.DOTALL)

found = 0
for block in blocks:
    stripped = block.strip()
    if not stripped.startswith('schema_change:'):
        continue
    # Check if this block mentions any of the files that need migration
    for tf in target_files:
        if tf in stripped:
            print(stripped)
            print()
            found += 1
            break

if found == 0:
    print("No matching schema_change blocks found in the provided upgrade-notes.md.")
    print("The sideloaded bundle's upgrade-notes.md may have the applicable blocks.")
PYEOF
