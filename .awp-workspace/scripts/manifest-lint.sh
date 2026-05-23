#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="${1:-$REPO_ROOT/workspace.manifest.yaml}"

if [[ ! -f "$MANIFEST" ]]; then
  echo "ERROR: manifest file not found: $MANIFEST" >&2
  exit 1
fi

# shellcheck source=scripts/manifest-lib.sh
source "$SCRIPT_DIR/manifest-lib.sh"
manifest_validate "$MANIFEST"
