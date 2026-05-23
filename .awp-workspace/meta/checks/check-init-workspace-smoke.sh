#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/workspace-template-init-smoke.XXXXXX)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

COMMON_ARGS=("PROJECT_NAME=Smoke Test Workspace" MILESTONE_ID=M-101 TARGET_WINDOW=2026-Q2 USE_IDEATION=1 USE_DEPENDENCIES=0 USE_LOCKS=0 USE_SYNC_LOGS=0 USE_TEMP_MEASURES=0 USE_SPECIALIST_REGISTERS=0 USE_SIGN_OFF=0 FORCE=1)

# ---------------------------------------------------------------------------
# single
# ---------------------------------------------------------------------------
echo "--- smoke: single ---"
TEST_SINGLE="$TMP_DIR/repo-single"
mkdir -p "$TEST_SINGLE"
cp -R "$REPO_ROOT/." "$TEST_SINGLE"

(cd "$TEST_SINGLE" && make init MODE=single COMPONENT_NAME=app "${COMMON_ARGS[@]}")

test -f "$TEST_SINGLE/components/app/README.md"
test -f "$TEST_SINGLE/components/app/AGENTS.md"
test -f "$TEST_SINGLE/1-design/PROJECT_BRIEF.md"
test -f "$TEST_SINGLE/1-design/TASK_READINESS.md"
test -f "$TEST_SINGLE/2-build/WORK_QUEUE.yaml"
test -f "$TEST_SINGLE/2-build/archive/WORK_QUEUE.yaml"
test -f "$TEST_SINGLE/1-design/archive/ROADMAP.yaml"
test -f "$TEST_SINGLE/3-verify/archive/FEEDBACK_MATRIX.yaml"
test -f "$TEST_SINGLE/3-verify/archive/GAPS_AND_DEVIATIONS.yaml"
test -f "$TEST_SINGLE/2-build/WORK_QUEUE.md"
test -f "$TEST_SINGLE/2-build/archive/WORK_QUEUE.md"
test -f "$TEST_SINGLE/1-design/archive/ROADMAP.md"
test -f "$TEST_SINGLE/3-verify/TRACEABILITY_MATRIX.md"

grep -q "Repo mode: \`single-component\`" "$TEST_SINGLE/README.md"
grep -q "single-component workspace\." "$TEST_SINGLE/AGENTS.md"
grep -q "Project name: Smoke Test Workspace" "$TEST_SINGLE/1-design/PROJECT_BRIEF.md"
grep -q "SETUP-001.*Configure workspace and connect project components" "$TEST_SINGLE/1-design/TASK_READINESS.md"
grep -q "| none | app |" "$TEST_SINGLE/1-design/TASK_READINESS.md"
grep -q "SETUP-001.*Configure workspace and connect project components" "$TEST_SINGLE/2-build/WORK_QUEUE.md"
grep -q "| none | app | P1 | build |" "$TEST_SINGLE/2-build/WORK_QUEUE.md"
grep -q "1-design/PROJECT_BRIEF.md" "$TEST_SINGLE/2-build/WORK_QUEUE.md"

(cd "$TEST_SINGLE" && make docs-check)
echo "single: ok"

# ---------------------------------------------------------------------------
# multi
# ---------------------------------------------------------------------------
echo "--- smoke: multi ---"
TEST_MULTI="$TMP_DIR/repo-multi"
mkdir -p "$TEST_MULTI"
cp -R "$REPO_ROOT/." "$TEST_MULTI"

(cd "$TEST_MULTI" && make init MODE=multi COMPONENT_NAME=api "${COMMON_ARGS[@]}")

