# Build agent loop (sequential tasks)

How AI agents should run the **Build** phase when multiple tasks are admitted in `2-build/WORK_QUEUE.yaml`.

Authoritative workflow rules also live in [`.awp-workspace/docs/core/workflow-reference.md`](../../.awp-workspace/docs/core/workflow-reference.md) § Build rules.

## Principles

1. **One task per implementation pass** — scope code, tests, and register updates to a single `WORK_QUEUE` row.
2. **Commit after each task** (when the user wants git history) — one commit per task keeps review and rollback clean. Do not batch unrelated tasks in one commit.
3. **Do not skip the queue** — only work on tasks with `phase: build` and `readiness: ready_for_build` (check `TASK_READINESS.yaml` at session start; during Build, trust the WORK_QUEUE admission snapshot).
4. **Respect `build_dependencies`** — a downstream task is not buildable until every listed upstream task is **`accepted`** or **`done`** (implementation merged and human acceptance gate passed). `todo` / `in_progress` / `awaiting_human_review` upstream does **not** unblock dependents.

`design_dependencies` are separate: they require a Design refresh before build, not just code existing.

## Loop

```mermaid
flowchart TD
    start([Build session start]) --> scan[Scan WORK_QUEUE for buildable tasks]
    scan --> any{Any buildable task?}
    any -->|no| refresh[Re-scan after human accepts upstream tasks]
    refresh --> any2{Newly unblocked?}
    any2 -->|yes| pick
    any2 -->|no| end([Stop — hand off or wait for acceptance])
    any -->|yes| pick[Pick one task — see selection]
    pick --> work[Implement + tests + registers]
    work --> review[Set status awaiting_human_review]
    review --> commit[Git commit this task only if user wants commits]
    commit --> scan
```

### 1. Find buildable tasks

A row is **buildable** when all of the following hold:

| Check | Source |
|-------|--------|
| `phase` is `build` | `WORK_QUEUE.yaml` |
| `status` is `todo` or `in_progress` | `WORK_QUEUE.yaml` |
| Linked feature `design_state` is `ready` | `DESIGN_STATES.yaml` |
| `readiness` is `ready_for_build` | `TASK_READINESS.yaml` (at admission) |
| Every `build_dependencies` task has `status` **`accepted`** or **`done`** | `WORK_QUEUE.yaml` |
| If `mode: parallel`, lock claimed when `LOCKS.yaml` in use | `LOCKS.yaml` |

Treat `build_dependencies: none` as satisfied.

### 2. Pick one task

When several tasks are buildable:

1. Prefer **`in_progress`** over `todo` (finish started work).
2. Then lowest **`priority`** (P1 before P2 before P3).
3. Among equals, prefer tasks with **`build_dependencies: none`** (roots of the graph).
4. **`mode: parallel`** tasks (e.g. frontend vs backend) may run in separate commits/sessions but still **one task per pass** — do not mix BUILD-INV-001 and BUILD-AUTH-001 in the same commit.

### 3. Execute one task

Per task `spec_link` and component `AGENTS.md`:

- `todo` → `in_progress` when starting.
- Implement only that task’s acceptance criteria.
- Run validation from the row’s `validation` field.
- Update `TRACEABILITY_MATRIX.yaml` / `GAPS_AND_DEVIATIONS.yaml` if needed.
- `in_progress` → **`awaiting_human_review`** when evidence is ready (not `accepted` — human gate).

### 4. Commit (optional per session, required when user asks)

When the user requests git commits during Build:

```text
git add <files for this task only>
git commit -m "<task id>: <short why>"
```

One commit per task. Run `make awp-render` before commit if register YAML changed (pre-commit may also run it).

### 5. Repeat until no buildable tasks

When every remaining `phase: build` task is blocked on dependencies or human review, **stop**.

### 6. Dependency refresh pass

After upstream tasks move to **`accepted`** (human acceptance gate), **scan again**. Tasks that were blocked only by `build_dependencies` become buildable — e.g. BUILD-REC-001 after BUILD-INV-001 is accepted.

Do not implement dependent tasks early “because the code already exists” unless the user explicitly overrides the queue gate.

## Status path (reminder)

`todo` → `in_progress` → `awaiting_human_review` → **`accepted`** (human) → `done` (after Sync)

Dependent tasks wait for **`accepted`**, not merely `awaiting_human_review`.

## TrueSight V1 — current admitted queue (2026-05-24)

Apply the loop to this project as follows:

| Order | Task | Component | Unblocks when |
|-------|------|-----------|----------------|
| 1a | **BUILD-INV-001** | backend | — (`build_dependencies: none`) |
| 1b | **BUILD-AUTH-001** | frontend | — (parallel with 1a; separate commit) |
| 2 | **BUILD-REC-001** | backend | BUILD-INV-001 → **`accepted`** |
| 3 | **BUILD-SES-001** | backend | BUILD-REC-001 → **`accepted`** |

**Not in build loop yet:** **BUILD-CAT-001** — `phase: design`, `readiness: needs_detail` (P3 / TMP-002).

Specs:

- [FEAT-INV-001](features/FEAT-INV-001-manual-inventory.md)
- [FEAT-AUTH-001](features/FEAT-AUTH-001-demo-login-screen.md)
- [FEAT-REC-001](features/FEAT-REC-001-recipe-suggestions.md)
- [FEAT-SES-001](features/FEAT-SES-001-recipe-acceptance-deduction.md)

## Related

- [acceptance-gate.md](../../.awp-workspace/3-verify/acceptance-gate.md) — human step before `accepted`
- [open-questions.md](../product/open-questions.md) — deferred items (OQ-038, etc.) do not block unless listed in `blocking_unknowns`
