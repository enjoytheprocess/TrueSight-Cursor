# Product roadmap (committed)

Phases the team has committed to deliver. Exploratory ideas live in [ideation.md](ideation.md) and [`.awp-workspace/0-ideation/`](../.awp-workspace/0-ideation/).

## Phase 1 — Core (V1) — **delivered 2026-05-24**

| # | Capability | Notes |
|---|------------|--------|
| 0 | Identity (demo entry) | Demo login + `X-TrueSight-User`; demo inventory seed |
| 1 | Inventory management (manual input) | CRUD, merge on create, quantity, expiry |
| 2 | Recipe suggestions from current inventory | Ingredient table, servings, canCook |
| 3 | Inventory deduction on recipe acceptance | `RecipeSession` flow; all ingredients deducted |

**Delivery:** Mobile-first responsive web (PWA-capable). See [architecture overview](../architecture/overview.md).

## Phase 2 — Smart input (V2)

| # | Capability | Notes |
|---|------------|--------|
| 5 | Fridge photo recognition | **UI mockup first:** camera beside Add → preset photo → stub scan → user edits qty/unit/expiry → save. **Then:** upload → vision service → same review → inventory ([FEAT-REC-002](../design/features/FEAT-REC-002-fridge-photo-recognition.md)) |

## Explicit non-goals (MVP)

- **Native mobile app** (iOS/Android store) — deferred until web MVP proves usage.
- Charity/org-specific inventory flows — ideation only ([IDEA-007](ideation.md#idea-007-charity--food-bank-persona)).

## Phase 1.1 — Shopping list (V1.1) — **implemented 2026-05-24, awaiting acceptance**

| # | Capability | Notes |
|---|------------|--------|
| 4 | Shopping list + tab shell (`CAP-V1-SHOP`) | In Stock \| Shopping List tabs, recipe pager, move-to-stock, recipe → cart, shopping photo preview mockup — [FEAT-SHP-001](../design/features/FEAT-SHP-001-shopping-list-and-main-shell.md) |

## Phase 1.2 — Profile & settings (V1.2) — **design only (2026-05-26)**

| # | Capability | Notes |
|---|------------|--------|
| 6 | User profile & settings (`CAP-V1-PROFILE`) | Diet/allergies, cuisine/skill/equipment, prioritize expiring toggle, per-item **use first** — [FEAT-PRF-001](../design/features/FEAT-PRF-001-user-profile-and-settings.md). **Not build-admitted.** Promoted from IDEA-002/003/004/012. |

**Sequencing:** After V1.1 shopping acceptance; profile persistence pairs with real auth ([FEAT-AUTH-002](../design/features/FEAT-AUTH-002-real-authentication.md)) for production; demo may use `X-TrueSight-User` first.

## Parked / lower priority

## Not on this roadmap

Wishlist and “nice to have” items are **ideation** — see [ideation.md](ideation.md). Promote to this roadmap only after an explicit decision (update AWP `ROADMAP.yaml` and registers).
