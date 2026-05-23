# AGENTS

Instructions for AI agents working in this component repository.

## Scope
- What this repo owns:
- What this repo does not own:

## Required context before changes
1. Read component `README.md`.
2. Read linked design/contract docs.
3. Confirm active task in shared queue.
4. Confirm capability/target window and lock expectations for the task.

## Execution rules
1. Only implement tasks marked `ready_for_build`.
2. Keep changes scoped to one task.
3. If `Mode = parallel`, claim the shared lock and record its `Lock ID` before editing.
4. Add/adjust tests for behavior changes.
5. Record outcomes in shared handoff/queue artifacts.

## Verification contract
- Required local checks:
- Required test suites:
- Manual verification expectations:

## Escalation rules
- If contracts are ambiguous, stop and move task back to `design`.
- If design changes mid-build, log it and re-run readiness gate.
- If timing changes, update the shared roadmap in the same change set.
