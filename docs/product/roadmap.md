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

## Phase 1.3 — Polish (V1.3) — **design only**

| # | Capability | Design priority | Features |
|---|------------|-----------------|----------|
| 7 | Quick UX (`CAP-V1-POLISH`) | P1 | Expiry banner [FEAT-INV-002](../design/features/FEAT-INV-002-expiry-proximity-warnings.md), search/filter [FEAT-INV-003](../design/features/FEAT-INV-003-inventory-search-filter.md), default servings [FEAT-REC-003](../design/features/FEAT-REC-003-default-serving-context.md) |

## Phase 1.4 — Trust (V1.4) — **design only**

| # | Capability | Design priority | Features |
|---|------------|-----------------|----------|
| 8 | Cook trust (`CAP-V1-TRUST`) | P2–P3 | Undo [FEAT-SES-002](../design/features/FEAT-SES-002-recipe-session-undo.md), partial deduct [FEAT-SES-003](../design/features/FEAT-SES-003-partial-deduction.md) |

## Phase 1.5 — Platform (V1.5) — **design only**

| # | Capability | Design priority | Features |
|---|------------|-----------------|----------|
| 9 | PWA (`CAP-V1-PLATFORM`) | P2 | [FEAT-PLT-001](../design/features/FEAT-PLT-001-pwa-offline-shell.md) |

## Phase 1.6 — Discovery (V1.6) — **design only**

| # | Capability | Design priority | Features |
|---|------------|-----------------|----------|
| 10 | Browse beyond stock (`CAP-V1-DISCOVERY`) | P3 | [FEAT-REC-004](../design/features/FEAT-REC-004-discovery-browse.md) — after profile |

## Later design (P3–P4)

| Capability | Notes |
|------------|--------|
| `CAP-V2-INPUT` | Receipt photo [FEAT-REC-005](../design/features/FEAT-REC-005-receipt-photo-inventory.md) after fridge vision production |
| `CAP-V1-HOUSEHOLD` | [FEAT-HH-001](../design/features/FEAT-HH-001-household-sharing.md) — needs auth UI |
| `CAP-V1-COMMERCE` | [FEAT-SHP-002](../design/features/FEAT-SHP-002-store-recommendations.md) |
| `CAP-V2-ORG` | [FEAT-ORG-001](../design/features/FEAT-ORG-001-charity-food-bank-persona.md) — persona/design |

**Sort order:** [design-priority-queue.md](../design/design-priority-queue.md) · AWP: `.awp-workspace/1-design/ROADMAP.yaml`

## Parked / lower priority

- [IDEA-010](ideation.md) — Firebase-first stack (parked)

## Not on this roadmap

Ideation backlog is empty (all promoted 2026-05-26). New ideas start in `.awp-workspace/0-ideation/IDEATION_BACKLOG.yaml` before promotion.
