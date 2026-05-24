# FEAT-CAT-001: Ingredient catalog

**Status:** draft  
**Module:** Inventory  
**Related AWP feature_id:** `FEAT-CAT-001`

## Summary

Introduce a global **IngredientCatalog** reference table and optional links from user **InventoryItem** rows. Improves normalization, imagery, and recipe matching while **keeping inventory delete semantics unchanged** ([OQ-031](../../product/open-questions.md) — hard delete of the user's item only). Completing this feature removes temporary measure **TMP-002**.

## User story

As a user, I want to pick ingredients from a consistent catalog when adding inventory, so that names normalize reliably and recipes match my stock more accurately.

## Scope

### In scope

- `IngredientCatalog` persisted entity (name, category, default unit, optional image reference).
- **Organic catalog growth (OQ-053):** upsert a catalog row when the user adds inventory with a **new** name; no static seed file or external import for V1.
- `InventoryItem` optional FK to catalog (`IngredientCatalogId` nullable).
- **Inventory add UX (OQ-054):** typeahead/AJAX search against catalog as the user types; pick an existing entry (sets FK) or submit a new name (creates catalog row per OQ-053, then links inventory).
- **Inventory delete:** same as [FEAT-INV-001](FEAT-INV-001-manual-inventory.md) — `DELETE /api/inventory/{id}` hard-deletes only the user's `InventoryItem`; **does not** delete catalog rows.
- Recipe matching: use catalog normalization where linked; fallback to existing `NormalizedName` for unlinked rows.
- API contract updates for inventory create/update/list (expose catalog id + display name as needed).

### Out of scope

- Changing inventory delete to soft-delete or audit trail (deferred per FEAT-INV-001 AP-005).
- **Catalog delete/retire (OQ-055):** append-only in V1 — no user-facing or admin catalog delete; merge/dedupe tooling deferred.
- `RecipeIngredient` junction rework (domain model planned entity — follow-on).
- Receipt scan / vision catalog inference (V2 / ideation).

## Behavior

### Inventory CRUD (delete unchanged)

| Operation | Behavior |
|-----------|----------|
| List / get | Return inventory rows; include catalog display fields when `IngredientCatalogId` set |
| Create / update | Accept optional `ingredientCatalogId` from typeahead pick, or new `name` (creates catalog + links); validate FK when provided |
| **Delete** | **Hard delete** `InventoryItem` only (204/404). Catalog rows untouched. Same handler semantics as today. |

### Catalog reference data

- Catalog rows are **global** (not per-user).
- Deleting a user's fridge item must **never** cascade-delete catalog entries.
- V1 is **append-only** (OQ-055): no retire/delete API; existing FKs remain valid with denormalized display name on `InventoryItem` if needed later.

### Typeahead (OQ-054)

1. User types in the ingredient name field on add/edit inventory.
2. Client queries `GET /api/ingredients/catalog?q=…` (debounced).
3. User selects a suggestion → POST/PUT with `ingredientCatalogId` (name from catalog).
4. User submits a novel string with no pick → server creates/upserts catalog by normalized name, links new inventory row.

## API / contracts (draft)

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/ingredients/catalog` | `?q=` prefix search; V1 returns matching rows without pagination (OK while catalog is small/organic) |
| GET | `/api/ingredients/catalog/{id}` | Single catalog entry |
| POST/PUT | `/api/inventory` | Optional `ingredientCatalogId` on create/update; new name path per OQ-053 |
| DELETE | `/api/inventory/{id}` | **Unchanged** — hard delete item only |

## Data model

- New: `IngredientCatalog`
- Changed: `InventoryItem` — optional `IngredientCatalogId` FK
- Migrations: **Y**
- See [domain model](../../product/domain-model.md)

## Acceptance criteria

- [ ] Catalog table exists; rows created organically on first use of each normalized name (no seed file).
- [ ] User can add inventory via typeahead pick (catalog FK) or new name (creates catalog row).
- [ ] `DELETE /api/inventory/{id}` removes only the inventory row; catalog rows remain.
- [ ] No catalog delete/retire endpoints in V1.
- [ ] Recipe matching improves or matches current behavior for catalog-linked items.
- [ ] TMP-002 removed from `TEMP_MEASURES.yaml` when verified.

## Decisions

| ID | Decision |
|----|----------|
| [OQ-053](../../product/open-questions.md) | Catalog grows organically on inventory add — no static seed or external import |
| [OQ-054](../../product/open-questions.md) | Typeahead search; optional FK with new-name path |
| [OQ-055](../../product/open-questions.md) | Append-only catalog in V1 — no delete/retire |
| [OQ-031](../../product/open-questions.md) | Inventory hard delete unchanged when catalog ships |
| [OQ-030](../../product/open-questions.md) | V1 inline names only until TMP-002 removed — see [FEAT-INV-001](FEAT-INV-001-manual-inventory.md) |

## Traceability (AWP)

- Temporary measure removed: **TMP-002**
- Depends on: **FEAT-INV-001** (inline inventory baseline)
- Build task: **BUILD-CAT-001** (design phase — not yet build-admitted)
