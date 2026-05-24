#!/usr/bin/env bash
# Stop a TrueSight.Api dev instance bound to the http launch profile port (5158).
set -euo pipefail

PORT="${TRUESIGHT_API_PORT:-5158}"

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
if ss -tlnp 2>/dev/null | grep -q ":${PORT}"; then
  echo "Port ${PORT} still in use; sending SIGKILL ..."
  for pid in $pids; do
    kill -9 "$pid" 2>/dev/null || true
  done
fi

echo "Port ${PORT} is free."
