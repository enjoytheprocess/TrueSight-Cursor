# Project Brief

Durable project context. **Design specifications and ADRs live in [`docs/`](../../docs/)** (use `@docs/` in Cursor). Task-by-task state stays in AWP registers under `.awp-workspace/`.

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
- Out of scope: V2 image recognition until Phase 2 (see `docs/product/roadmap.md`).
- Non-goals: Duplicating register state in `docs/`; side queues outside AWP.

## Success signals

- Every build task has `spec_link` under `docs/design/features/` or `docs/product/`.
- Registers and `docs/` stay aligned after each verify/sync cycle.

## Constraints

- Tech: ASP.NET Core (.NET 9), EF Core + SQLite, React + TypeScript frontend.
- UX: Fully usable on mobile and desktop.
- Architecture: Vertical slices + CQRS (see `.cursor/rules/architecture.mdc`).

## Design documentation (canonical location)

| Doc | Path |
|-----|------|
| Index | `docs/README.md` |
| Roadmap | `docs/product/roadmap.md` |
| Domain model | `docs/product/domain-model.md` |
| User stories | `docs/product/user-stories.md` |
| Feature specs | `docs/design/features/` |
| ADRs | `docs/design/decisions/` |

## Canonical registers (execution state)

- Feature design state: `1-design/DESIGN_STATES.md`
- Sequencing: `1-design/ROADMAP.md`
- Tasks: `2-build/WORK_QUEUE.md`
- Traceability: `3-verify/TRACEABILITY_MATRIX.md`

## Operating baseline

- Current phase: design
- Primary milestone(s): see `1-design/ROADMAP.md` and `docs/product/roadmap.md`
- Active components: backend
- Human acceptance required before `accepted` / `done` on tasks.

## Notes

- When product vision changes, update `docs/product/` first, then `ROADMAP.yaml` and related registers.
- Risks: build without updated traceability or specs in `docs/design/features/`.
