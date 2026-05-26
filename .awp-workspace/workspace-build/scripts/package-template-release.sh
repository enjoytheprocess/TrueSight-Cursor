#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
METADATA_FILE="$REPO_ROOT/template-release.yaml"

get_metadata_value() {
  local key="$1"

  awk -F': ' -v key="$key" '
  $1 == key {
    print $2
    exit
  }
  ' "$METADATA_FILE"
}

if [[ ! -f "$METADATA_FILE" ]]; then
  echo "ERROR: missing template metadata: $METADATA_FILE" >&2
  exit 1
fi

TEMPLATE_NAME="$(get_metadata_value "template_name")"
RELEASE_VERSION="$(get_metadata_value "release_version")"
RELEASE_DATE="$(get_metadata_value "release_date")"
BUNDLE_INDEX_REL="$(get_metadata_value "bundle_paths_file")"

if [[ -z "$TEMPLATE_NAME" || -z "$RELEASE_VERSION" || -z "$RELEASE_DATE" || -z "$BUNDLE_INDEX_REL" ]]; then
  echo "ERROR: template-release.yaml is missing required top-level fields" >&2
  exit 1
fi

BUNDLE_INDEX="$REPO_ROOT/$BUNDLE_INDEX_REL"
if [[ ! -f "$BUNDLE_INDEX" ]]; then
  echo "ERROR: bundle path index not found: $BUNDLE_INDEX" >&2
  exit 1
fi

OUTPUT_DIR_INPUT="${1:-/tmp/workspace-template-releases}"
if [[ "$OUTPUT_DIR_INPUT" = /* ]]; then
  OUTPUT_DIR="$OUTPUT_DIR_INPUT"
else
  OUTPUT_DIR="$REPO_ROOT/$OUTPUT_DIR_INPUT"
fi

BUNDLE_NAME="${TEMPLATE_NAME}-${RELEASE_VERSION}"
BUNDLE_DIR="$OUTPUT_DIR/$BUNDLE_NAME"
ARCHIVE_PATH="$OUTPUT_DIR/${BUNDLE_NAME}.tar.gz"

if [[ -e "$BUNDLE_DIR" ]]; then
  echo "ERROR: bundle directory already exists: $BUNDLE_DIR" >&2
  exit 1
fi

if [[ -e "$ARCHIVE_PATH" ]]; then
  echo "ERROR: bundle archive already exists: $ARCHIVE_PATH" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

while IFS= read -r rel_path; do
  [[ -z "$rel_path" || "${rel_path:0:1}" == "#" ]] && continue

  src="$REPO_ROOT/$rel_path"
  dest="$BUNDLE_DIR/$rel_path"

  if [[ ! -e "$src" ]]; then
    echo "ERROR: bundle path missing from repo: $rel_path" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$dest")"
  cp -R "$src" "$dest"
done < "$BUNDLE_INDEX"

cat > "$BUNDLE_DIR/RELEASE_BUNDLE_INFO.txt" <<EOF
template_name=$TEMPLATE_NAME
release_version=$RELEASE_VERSION
release_date=$RELEASE_DATE
generated_at_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)
bundle_paths_file=$BUNDLE_INDEX_REL
EOF

cp "$BUNDLE_INDEX" "$BUNDLE_DIR/BUNDLE_PATHS.txt"

tar -czf "$ARCHIVE_PATH" -C "$OUTPUT_DIR" "$BUNDLE_NAME"

echo "Release bundle directory: $BUNDLE_DIR"
echo "Release bundle archive: $ARCHIVE_PATH"
