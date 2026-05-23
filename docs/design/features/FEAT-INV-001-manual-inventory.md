# FEAT-INV-001: Manual inventory

**Status:** draft  
**Module:** Inventory  
**Related AWP feature_id:** `FEAT-INV-001`

## Summary

Allow users to maintain fridge inventory through manual create, read, update, and delete of items (ingredient reference, quantity, unit, optional expiry). Supports the V1 path before any photo-based input.

## User story

As a user, I want to add, view, edit, and remove what I have in my fridge, so that recipes can be matched to my real stock.

## Scope

### In scope

- List inventory for the authenticated user.
- Add item with quantity, unit, optional expiry, link to `IngredientCatalog` (or inline name if catalog not populated — TBD at build).
- Update and delete items.
- Mobile-friendly API contracts (paginated list if needed).

### Out of scope

- Fridge photo detection (V2 — `FEAT-REC-002`).
- Receipt scanning ([IDEA-008](../../product/ideation.md#idea-008-receipt-photo--inventory-list)).
- Expiry notifications ([IDEA-006](../../product/ideation.md#idea-006-expiry-proximity-warnings)).
- Multi-tenant / charity org models ([IDEA-007](../../product/ideation.md#idea-007-charity--food-bank-persona)).

## Behavior

- All operations are scoped to the current user (identity approach TBD during auth design).
- Deletes are hard or soft — choose at implementation; document in API.
- Quantities are non-negative; unit must be consistent with catalog or a fixed allow-list.

## API / contracts

Placeholder minimal API surface (paths and shapes refined at build admission):

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/inventory` | List current user's items |
| POST | `/api/inventory` | Create item |
| GET | `/api/inventory/{id}` | Get single item |
| PUT / PATCH | `/api/inventory/{id}` | Update item |
| DELETE | `/api/inventory/{id}` | Remove item |

## Data model

- Entities: `InventoryItem`, `IngredientCatalog` (see [domain model](../../product/domain-model.md))
- Migrations needed: **Y** (when API project is scaffolded)

## Acceptance criteria

- [ ] User can list, create, update, and delete inventory via API (or via UI once wired).
- [ ] Invalid payloads return consistent problem details.
- [ ] Operations are isolated per user.

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
