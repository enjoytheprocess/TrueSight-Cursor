# Glossary

Short definitions for the terms that show up repeatedly across this template.

## Advisor Status
Field that tracks the AI advisor analysis state: `not_required` (no advisor track active), `pending` (analysis not yet complete), or `complete` (advisor completed the analysis and recorded findings in the backing file). Set by the agent — not a human sign-off. See also **Specialist Sign-off** for the human authority gate.

## Blocking Unknowns
Open questions or missing details that still make build admission unsafe.

## Lock ID
Queue field used to point at the active lock entry when parallel work coordination is in use.

## Mode
Queue field that says whether the task is expected to run `sequential` or `parallel`.

## Build Dependencies
Upstream tasks whose implemented output is enough to unblock downstream work, even before human acceptance.

## Design Dependencies
Upstream tasks whose verified result must inform a later design pass before downstream work should continue.

## Feature

A unit of user-visible or system-level behaviour that is designed, built, and verified as a coherent whole. Registered permanently in `FEATURE_REGISTRY.yaml`; tracked through design and build via `DESIGN_STATES.yaml`, `TASK_READINESS.yaml`, and `TRACEABILITY_MATRIX.yaml`.

Three kinds of work are easy to confuse:

| Kind | Examples | Home |
|------|----------|------|
| **Feature** | API endpoint, auth flow, export function, platform integration | `FEATURE_REGISTRY.yaml` → feature design chain |
| **Quality requirement** | Deployable on AWS, handles 1k req/s, GDPR compliant | `QUALITY_REQUIREMENTS.yaml` |
| **Non-feature task** | CI setup, DB migration, repo scaffolding, dependency upgrades | `feature_id: none` in WORK_QUEUE |

Decision rule: if it delivers a new capability with acceptance criteria and an interface, it is a feature. If it is a persistent non-functional standard that applies across multiple tasks or features, it is a quality requirement. If it is supporting work with no user-visible output and no spec of its own, it is a non-feature task.

Operational concerns like platform deployability sit at the boundary. If the work has a real spec, acceptance criteria, and interfaces (deployment config, scripts, environment constraints), model it as a feature or a QR depending on whether it is a one-time deliverable or an ongoing standard. If it is straightforward setup work, model it as a `feature_id: none` task.

## Feature Registry
`1-design/FEATURE_REGISTRY.yaml` — permanent identity record for all features. Holds `id`, `title`, `components`, and `created_on`. Rows are never removed. All other registers reference features by the `id` values here. Separate from design triage state.

## Design State
The active design maturity of a feature in `1-design/DESIGN_STATES.yaml`: `concept`, `spec_draft`, `spec_review`, `ready`, `needs_redesign`, or `complete`. Only features with an active entry here are in design or build; completed features move to `1-design/archive/DESIGN_STATES.yaml`. Feature identity (id, title, components) lives in `FEATURE_REGISTRY.yaml`, not here.

## Phase
Queue field that places the task in the current lifecycle stage: `design`, `build`, `verify`, or `sync`.

## Drift Status
Gate signal in `3-verify/TRACEABILITY_MATRIX.md` for the current alignment state of a feature's code against its spec: `aligned`, `review_needed`, or `drift_detected`. `drift_detected` blocks active tasks; accepted/done tasks require `aligned`. Specific incidents that caused a drift are recorded separately in `3-verify/GAPS_AND_DEVIATIONS.yaml`.

## Feature ID
Stable identifier for a feature-level slice of work, used to connect design, queue, traceability, and verification state.

## IRG
Implementation Readiness Gate. The scoring model used to decide whether a task is safe to pull for build. Scores are recorded in compact format `S:v A:v I:v R:v V:v` in `1-design/TASK_READINESS.md`.

## IRG Score
Compact format `S:v A:v I:v R:v V:v` in `TASK_READINESS.md` where each dimension is 0–2. Total ≥ 8 with A=2 and I=2 required for `ready_for_build`. The pass criteria live in `docs/optional/consistency-gates.md`.

## IRG Scoring Rubric
Per-dimension guide for calibrating 0/1/2:

| Dim | 0 — unknown | 1 — partial | 2 — clear |
| --- | --- | --- | --- |
| **S** Scope | Goal or deliverable is undefined; "done" has no shared meaning | Goal is understood but edge cases, boundaries, or constraints are open | Outcome and scope boundaries are fully defined; out-of-scope is stated |
| **A** Acceptance | No acceptance criteria written | Criteria exist but are incomplete, ambiguous, or not independently testable | Concrete, testable criteria cover the full scope; a reviewer can confirm pass/fail |
| **I** Interfaces | APIs, data shapes, or integration points are unknown or undecided | Interfaces are sketched; some details remain open (field types, error cases, auth) | All relevant interfaces are fully specified; contracts agreed with all parties |
| **R** Risks | Dependencies and risks have not been considered | Main dependencies and risks identified; mitigations not yet in place | Dependencies resolved or explicitly accepted; known risks have mitigations |
| **V** Verification | No verification approach defined | General approach known (e.g. "add tests") but specifics are not defined | Specific test types, coverage targets, or validation steps are named and feasible |

A and I must reach 2 before a task is admitted to build. S, R, and V may be 1 at admission if the risk is accepted — gaps become inputs to the next loop.

