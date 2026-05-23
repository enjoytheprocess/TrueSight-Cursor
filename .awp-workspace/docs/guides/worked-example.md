# Worked Example

A concrete walkthrough of the full lifecycle using a realistic fake project.

**Project:** Snippets API — a small REST API for storing and retrieving code snippets.
**Mode:** single-component (`api`)
**Owner:** Dev Team

This example uses two tasks:
- `SETUP-001`: Bootstrap workspace and connect code repository (setup)
- `TASK-001`: Implement snippet create and retrieve endpoints (first feature)

---

## 1. After `make init`

```bash
make init MODE=single PROJECT_NAME="Snippets API" COMPONENT_NAME=api
```

The registers are seeded with starter rows. Replace them all before any build work starts.

---

## 2. Design: set up the project registers

**Starting a Design session — read DESIGN_INPUTS first.**
In a fresh workspace, `4-sync/DESIGN_INPUTS.md` is empty — no open items from a previous cycle.
Design can proceed directly to defining the project.

Update all five registers together:

**`1-design/PROJECT_BRIEF.md`** (key fields):
```
Project name: Snippets API
Problem: Developers need a simple, shareable store for code snippets.
Scope: REST API — create a snippet (POST /snippets), retrieve by ID (GET /snippets/:id).
Out of scope: user accounts, search, expiry in the first slice.
Primary owner: Dev Team
```

**`1-design/DESIGN_STATES.md`**:
| Feature ID | Linked Idea | Linked Task(s) | Component(s) | Design State | Owner | Blocking Questions | Last Updated | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | direct_to_design | TASK-001 | api | spec_draft | Dev Team | confirm storage backend (DB vs file) | 2026-04-05 | snippet create and retrieve |

**`1-design/ROADMAP.md`**:
| Milestone ID | Target Window | Objective | Feature ID(s) | Depends On | Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| M-001 | 2026-Q2 | Working snippet API with create and retrieve | FEAT-001 | none | active | Dev Team | |

**`1-design/TASK_READINESS.md`**:
| Task ID | Feature ID | Title | Component | Spec Link | IRG | Blocking Unknowns | Readiness | Specialist Advisor | Advisor Gate | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:2 V:2 | none | ready_for_build | none | not_required | setup task; no feature dependency |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | 1-design/PROJECT_BRIEF.md | S:2 A:1 I:1 R:1 V:1 | acceptance criteria need concrete request/response shapes; storage interface not decided | needs_detail | none | not_required | blocked on storage backend decision |

**`2-build/WORK_QUEUE.md`**:
| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | P1 | build | M-001 | 2026-Q2 | sequential | none | Dev Team | todo | none | none | make docs-check | run first; unblocks real path references in traceability |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | design | M-001 | 2026-Q2 | sequential | none | Dev Team | todo | SETUP-001 | none | make docs-check; curl smoke tests | waiting on design detail |

**`3-verify/TRACEABILITY_MATRIX.md`**:
| Feature ID | Spec Link | Task ID(s) | Code Link(s) | Test Link(s) | Last Synced | Drift Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | 1-design/PROJECT_BRIEF.md | TASK-001 | components/api/src | components/api/tests | 2026-04-05 | review_needed | Dev Team | paths confirmed after SETUP-001 completes |

---

## 3. Build SETUP-001

SETUP-001 has `ready_for_build` immediately — it is a setup task with no design unknowns.

1. Initialize or clone your code repository into `components/api/`.
2. Confirm `components/api/src` and `components/api/tests` exist (or adjust paths to match your actual layout).
3. Update `TRACEABILITY_MATRIX.yaml` with the confirmed paths; set `drift_status: aligned`.
4. Run `make render` then `make docs-check`.
5. Move SETUP-001 to `awaiting_human_review` with validation evidence in Notes.

---

## 4. Verify SETUP-001

**Starting a Verify session for SETUP-001:**
- WORK_QUEUE: status `awaiting_human_review`, validation `make docs-check` passed
- TASK_READINESS: `advisor_status: not_required` — no gate to check
- TRACEABILITY_MATRIX: `drift_status: aligned`
- FEEDBACK_MATRIX: no human test observations for a setup task
- GAPS_AND_DEVIATIONS: no gaps or deviations surfaced

**Acceptance Gate check:**
1. Validation quality: `make docs-check` passed — evidence is sufficient.
2. Feedback completeness: FEEDBACK_MATRIX empty — nothing to promote.
3. Advisor and risk follow-up: no advisor active.
4. Operational readiness: setup task; no rollout concerns.
5. Decision: **accept**.

Move SETUP-001 to `accepted` → `done`.

---

## 5. Sync SETUP-001

**Starting a Sync session:**
- DESIGN_INPUTS: empty — no prior open items.
- GAPS_AND_DEVIATIONS: empty — nothing to triage.
- Reconcile: WORK_QUEUE status is `done`; ROADMAP and TRACEABILITY_MATRIX are already current.

Nothing to triage. Sync is complete. The next Design session can begin.

---

## 6. Design: advance TASK-001

**Starting a Design session:**
1. Read `4-sync/DESIGN_INPUTS.md` — still empty; no open items.
2. Check TASK_READINESS for `needs_detail` rows — TASK-001 is `needs_detail`.

Resolve the blocking unknowns:
- Decide on storage backend: SQLite for the first slice.
- Define request/response shapes:
  - `POST /snippets` body: `{ "language": "python", "content": "print('hello')" }`
  - `GET /snippets/:id` response: `{ "id": "abc123", "language": "python", "content": "..." }`
