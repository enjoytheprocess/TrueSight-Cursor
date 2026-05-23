# Project Brief

Use this file for durable project context and constraints.
Keep task-by-task execution state in the canonical registers:

- `1-design/DESIGN_STATES.md`
- `1-design/ROADMAP.md`
- `2-build/WORK_QUEUE.md`
- `3-verify/TRACEABILITY_MATRIX.md`

Detailed workflow terms live in `docs/core/glossary.md`.

## Name
- Project name: TrueSight

## Problem
- Problem statement: Describe the core workflow or product problem here.
- Target user: Primary user or operator

## Repository mode
- Repository mode: single-component
- Adoption path: direct-use

## Scope
- In scope: initial project framing, first feature sequencing, and the first executable task.
- Out of scope: detailed product specs that should live in dedicated design documents once the project grows.
- Non-goals: preserving every optional register before the team knows it needs that coordination overhead.

## Success signals
- The team can explain the first milestone, first feature, and first task without inventing side docs.
- The queue and traceability rows are ready to evolve as the project moves from design into build.

## Constraints
- Tech constraints: replace placeholder values before build admission.
- Security/compliance constraints: engage a specialist advisor as soon as one is needed.
- Performance constraints: keep the first milestone small enough to validate quickly.
- External dependencies: list major services, repos, or providers once they are known.

## Operating baseline
- Current phase: design
- Primary milestone(s): see `1-design/ROADMAP.md`
- Active components: backend
- Primary owners or decision-makers: (define as needed)
- Decision cadence or review expectations: human acceptance is explicit before work moves to `accepted`.

## Assumptions and open questions
- Stable areas: replace with the parts of the design that are already clear.
- Current assumptions: add any assumptions that affect interfaces, sequencing, or verification.
- Open questions: list the decisions still required before build admission.

## Canonical registers
- Ideas and early discussion: `0-ideation/IDEATION_BACKLOG.yaml` when ideation is in use.
- Feature design state: `1-design/DESIGN_STATES.md`
- Sequencing and target windows: `1-design/ROADMAP.md`
- Executable tasks and readiness: `2-build/WORK_QUEUE.md`
- Traceability and drift: `3-verify/TRACEABILITY_MATRIX.md`
- Specialist reviews: `3-verify/SECURITY_REVIEWS.md`, `3-verify/EXPERIMENT_REVIEWS.md`, `3-verify/INCIDENT_RESPONSES.md` when active

## Notes
- Links to supporting specs, contracts, or ADRs: add as soon as they exist.
- Risks worth keeping visible: build-ready work without updated traceability or unresolved design assumptions.