## Capability
A coherence grouping of features that together form an independently testable, usable unit of the system — tracked in `1-design/ROADMAP.md`. A capability answers the question "which features need to be complete before this slice of the system makes sense to test end-to-end?" It is not a delivery deadline; it is a feature bundle with a logical boundary.

Infrastructure, tooling, ops, and setup tasks that are not in service of a feature should use `capability: none`. Feature tasks (`feature_id != none`) must reference a capability once active (build phase or later); `capability: none` on an active feature task is a planning smell and is caught by `make docs-check`.

Capability IDs use the prefix `CAP-` (e.g. `CAP-001`).

## needs_detail
`TASK_READINESS.md` readiness value meaning the task still lacks enough design clarity, interface detail, risk handling, or verification planning for safe build work.

## Project Brief
`1-design/PROJECT_BRIEF.md`, used for stable project context and constraints rather than task-by-task execution state.

## Ready for Build
`TASK_READINESS.md` readiness value meaning the task has cleared the IRG gate (≥ 8/10, A=2, I=2), has no blocking unknowns, and is safe to promote to Phase=build in `WORK_QUEUE.md`.

## Advisor Track
Field naming which AI analysis the advisor runs for a task: `security`, `experiment`, `incident`, `data_migration`, `api_contract`, or `none`. The agent applies the analysis itself and records findings in the backing file under `3-verify/`. See also **Specialist Sign-off** for the human authority gate.

## Specialist Sign-off
Optional human authority gate layered on top of the advisor track. A named human domain expert reviews and approves (or waives) the work at Design, Verify, and/or Sync stages. Status values (`pending`, `approved`, `waived`) are set only by the designated human — the agent must not self-approve these fields. See `docs/optional/specialist-tracks.md` for the full sign-off structure.

## Sync
The lifecycle stage where repo state is reconciled after verification and human acceptance.

## Target Window
The planned delivery window for a task or capability, such as `2026-Q2` or `2026-04`.

## Traceability Matrix
`3-verify/TRACEABILITY_MATRIX.md`, which links features to spec, code, and test references and records drift status.

## Validation
Queue field that names the checks expected before build or records the evidence produced during verify.

## Quality Requirements
The home for persistent non-functional or cross-cutting standards: performance, security, compliance, operational posture (e.g. deployable on a given platform), and similar concerns that apply across multiple features or tasks rather than being one-time deliverables. Defined in `1-design/QUALITY_REQUIREMENTS.yaml` (optional register; activate when the project has durable standards worth tracking explicitly).

The `quality_requirements` field on `TASK_READINESS.yaml` and `WORK_QUEUE.yaml` entries lists QR IDs with `enforcement: per_task` or `enforcement: milestone` that apply to a specific task. Sustained QRs apply implicitly to all tasks and need not be listed per-task — agents read the full `sustained` list from `QUALITY_REQUIREMENTS.yaml` at build start.

## Decision Links
Structured list field in `TASK_READINESS.yaml` and `DESIGN_STATES.yaml` (`decision_links`) holding repo-relative paths to decision documents in `1-design/decisions/` (ADRs, deployment decisions, API contract decisions) that shaped the task or feature design. Use `[]` when no decisions are recorded.

## Enforcement
Quality Requirements field classifying how a requirement applies across the workflow:
- `sustained` — permanent standard; applies to every task; never globally satisfied; agents read the full list at build start
- `per_task` — applies each time a task of the relevant type occurs; link in `TASK_READINESS.quality_requirements` for matching tasks
- `milestone` — must be satisfied before a specific event or deployment gate; link in `TASK_READINESS.quality_requirements` for the milestone task

## Task Readiness Register
`1-design/TASK_READINESS.md`, the canonical design admission record. Holds IRG scores, blocking unknowns, readiness decisions, and specialist advisor tracking.

## Spec Link
`WORK_QUEUE.yaml` field holding the repo-relative path to the design spec for a task (e.g. `1-design/PROJECT_BRIEF.md` or a decisions doc). Build agents follow this link to find the spec they implement against without loading `TASK_READINESS.yaml`.

## Work Queue
`2-build/WORK_QUEUE.yaml`, the canonical execution table for task phase, owner, status, validation, and spec reference. Active tasks live here; completed tasks are moved to `2-build/archive/WORK_QUEUE.yaml`. Design readiness (IRG scores, QR links, advisor gate) lives in `TASK_READINESS.yaml`.

## awaiting_human_review
Queue status meaning implementation and verification evidence are ready for human sign-off.

## accepted
Queue status meaning a human explicitly signed off on the result.

## done
Queue status meaning the work is accepted and sync/closeout artifacts are complete.

## needs_rework
Queue status meaning a design-level problem was found — either by a human rejecting the task at Verify (when the root cause is design, not implementation) or by Sync finding design incomplete. Always set alongside `TASK_READINESS.Readiness = needs_detail`. If set at Verify, Sync must still run before the next Design session. Address `needs_rework` tasks at the start of the next Design phase before pulling new work.

## direct-use
Adoption path where a team starts from this template as the workspace itself and customizes it in place.

## sideload/adapt
Adoption path where an existing workspace incrementally absorbs a released version of this template without replacing project-owned state.