- Update PROJECT_BRIEF.md with the storage and shape decisions.
- Update DESIGN_STATES.md to `ready` once blocking questions are resolved.

**`1-design/DESIGN_STATES.md`** after design is complete:
| Feature ID | Linked Idea | Linked Task(s) | Component(s) | Design State | Owner | Blocking Questions | Last Updated | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | direct_to_design | TASK-001 | api | ready | Dev Team | none | 2026-04-07 | storage: SQLite; shapes confirmed |

**`1-design/TASK_READINESS.md`** after IRG update:
| Task ID | Feature ID | Title | Component | Spec Link | IRG | Blocking Unknowns | Readiness | Specialist Advisor | Advisor Gate | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:2 V:2 | none | ready_for_build | none | not_required | |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:1 V:2 | none | ready_for_build | none | not_required | storage: SQLite; POST + GET shapes confirmed |

TASK-001 now clears the IRG gate: total 9/10, A=2, I=2, no blocking unknowns.

---

## 7. Build TASK-001

Pull TASK-001 into build. Implement the endpoints, keep the queue and traceability current.

**`2-build/WORK_QUEUE.md`** during build:
| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | none | none | make docs-check | |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | build | M-001 | 2026-Q2 | sequential | none | Dev Team | in_progress | SETUP-001 | none | make docs-check; curl smoke tests | |

When implementation and tests pass, move to `awaiting_human_review` and record evidence in Notes.

---

## 8. Verify TASK-001

**Starting a Verify session for TASK-001:**
- WORK_QUEUE: status `awaiting_human_review`
- TASK_READINESS: `advisor_status: not_required`
- TRACEABILITY_MATRIX: `drift_status: aligned`
- FEEDBACK_MATRIX: one observation from human testing (see below)
- GAPS_AND_DEVIATIONS: one entry promoted from FEEDBACK_MATRIX (see below)

**Human testing observation** recorded in `3-verify/FEEDBACK_MATRIX.yaml`:
```yaml
- id: FB-001
  task_id: TASK-001
  feature_id: FEAT-001
  type: deviation
  summary: "POST /snippets returns 201 but spec only specifies 200"
  detail: "Implementation returns 201 Created; PROJECT_BRIEF.md only specifies 200 OK for success responses"
  tested_by: Dev Team
  date: 2026-04-09
  severity: low
  status: promoted_to_staging
  resolution: "Promoted to GD-001 — needs Sync ratification"
```

**Promoted to** `3-verify/GAPS_AND_DEVIATIONS.yaml`:
```yaml
- id: GD-001
  feature_id: FEAT-001
  type: deviation
  summary: "POST /snippets returns 201 Created; spec says 200 OK"
  detail: "Build chose 201 as more semantically correct for resource creation; spec was silent on this"
  source: human_feedback
  source_ref: FB-001
  discovered_in_task: TASK-001
  status: promoted_to_sync
  resolution_note: "Promoted to Sync for ratification"
```

**Acceptance Gate check:**
1. Validation quality: tests and smoke tests pass; evidence recorded.
2. Feedback completeness: FB-001 is `promoted_to_staging`; GD-001 is staged. ✓
3. Advisor and risk follow-up: no advisor active.
4. Operational readiness: no deployment concerns for a first slice.
5. Decision: **accept**.

Move TASK-001 to `accepted`.

---

## 9. Sync TASK-001

**Starting a Sync session:**

1. Read DESIGN_INPUTS — still empty from the previous session.
2. Triage GAPS_AND_DEVIATIONS:

**GD-001** (deviation: POST returns 201 not 200):
- Can this be closed now? Yes — update PROJECT_BRIEF.md to specify 201 for resource creation. No full Design cycle needed.
- Action: update spec, add to `4-sync/archive/DESIGN_INPUTS.yaml`.

**`4-sync/archive/DESIGN_INPUTS.yaml`** after triage:
```yaml
- id: DA-001
  source_input_id: ""
  feature_id: FEAT-001
  type: deviation
  summary: "POST /snippets returns 201 Created; spec updated to match"
  cycle_opened: "2026-Q2-loop-1"
  cycle_closed: "2026-Q2-loop-1"
  resolution_type: incorporated
  resolution_pointer: "1-design/PROJECT_BRIEF.md#response-codes"
  resolution_note: "Spec updated to specify 201 for resource creation; implementation is correct"
```

3. Reconcile registers:

**`2-build/WORK_QUEUE.md`** final state:
| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | none | none | make docs-check | |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | SETUP-001 | none | make docs-check; curl smoke tests | POST /snippets + GET /snippets/:id passing; SQLite storage confirmed |

**`1-design/ROADMAP.md`** after sync:
| Milestone ID | Target Window | Objective | Feature ID(s) | Depends On | Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| M-001 | 2026-Q2 | Working snippet API with create and retrieve | FEAT-001 | none | completed | Dev Team | delivered 2026-04-10 |

**`3-verify/TRACEABILITY_MATRIX.md`** after sync:
| Feature ID | Spec Link | Task ID(s) | Code Link(s) | Test Link(s) | Last Synced | Drift Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | 1-design/PROJECT_BRIEF.md | TASK-001 | components/api/src | components/api/tests | 2026-04-10 | aligned | Dev Team | |

Run `make docs-check` to confirm everything is clean.
DESIGN_INPUTS is empty — the next Design session starts clean.
