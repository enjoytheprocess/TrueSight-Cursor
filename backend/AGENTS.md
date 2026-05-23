# AGENTS

Instructions for AI agents working in this component repository.

## Scope
- What this repo owns: the first implementation slice for backend
- What this repo does not own: cross-component decisions that belong in shared design docs

## Required context before changes
1. Read component `README.md`.
2. Follow Cursor rule `.cursor/rules/awp.mdc` — read linked `.awp-workspace/` registers for the active task.
3. Confirm active task in `.awp-workspace/2-build/WORK_QUEUE.yaml` and matching `1-design/TASK_READINESS.yaml`.
4. Confirm capability/target window and lock expectations for the task.

## Execution rules
1. Only implement tasks marked `ready_for_build`.
2. Keep changes scoped to one task.
3. If `Mode = parallel`, claim the shared lock and record its `Lock ID` before editing.
4. Add/adjust tests for behavior changes.
5. Record outcomes in shared handoff/queue artifacts.

## Verification contract
- Required local checks: define before build admission
- Required test suites: define before build admission
- Manual verification expectations: record in the queue `Validation` field

## Escalation rules
- If contracts are ambiguous, stop and move task back to `design`.
- If design changes mid-build, log it and re-run readiness gate.
- If timing changes, update the shared roadmap in the same change set.

## Model tier
Routine slice work: **medium**. New API boundaries, auth, or cross-slice refactors: **high**. See repo root `AGENTS.md` § Token and model tier.
