# FEAT-SHP-001: Shopping list and main shell navigation

**Status:** implemented (awaiting human acceptance)  
**Priority:** P4 (V1.1)  
**Module:** Inventory | Recipes | Shell  
**Related AWP feature_id:** `FEAT-SHP-001`  
**Linked ideation:** [IDEA-011](../../product/ideation.md#idea-011-shopping-list)  
**Capability:** `CAP-V1-SHOP` (`active` in ROADMAP.yaml)

## Summary

Replace the crowded V1 two-column dashboard with a **two-tab main shell** (**In Stock** | **Shopping List**), each with its own add form and item list. **Suggested recipes** sit below the tab content as a **pager** (one recipe at a time). Users maintain a persistent shopping list and **Move to In Stock** after purchase, reusing inventory merge rules.

## User stories

- As a user, I switch between **In Stock** and **Shopping List** so each screen focuses on what I have vs what I plan to buy.
- As a user, I add items to **In Stock** with quantity, unit, and optional expiry — same as today.
- As a user, I add items to **Shopping List** with quantity and unit only (no expiry on the list).
- As a user, when I finish buying something, I tap **Move to In Stock** so it merges into my fridge inventory.
- As a user, I browse recipe suggestions one at a time with previous/next controls instead of scrolling many cards.
- As a user, I can add missing recipe ingredients to my shopping list from the pager card.

## Scope

### In scope

#### Main shell

| Area | Decision |
|------|----------|
| **Tabs** | **In Stock** \| **Shopping List** — bottom tab bar (mobile); segmented control or top tabs (desktop) |
| **Layout** | Single column: tabs → add form → item list → recipe pager. **No** side-by-side inventory/recipe panels |
| **Header** | Compact; **TRUESIGHT V2.1** eyebrow; **tab-specific headline** (inventory vs shopping tagline); full-width item-count bar (`N in stock` / `N to buy`) |
| **Summary strip** | **Remove** the V1 three-stat row (Expiring / Suggestions / Cooked). Optional: expiring-soon count in In Stock tab heading only |

Default tab on open: **In Stock**.

#### In Stock tab

- **Add:** ingredient name, quantity (stepper), unit, optional expiry → `POST /api/inventory` (unchanged).
- **List:** name, quantity, unit, expiry; **Delete** removes the row.
- Expiring-within-3-days styling unchanged ([ui-principles](../ui-principles.md)).

#### Shopping List tab

- **Add:** ingredient name, quantity (stepper), unit — **no expiry field**.
- **Add:** optional **camera preview** beside **Add** (bundled product-packaging sample image, stub detections, demo labeling) → `POST /api/shopping-list` on save — same review pattern as [FEAT-REC-002](FEAT-REC-002-fridge-photo-recognition.md) mockup; asset `/mockups/shopping-preset.png`.
- **List:** name, quantity, unit; primary action **move to stock** (green **left-arrow** icon; **check** to confirm).
- **Move to In Stock (OQ-056):** merges quantity into inventory (same normalized name + unit rules as inventory create); removes the shopping row. Optional **expiry date** on the row at move time — inline date field revealed when the user taps the move icon; may leave blank (null expiry).
- **Delete:** trash icon beside the move control (8px gap).
- **Recipe → list:** green **cart** icons per short line; **ALL** control in Amount in stock column header adds all missing lines.

#### Recipe pager (below tabs, both tabs)

- One `RecipeCard` visible; **Previous** / **Next** buttons; `n / total` or dot indicator.
- Same card content as [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md): servings stepper, ingredient table, Ready badge, **Cook and deduct**.
- Sort order unchanged (missing count ↑, score ↓, minutes ↑).
- Desktop: arrow keys move the pager when focus is not in an input.

#### Recipe → shopping list

- Short/missing ingredient rows: **Add to list** adds **gap quantity** (required − in stock, scaled by servings).
- Card-level **Add all missing** when `canCook === false`.
- Merge on shopping list if same normalized name + unit already exists.

### Out of scope

- Store distance / price ([IDEA-005](../../product/ideation.md#idea-005-store-recommendations-distance-price)).
- Auto-removing shopping lines when inventory increases elsewhere.
- Third tab for recipes.
- Unit conversion between recipe and inventory units.

## Behavior

### Shopping list persistence

- Per-user list; same identity as inventory ([TMP-001](../../../.awp-workspace/2-build/TEMP_MEASURES.yaml)).
- **Merge on create:** same normalized name + unit → add quantity to existing shopping row.

### Move to In Stock (server)

1. Validate shopping row belongs to user.
2. Merge quantity into `InventoryItem` via existing consolidator (earliest expiry wins when both sides have dates).
3. Delete shopping row.
4. Return updated inventory row (or 204 + client invalidates queries).

### Pager edge cases

- Zero recipes: empty pager with “Add ingredients to unlock recipe suggestions.”
- Single recipe: hide prev/next or disable both; still show `1 / 1`.

## API / contracts

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/shopping-list` | List for current user |
| POST | `/api/shopping-list` | Create or merge line `{ name, quantity, unit, sourceRecipeId? }` |
| DELETE | `/api/shopping-list/{id}` | Remove without moving → 204 or 404 |
| POST | `/api/shopping-list/{id}/move-to-inventory` | Body `{ expiryDate: null \| "YYYY-MM-DD" }` → merge + delete shopping row |

Existing inventory and recipe endpoints unchanged.

### Response shape (shopping list item)

```json
{
  "id": "uuid",
  "name": "spinach",
  "quantity": 2,
  "unit": "count",
  "sourceRecipeId": null,
  "createdAt": "2026-05-24T12:00:00Z"
}
```

## Data model

### ShoppingListItem (new — V1.1 schema)

- `id`, `userId`, `name`, `normalizedName`, `quantity`, `unit`, `createdAt`
- Optional: `sourceRecipeId` (audit when added from recipe gap)

Migration: yes — `ShoppingListItems` table. Existing SQLite files are patched at startup via `TrueSightDbInitializer` (`CREATE TABLE IF NOT EXISTS`).

[domain-model.md](../../product/domain-model.md) updated at sync 2026-05-24.

## UI layout

```text
┌─────────────────────────────────────┐
│  TrueSight              [n items]     │
├─────────────────────────────────────┤
│  [ In Stock  |  Shopping List ]     │
├─────────────────────────────────────┤
│  Add item form (tab-specific)       │
├─────────────────────────────────────┤
│  Item list (tab-specific actions)   │
├─────────────────────────────────────┤
│  Suggested recipe                   │
│  ◀   Recipe card (2 of 5)        ▶  │
└─────────────────────────────────────┘
```

## Suggested build split

| Task | Component | Scope |
|------|-----------|-------|
| BUILD-SHP-001 | backend | Entity, migration, shopping-list CRUD, move-to-inventory |
| BUILD-SHP-002 | frontend | Tab shell, lists, pager, wire to API |
| BUILD-SHP-003 | frontend | Recipe → add to list actions |

Dependencies: BUILD-SHP-002/003 depend on BUILD-SHP-001; BUILD-SHP-001 depends on BUILD-INV-001 (done).

## Acceptance criteria

- [x] Two tabs switch add form and list between In Stock and Shopping List.
- [x] In Stock: add (with expiry) and delete; no shopping actions.
- [x] Shopping List: add (no expiry), delete, and **move to stock** with optional expiry at move time.
- [x] Move merges into inventory and removes the shopping row; duplicate name+unit merges quantities.
- [x] Recipe pager shows one suggestion at a time with working prev/next (header arrows + swipe).
- [x] Short/missing recipe lines can be added to the shopping list (gap qty, merge on list).
- [x] V1 summary stat strip removed from main shell.
- [x] Mobile and desktop layouts remain usable.
- [x] Shopping photo preview mockup (sample packaging image, stub scan, save to shopping list).

## Open questions (resolved at design)

| ID | Question | Decision |
|----|----------|----------|
| OQ-056 | Expiry when moving to In Stock? | Optional inline date on the row when user initiates move; null if skipped |

## Traceability (AWP)

Registers updated: `FEATURE_REGISTRY`, `DESIGN_STATES`, `TRACEABILITY_MATRIX`, `ROADMAP` (`CAP-V1-SHOP`).
