# AGENTS

AI runtime contract for this initialized single-component workspace.

## Mode assumptions
- Repository mode: `single-component`
- Adoption path: `direct-use`
- Primary component: `api`

## Default read order
Read from `.md` table views; edit the `.yaml` source files.
1. Check `1-design/TASK_READINESS.md` for any `needs_rework` rows before pulling new work.
2. Read the active row in `2-build/WORK_QUEUE.md`.
3. Read the matching row in `1-design/TASK_READINESS.md` for IRG scores and blocking unknowns.
4. Read the linked rows in `1-design/DESIGN_STATES.md`, `1-design/ROADMAP.md`, and `3-verify/TRACEABILITY_MATRIX.md`.
5. Read the `AGENTS.md` and linked specs for the component named by the task.
6. Open optional registers only when the task uses them.

## Rules
- Trust uppercase `.yaml` registers as canonical shared state; `.md` views are generated from them.
- After editing any register `.yaml`, run `make render` to regenerate the `.md` table views.
- Keep traceability links repo-relative.
- Prefer component-scoped edits; treat shared docs and contracts as cross-cutting changes.
- Build only when all are true (condensed; authoritative list in `docs/optional/consistency-gates.md`):
  - `Readiness = ready_for_build`, IRG ≥ 8/10 with A=2 and I=2, `Blocking Unknowns = none`
  - linked design state is `ready` (skip when `feature_id: none`)
  - traceability row is not `drift_detected` (skip when `feature_id: none`)
  - `Advisor Gate = approved` when a gate is required
- Open specialist docs only when `Specialist Advisor != none`.
- Run `make docs-check` before handoff.
