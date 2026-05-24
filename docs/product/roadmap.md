# Product roadmap (committed)

Phases the team has committed to deliver. Exploratory ideas live in [ideation.md](ideation.md) and [`.awp-workspace/0-ideation/`](../.awp-workspace/0-ideation/).

## Phase 1 — Core (V1)

| # | Capability | Notes |
|---|------------|--------|
| 0 | Identity (demo entry) | **V1:** demo login screen + `X-TrueSight-User` header ([ADR-20260524-01](../design/decisions/ADR-20260524-01-v1-interim-identity-header.md), [FEAT-AUTH-001](../design/features/FEAT-AUTH-001-demo-login-screen.md)); real sign-up/login follow-on |
| 1 | Inventory management (manual input) | CRUD, quantity, expiry; list/view |
| 2 | Recipe suggestions from current inventory | Match available ingredients via recipe provider adapter |
| 3 | Inventory deduction on recipe acceptance | `RecipeSession` flow |

**Delivery:** Mobile-first responsive web (PWA-capable). See [architecture overview](../architecture/overview.md).

## Phase 2 — Smart input (V2)

| # | Capability | Notes |
|---|------------|--------|
| 4 | Fridge photo recognition | Upload photo → vision service → detected items → **user confirms/edits** → inventory |

## Explicit non-goals (MVP)

- **Native mobile app** (iOS/Android store) — deferred until web MVP proves usage.
- Charity/org-specific inventory flows — ideation only ([IDEA-007](ideation.md#idea-007-charity--food-bank-persona)).

## Not on this roadmap

Wishlist and “nice to have” items are **ideation** — see [ideation.md](ideation.md). Promote to this roadmap only after an explicit decision (update AWP `ROADMAP.yaml` and registers).
