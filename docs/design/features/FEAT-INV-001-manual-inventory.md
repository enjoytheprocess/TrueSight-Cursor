# FEAT-INV-001: Manual inventory

**Status:** ready  
**Module:** Inventory  
**Related AWP feature_id:** `FEAT-INV-001`

## Summary

Allow users to maintain fridge inventory through manual create, read, update, and delete of items (**inline ingredient name**, quantity, unit, optional expiry). Supports the V1 path before any photo-based input.

## User story

As a user, I want to add, view, edit, and remove what I have in my fridge, so that recipes can be matched to my real stock.

## Scope

### In scope

- List inventory for the current user.
- Add item with **inline name**, quantity, unit, optional expiry (TMP-002 — no catalog link).
- Update and delete items.
- Per-user isolation ([ADR-20260524-01](../decisions/ADR-20260524-01-v1-interim-identity-header.md), TMP-001).

### Out of scope

- `IngredientCatalog` table (**TMP-002** — deferred; keep current inline schema).

- Fridge photo detection (V2 — `FEAT-REC-002`).
- Receipt scanning ([IDEA-008](../../product/ideation.md#idea-008-receipt-photo--inventory-list)).
- Expiry notifications ([IDEA-006](../../product/ideation.md#idea-006-expiry-proximity-warnings)).
- Multi-tenant / charity org models ([IDEA-007](../../product/ideation.md#idea-007-charity--food-bank-persona)).

## Behavior

- All operations are scoped to the current user (see [ADR-20260524-01](../decisions/ADR-20260524-01-v1-interim-identity-header.md) — login off; `X-TrueSight-User` interim identity, TMP-001).
- **Delete:** hard delete of the user's `InventoryItem` (`DELETE /api/inventory/{id}` → 204 or 404). No soft-delete or audit trail in V1. **Unchanged when IngredientCatalog ships** — catalog is reference data; deleting inventory does not delete catalog rows (see [domain model](../../product/domain-model.md)).
- Quantities are non-negative; **units** are free-text strings (max 32 chars); recipe matching requires **exact same unit** on inventory and recipe line.
- **Merge on create:** `POST /api/inventory` with the same normalized name + unit as an existing row **adds quantity** to that row (earliest expiry wins). `InventoryConsolidator` removes duplicate rows for the same user/name/unit after create.
- **Add form UX:** labeled fields; quantity and unit on one row; integer quantity step.

## API / contracts

Placeholder minimal API surface (paths and shapes refined at build admission):

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/inventory` | Full list for current user (**V1:** no pagination — see deferred polish) |
| POST | `/api/inventory` | Create item |
| GET | `/api/inventory/{id}` | 200 or **404** (plain, no body — see deferred polish) |
| PUT | `/api/inventory/{id}` | Update (**V1:** PUT only — PATCH deferred) |
| DELETE | `/api/inventory/{id}` | 204 or 404 |

Validation errors (400) return problem details. **Identity:** `X-TrueSight-User` header.

### Deferred API polish (DI-006 — resolve individually post-V1)

Track each item separately; do not block V1 re-build on these:

| ID | Item | V1 behavior | Future target |
|----|------|-------------|---------------|
| AP-001 | PATCH support | PUT only | Add PATCH for partial updates |
| AP-002 | 404 problem details | Empty 404 body on GET/PUT/DELETE | RFC7807 body consistent with 400 |
| AP-003 | List pagination | Return full user list | `?page` / cursor when lists grow |
| AP-004 | Cross-user isolation tests | **Required** — integration test: user A cannot GET/PUT/DELETE user B's item id | Keep as sustained gate |
| AP-005 | Hard vs soft delete | **Hard delete** (204/404); stable when catalog links added | Soft delete + audit only if product requires undo/history later |

## Data model

- Entity: `InventoryItem` only (see [domain model](../../product/domain-model.md), TMP-002)
- Migrations: **Y** when schema changes (no catalog table in V1 re-build)

## Acceptance criteria

- [x] User can list, create, update, and delete inventory via API (or via UI once wired).
- [x] Invalid payloads return consistent problem details.
- [x] Operations isolated per user (includes AP-004 cross-user test).

## Traceability (AWP)

After approval, add/update rows in:

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- `.awp-workspace/1-design/DESIGN_STATES.yaml`
- `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml`
- `.awp-workspace/2-build/WORK_QUEUE.yaml` (when admitting tasks)

`spec_link` for build tasks → this file path.

## Advisor tracks

At build admission (see [advisor-policy.md](../advisor-policy.md)):

- Implement CRUD → `security` (per-user isolation, validation)
- Document/publish inventory API → `api_contract`

## Decisions

- Delivery: [ADR-20260523-01](../decisions/ADR-20260523-01-delivery-model-pwa-web.md) — client can be PWA-style web; inventory rules live on server.