test -f "$TEST_MULTI/components/api/README.md"
test -f "$TEST_MULTI/components/api/AGENTS.md"
test -f "$TEST_MULTI/1-design/PROJECT_BRIEF.md"
test -f "$TEST_MULTI/1-design/TASK_READINESS.md"
test -f "$TEST_MULTI/2-build/WORK_QUEUE.yaml"
test -f "$TEST_MULTI/2-build/archive/WORK_QUEUE.yaml"
test -f "$TEST_MULTI/1-design/archive/ROADMAP.yaml"
test -f "$TEST_MULTI/3-verify/archive/FEEDBACK_MATRIX.yaml"
test -f "$TEST_MULTI/3-verify/archive/GAPS_AND_DEVIATIONS.yaml"
test -f "$TEST_MULTI/2-build/WORK_QUEUE.md"
test -f "$TEST_MULTI/2-build/archive/WORK_QUEUE.md"
test -f "$TEST_MULTI/1-design/archive/ROADMAP.md"
test -f "$TEST_MULTI/3-verify/TRACEABILITY_MATRIX.md"

grep -q "Repo mode: \`multi-component\`" "$TEST_MULTI/README.md"
grep -q "multi-component workspace\." "$TEST_MULTI/AGENTS.md"
grep -q "Project name: Smoke Test Workspace" "$TEST_MULTI/1-design/PROJECT_BRIEF.md"
grep -q "SETUP-001.*Configure workspace and connect project components" "$TEST_MULTI/1-design/TASK_READINESS.md"
grep -q "| none | api |" "$TEST_MULTI/1-design/TASK_READINESS.md"
grep -q "SETUP-001.*Configure workspace and connect project components" "$TEST_MULTI/2-build/WORK_QUEUE.md"
grep -q "| none | api | P1 | build |" "$TEST_MULTI/2-build/WORK_QUEUE.md"
grep -q "1-design/PROJECT_BRIEF.md" "$TEST_MULTI/2-build/WORK_QUEUE.md"

(cd "$TEST_MULTI" && make docs-check)
echo "multi: ok"

# ---------------------------------------------------------------------------
# federated
# ---------------------------------------------------------------------------
echo "--- smoke: federated ---"
TEST_FED="$TMP_DIR/repo-fed"
mkdir -p "$TEST_FED"
cp -R "$REPO_ROOT/." "$TEST_FED"

(cd "$TEST_FED" && make init MODE=federated COMPONENT_NAME=api "${COMMON_ARGS[@]}")

test -f "$TEST_FED/components/COMPONENT_REPOS.md"
test -f "$TEST_FED/workspace.manifest.yaml"
test -f "$TEST_FED/1-design/PROJECT_BRIEF.md"
test -f "$TEST_FED/1-design/TASK_READINESS.md"
test -f "$TEST_FED/2-build/WORK_QUEUE.yaml"
test -f "$TEST_FED/2-build/archive/WORK_QUEUE.yaml"
test -f "$TEST_FED/1-design/archive/ROADMAP.yaml"
test -f "$TEST_FED/3-verify/archive/FEEDBACK_MATRIX.yaml"
test -f "$TEST_FED/3-verify/archive/GAPS_AND_DEVIATIONS.yaml"
test -f "$TEST_FED/2-build/WORK_QUEUE.md"
test -f "$TEST_FED/2-build/archive/WORK_QUEUE.md"
test -f "$TEST_FED/1-design/archive/ROADMAP.md"
test -f "$TEST_FED/3-verify/TRACEABILITY_MATRIX.md"
# federated must not create local component directories
test ! -f "$TEST_FED/components/api/README.md"

grep -q "Federated planning workspace" "$TEST_FED/README.md"
grep -q "federated workspace\." "$TEST_FED/AGENTS.md"
grep -q "Project name: Smoke Test Workspace" "$TEST_FED/1-design/PROJECT_BRIEF.md"
grep -q "SETUP-001.*Configure workspace and connect project components" "$TEST_FED/1-design/TASK_READINESS.md"
grep -q "| none | api |" "$TEST_FED/1-design/TASK_READINESS.md"
grep -q "SETUP-001.*Configure workspace and connect project components" "$TEST_FED/2-build/WORK_QUEUE.md"
grep -q "| none | api | P1 | build |" "$TEST_FED/2-build/WORK_QUEUE.md"
grep -q "1-design/PROJECT_BRIEF.md" "$TEST_FED/2-build/WORK_QUEUE.md"

(cd "$TEST_FED" && make docs-check)
echo "federated: ok"

echo ""
echo "Init workspace smoke check passed (single, multi, federated)."
