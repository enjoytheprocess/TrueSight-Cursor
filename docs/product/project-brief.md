# Project brief

Durable project context for TrueSight (FridgeWise). **Task-by-task state** lives in [`.awp-workspace/`](../../.awp-workspace/) registers — not in this file.

## Name

- Project name: TrueSight (FridgeWise)

## Problem

- Problem statement: Users do not know what is in their fridge; perishables expire before use, wasting money and food.
- Target user: Anyone with a fridge; no cooking expertise assumed.

## Solution

- Users log fridge inventory (manual in V1; photo recognition in V2).
- The app recommends recipes from available ingredients.
- Accepting a recipe deducts inventory automatically.

## Repository mode

- Repository mode: single-component
- Adoption path: direct-use
- Primary component: `backend`

## Scope

- In scope: V1 — manual inventory, recipe suggestions, inventory deduction on recipe acceptance.
- Out of scope: V2 image recognition until Phase 2 (see [roadmap.md](roadmap.md)).
- Non-goals: Duplicating register state in `docs/`; scheduling wishlist items without promoting them from [ideation.md](ideation.md).

## Success signals

- Every build task has `spec_link` under `docs/design/features/` or `docs/product/`.
- Registers and `docs/` stay aligned after each verify/sync cycle.

## Constraints

- Tech: ASP.NET Core (.NET 9), EF Core + SQLite, React + TypeScript frontend.
- UX: Fully usable on mobile and desktop.
- Architecture: Vertical slices + CQRS (see `.cursor/rules/architecture.mdc` and `docs/architecture/`).

## Documentation map

| Topic | Location |
|-------|----------|
| Product index | [README.md](README.md) |
| Committed roadmap | [roadmap.md](roadmap.md) |
| Ideation | [ideation.md](ideation.md) |
| Domain model | [domain-model.md](domain-model.md) |
| User stories | [user-stories.md](user-stories.md) |
| Design stage guide | [../design/README.md](../design/README.md) |
| Feature specs | [../design/features/](../design/features/) |
| ADRs | [../design/decisions/](../design/decisions/) |

## Execution registers (AWP)

| Register | Path |
|----------|------|
| Ideation | `.awp-workspace/0-ideation/IDEATION_BACKLOG.yaml` |
| Design states | `.awp-workspace/1-design/DESIGN_STATES.yaml` |
| Roadmap | `.awp-workspace/1-design/ROADMAP.yaml` |
| Task readiness | `.awp-workspace/1-design/TASK_READINESS.yaml` |
| Work queue | `.awp-workspace/2-build/WORK_QUEUE.yaml` |
| Traceability | `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml` |

## Operating baseline

- Current phase: design
- Primary milestone(s): [roadmap.md](roadmap.md) and `.awp-workspace/1-design/ROADMAP.yaml`
- Active components: backend
- Human acceptance required before `accepted` / `done` on tasks.

## Notes

- New ideas → [ideation.md](ideation.md) + `IDEATION_BACKLOG.yaml`; promoted ideas join [roadmap.md](roadmap.md) and `ROADMAP.yaml`.
- Risks: build without updated traceability or specs in `docs/design/features/`.
