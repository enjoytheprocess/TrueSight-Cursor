#!/usr/bin/env bash
# Stop the Vite dev server bound to the default frontend port (5173).
set -euo pipefail

PORT="${TRUESIGHT_WEB_PORT:-5173}"

if command -v ss >/dev/null 2>&1; then
  pids=$(ss -tlnp 2>/dev/null | grep ":${PORT}" | grep -oP 'pid=\K[0-9]+' | sort -u || true)
elif command -v lsof >/dev/null 2>&1; then
  pids=$(lsof -ti ":${PORT}" 2>/dev/null || true)
else
  echo "Need ss or lsof to find processes on port ${PORT}." >&2
  exit 1
fi

if [[ -z "${pids:-}" ]]; then
  echo "No process listening on port ${PORT}."
  exit 0
fi

for pid in $pids; do
  name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "?")
  echo "Stopping PID ${pid} (${name}) on port ${PORT} ..."
  kill "$pid" 2>/dev/null || true
done

sleep 1
if command -v ss >/dev/null 2>&1; then
  if ss -tlnp 2>/dev/null | grep -q ":${PORT}"; then
    echo "Port ${PORT} still in use; sending SIGKILL ..."
    for pid in $pids; do
      kill -9 "$pid" 2>/dev/null || true
    done
  fi
elif command -v lsof >/dev/null 2>&1; then
  if lsof -ti ":${PORT}" >/dev/null 2>&1; then
    echo "Port ${PORT} still in use; sending SIGKILL ..."
    for pid in $pids; do
      kill -9 "$pid" 2>/dev/null || true
    done
  fi
fi

echo "Port ${PORT} is free."
