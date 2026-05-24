# Project brief

Durable project context for TrueSight (FridgeWise). **Task-by-task state** lives in [`.awp-workspace/`](../../.awp-workspace/) registers — not in this file.

## Name

- Project name: TrueSight (FridgeWise)

## Problem

- **Problem statement:** Users do not remember everything in their fridge. Perishables expire before use, wasting money and food — the cost of not knowing is high for perishable inventory.
- **Personal use:** Households lose food and money when items spoil unnoticed.
- **Charity / food-bank angle:** Shared or donation kitchens face the same perishability risk at scale. Charity-specific flows are **not** in MVP scope; see [ideation.md](ideation.md) (IDEA-007).
- **Target user:** Anyone with a fridge; no cooking expertise assumed.

## Solution

- Users log what they have in the app (manual in V1; fridge photo in V2).
- The app recommends recipes from available ingredients.
- Accepting a recipe deducts inventory automatically.

## Priorities

| Priority | Input method | Phase |
|----------|--------------|-------|
| P1 | Manual inventory entry | V1 |
| P2 | Photograph the fridge | V2 |

**Development order:** Inventory → recipe suggestions → image recognition (see [roadmap.md](roadmap.md)).

## Primary user journey

**V1**

1. Add or view inventory (manual).
2. Browse recipe suggestions matched to current stock.
3. Accept a recipe → ingredients deducted from inventory.

**V2 shortcut**

1. Take a fridge photo on the web client.
2. Review and confirm detected items → save to inventory.
3. Browse recipes → accept → deduct (same as V1).

## Delivery model

- **Mobile-first responsive web** with PWA-style enhancements (installable where supported, app-like layout on phone).
- **Not** a native mobile app for MVP — shareable URL, single codebase for phone and desktop.
- Camera access via standard web APIs (`getUserMedia`, or `<input type="file" accept="image/*" capture="environment">` for rear camera on many devices).
- Fully usable on mobile and desktop (non-functional requirement).

## Repository mode

- Repository mode: single-component
- Adoption path: direct-use
- Primary component: `backend`

## Scope

- **In scope (V1):** Manual inventory CRUD, recipe suggestions from inventory, inventory deduction on recipe acceptance.
- **Deferred from V1 (temporary):** User sign-up/login — **off** for the current core loop; interim **demo login screen** with disabled auth controls and **Enter Demo** ([FEAT-AUTH-001](../design/features/FEAT-AUTH-001-demo-login-screen.md), [ADR-20260524-01](../design/decisions/ADR-20260524-01-v1-interim-identity-header.md), TMP-001). Real auth in a follow-on task.
- **In scope (V2):** Fridge photo → detection → user confirmation → inventory (see [roadmap.md](roadmap.md)).
- **Out of scope for MVP:** Native apps; charity/org-specific product flows (ideation only); receipt scanning (ideation IDEA-008).
- **Non-goals:** Duplicating register state in `docs/`; scheduling wishlist items without promoting them from [ideation.md](ideation.md).

## Integrations (plug-and-play)

- **Recipe data:** Abstract behind a provider adapter — Spoonacular, Edamam, or custom catalog via configuration (see [ADR-20260523-02-recipe-provider-adapter.md](../design/decisions/ADR-20260523-02-recipe-provider-adapter.md)).
- **V2 vision:** Pluggable recognition service behind the API (see [ADR-20260523-03-v2-vision-boundary.md](../design/decisions/ADR-20260523-03-v2-vision-boundary.md)).

## Success signals

- Every build task has `spec_link` under `docs/design/features/` or `docs/product/`.
- Registers and `docs/` stay aligned after each verify/sync cycle.

## Constraints

- **Tech:** ASP.NET Core (.NET 9), EF Core + **SQLite** (MVP and first production scale per [OQ-004](open-questions.md)), React + TypeScript frontend.
- **Expiry UX:** Inventory “expiring soon” highlight within **3 days** of expiry ([OQ-040](open-questions.md), [ui-principles](../design/ui-principles.md)).
- **UX:** Mobile-first responsive web; PWA-capable; desktop parity.
- **Architecture:** Layered client-server; vertical slices + CQRS on the API (see [../architecture/overview.md](../architecture/overview.md) and `.cursor/rules/architecture.mdc`).

## Documentation map

| Topic | Location |
|-------|----------|
| Product index | [README.md](README.md) |
| Committed roadmap | [roadmap.md](roadmap.md) |
| Ideation | [ideation.md](ideation.md) |
| Domain model | [domain-model.md](domain-model.md) |
| User stories | [user-stories.md](user-stories.md) |
| Use cases & scenarios | [use-cases.md](use-cases.md) |
| Open questions | [open-questions.md](open-questions.md) |
| Architecture overview | [../architecture/overview.md](../architecture/overview.md) |
| Vertical slices | [../architecture/vertical-slices.md](../architecture/vertical-slices.md) |
| UI principles | [../design/ui-principles.md](../design/ui-principles.md) |
| Advisor policy | [../design/advisor-policy.md](../design/advisor-policy.md) |
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
- Alternate stack notes (Firebase / Next.js) captured in ideation IDEA-010 — not the committed stack.
- Risks: build without updated traceability or specs in `docs/design/features/`.
