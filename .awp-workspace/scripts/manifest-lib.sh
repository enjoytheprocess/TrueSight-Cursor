#!/usr/bin/env bash

set -euo pipefail

manifest_parse_tsv() {
  local manifest="$1"
  awk '
    function trim(v) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", v); return v }
    function unquote(v) {
      v = trim(v)
      if (v ~ /^".*"$/) {
        sub(/^"/, "", v)
        sub(/"$/, "", v)
      }
      return v
    }
    function emit() {
      if (seen) {
        print name "\t" repo "\t" path "\t" ref "\t" type "\t" verify
      }
    }

    /^  - name:/ {
      emit()
      seen = 1
      name = unquote(substr($0, index($0, ":") + 1))
      repo = ""
      path = ""
      ref = ""
      type = ""
      verify = ""
      next
    }

    /^    repo:/ { repo = unquote(substr($0, index($0, ":") + 1)); next }
    /^    path:/ { path = unquote(substr($0, index($0, ":") + 1)); next }
    /^    ref:/ { ref = unquote(substr($0, index($0, ":") + 1)); next }
    /^    type:/ { type = unquote(substr($0, index($0, ":") + 1)); next }
    /^    verify_command:/ { verify = unquote(substr($0, index($0, ":") + 1)); next }

    END { emit() }
  ' "$manifest"
}

manifest_validate() {
  local manifest="$1"
  local had_errors=0
  local count=0
  declare -A names=()
  declare -A paths=()

  mapfile -t rows < <(manifest_parse_tsv "$manifest")
  if [[ ${#rows[@]} -eq 0 ]]; then
    echo "ERROR: no components found in $manifest" >&2
    return 1
  fi

  for row in "${rows[@]}"; do
    count=$((count + 1))
    IFS=$'\t' read -r name repo path ref type verify <<< "$row"

    if [[ -z "$name" || -z "$repo" || -z "$path" || -z "$ref" || -z "$type" || -z "$verify" ]]; then
      echo "ERROR: component #$count missing required fields" >&2
      had_errors=1
      continue
    fi

    if [[ -n "${names[$name]+x}" ]]; then
      echo "ERROR: duplicate component name '$name'" >&2
      had_errors=1
    else
      names[$name]=1
    fi

    if [[ -n "${paths[$path]+x}" ]]; then
      echo "ERROR: duplicate component path '$path'" >&2
      had_errors=1
    else
      paths[$path]=1
    fi

    if [[ ! "$ref" =~ ^[a-f0-9]{40}$ && "$ref" != "HEAD" ]]; then
      echo "ERROR: component '$name' has invalid ref '$ref' (use 40-char SHA or HEAD)" >&2
      had_errors=1
    fi
  done

  if [[ $had_errors -ne 0 ]]; then
    return 1
  fi

  echo "Manifest valid: $count component(s)."
}
