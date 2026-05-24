# Domain Model

V1 entities are required for Phase 1 build. Shapes marked **planned (V2+)** or **ideation** are documented for alignment but are not implied in the V1 schema until promoted.

## Core Entities (V1)

### InventoryItem

A user's instance of an ingredient in their fridge.

- `name`, `normalizedName` (server-derived), quantity, unit, expiry date, date added
- **V1 (TMP-002):** inline free-text names only — no `IngredientCatalog` foreign key
- **Delete:** hard delete of the user's `InventoryItem` row (`DELETE` → 204). Removing an item does **not** delete or mutate catalog reference data. This semantics is stable when `IngredientCatalog` ships later — only the optional FK/link on create/update changes, not delete behavior.

### Recipe

- name, description, cuisine type, difficulty level
- required ingredients with quantities
- estimated cooking time, serving size

May be sourced from an external catalog via **RecipeProvider** (integration boundary — not a persisted domain entity).

### RecipeSession

When a user accepts a recipe — triggers inventory deduction.

- selected recipe, serving multiplier, timestamp

### ShoppingListItem (V1.1 — [FEAT-SHP-001](../design/features/FEAT-SHP-001-shopping-list-and-main-shell.md))

A user's planned grocery line — not yet in the fridge.

- `name`, `normalizedName`, quantity, unit, `createdAt`
- optional `sourceRecipeId` when added from a recipe gap
- **Move to In Stock:** merges into `InventoryItem` (same name + unit rules), then row is deleted
- **Not in V1 core schema** until V1.1 build ships

## Integration boundary

### RecipeProvider (adapter, not persisted)

Abstraction for plug-and-play recipe data (Spoonacular, Edamam, custom). The API selects an implementation via configuration. No vendor-specific types in core entities. See [ADR-20260523-02-recipe-provider-adapter.md](../design/decisions/ADR-20260523-02-recipe-provider-adapter.md).

## Planned entities (V2+ / ideation — not V1 schema)

### IngredientCatalog

Global reference list of ingredients (name, category, unit of measure). **Deferred (TMP-002)** — current V1 build uses inline names on `InventoryItem` only.

When implemented ([FEAT-CAT-001](../design/features/FEAT-CAT-001-ingredient-catalog.md)):

- Catalog rows grow **organically** when users add inventory with new names (OQ-053) — no static seed file.
- `InventoryItem` may optionally FK to catalog; add flow uses **typeahead** search (OQ-054).
- Catalog is **append-only** in V1 — no delete/retire API (OQ-055).
- **Inventory delete stays the same:** delete removes only the user's `InventoryItem`; catalog rows are global reference data and are not removed when a user deletes stock (OQ-031).

### RecipeIngredient

Junction between Recipe and IngredientCatalog (quantity, unit, optional flag). Applies when catalog ships.

### UserProfile

- dietary restrictions
- cuisine preferences
- cooking ability (beginner / intermediate / advanced)
- available kitchen equipment

**Status:** Ideation-dependent — promote from [ideation](ideation.md) IDEA-003 / IDEA-004 before any V1 build depends on profile filtering.

### DetectedItem (V2 fridge recognition)

Transient detection result before user confirmation (not persisted until save).

- suggested **name** (read-only in UI mockup; editable in production TBD)
- **quantity**, **unit**, optional **expiry** — user-editable on review screen
- **confidence** (`high` | `medium` | `low`) — UI only; drives default include toggle
- materializes as `InventoryItem` via `POST /api/inventory` (mockup) or batch confirm API (production TBD)

### ReceiptScan (ideation — IDEA-008)

Receipt photo upload and parsed line items (names, quantities, suggested expiry). Not on committed roadmap.

### DetectedLineItem

Child of ReceiptScan: item name, quantity, optional image reference, suggested expiry.

## Key Relationships

- UserProfile → many InventoryItems *(when profile ships)*
- Recipe → many RecipeIngredients
- RecipeSession → deducts InventoryItems
- ReceiptScan → many DetectedLineItems *(planned)*
