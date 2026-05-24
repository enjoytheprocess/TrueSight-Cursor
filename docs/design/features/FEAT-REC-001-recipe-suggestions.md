# FEAT-REC-001: Recipe suggestions from inventory

**Status:** ready  
**Module:** Recipes  
**Related AWP feature_id:** `FEAT-REC-001`

## Summary

Given the user's current inventory, return recipe suggestions by calling a **RecipeProvider** adapter that normalizes external or internal recipe data into the product's recipe model. Ranking and “how well it matches” behavior are defined at implementation time within this feature.

## User story

As a user, I want to see recipes I can make with what I have now, **including how much of each ingredient I need and what I have in stock**, so that I use food before it expires and I am not surprised when I cook.

## Scope

### In scope

- Query endpoint(s) that consume current inventory and return a list of suggested recipes.
- Integration with **one** configured `RecipeProvider` implementation (Spoonacular, Edamam, or stub for dev).
- **Per-ingredient match lines** on each suggestion: required amount vs in-stock amount (same unit), for the recipe’s default serving count.
- **`canCook` (or equivalent) flag** per recipe: `true` only when every **required** ingredient has sufficient in-stock quantity for default servings (see [Cook gate](#cook-gate)).
- Recipe card UI (see [Recipe card UX](#recipe-card-ux)) and [ui-principles.md](../ui-principles.md).

### Out of scope

- Cuisine discovery mode, dietary filters, serving-size scaling UX ([IDEA-001](../../product/ideation.md#idea-001-serving-size-selector), [IDEA-002](../../product/ideation.md#idea-002-cuisine-preferences--discovery-mode), [IDEA-003](../../product/ideation.md#idea-003-dietary-restrictions--allergy-filtering)) — unless explicitly promoted later.
- Deducting inventory (see `FEAT-SES-001`).
- Persisting recipes locally (optional cache — separate task if needed).
- **Deferred (not V1):** unit conversion (e.g. recipe `50 g` cheese vs inventory `1 wheel`); partial recipe adherence (“user didn’t follow the recipe”); see [Deferred concerns](#deferred-concerns).

## Behavior

- Read-only from inventory perspective — no mutations in this feature.
- Ingredient matching uses **normalized name** + **exact unit string** (same rule as accept/deduct in `FEAT-SES-001`). No unit conversion in V1.
- **In-stock quantity** for a recipe line = sum of `InventoryItem.quantity` for the current user where `NormalizedName` matches and `unit` equals the recipe line’s unit.
- **Provider errors (OQ-035):** return **empty list** plus an error message/code; client shows the message and a **Refetch** control to retry `GET /api/recipes/suggestions`.
- **Ingredient matching (OQ-033):** V1 **Static** provider uses **normalized name + exact unit** only — same strings as inventory; no provider ingredient IDs or fuzzy match.

### Cook gate

**Cook and deduct** (primary action on the recipe card) is **enabled** only when:

1. `canCook === true` from the suggestions API for that recipe at **default servings** (V1 UI sends `servingMultiplier: 1` on accept), and  
2. No accept request is already in flight (client loading state).

`canCook` is `false` when any **required** (`optional: false`) ingredient has `inStockQuantity < requiredQuantity` (after applying default servings). Optional ingredients do **not** block `canCook`.

The accept endpoint (`FEAT-SES-001`) **re-validates** quantities server-side; the UI gate is for trust and clarity, not the only enforcement.

### Recipe card UX

Each recipe suggestion card must show, for every ingredient the recipe uses (required and optional):

| Display | Meaning |
|---------|---------|
| **Required** | Amount + unit from the recipe for default servings (e.g. `2 count` eggs). |
| **In stock** | Aggregated matching inventory for that name + unit (e.g. `4 count`). |
| **Status** | Sufficient / short / missing (name not in inventory). |

**Examples**

- Vegetable Omelette: `eggs — need 2 count · have 4 count` → sufficient; **Cook and deduct** enabled.  
- Same recipe with `1 count` eggs in stock: `need 2 count · have 1 count` → short; **Cook and deduct** disabled.  
- Ingredient absent: `need 2 count · have 0` or “not in fridge” → missing; disabled.

Do **not** show only ingredient name chips without quantities (prior UI gap: “eggs” with no `2` misled users into expecting a 1-egg deduct).

Badge **Ready** means `canCook === true` (all required lines sufficient), not merely “ingredient name exists in inventory.”

Show **servings** for the recipe (e.g. “Serves 1”) so required amounts are interpretable.

Optional ingredients: list with required vs in-stock; label as optional; do not block cook when short or missing.

### Deferred concerns

Document for later design; **do not implement in V1** unless promoted:

| Concern | Note |
|---------|------|
| **Unit mismatch** | Recipe and inventory must use the same unit string today (e.g. both `g`). Converting `1 wheel` ↔ `50 g` is out of scope. |
| **Recipe adherence** | Accept always deducts per recipe quantities; no “I used less” adjustment on the card. |

### MVP ranking (simple score, not ML)

Rank suggestions with a transparent heuristic so “use it before it spoils” works without a fancy recommender:

| Signal | Effect on score |
|--------|-----------------|
| More ingredients already owned | Higher |
| Fewer missing ingredients | Higher |
| Uses items expiring soonest | Higher |
| Matches diet/allergy preferences | Higher *(when profile ships — until then, ignore or provider-only filters)* |
| Shorter cooking time | Higher |

**Example:** Stock: chicken (expires tomorrow), spinach (2 days), eggs, cheese → prefer chicken–spinach dishes over recipes that ignore soon-to-expire items.

**V1 ranking (OQ-036)** — keep current implementation:

- Per-recipe score: `(owned×12) − (missing×18) + (expiringSoon×8) − min(minutes,60)/10`
- Sort order: missing ingredient count ↑, score ↓, estimated minutes ↑

Document any weight change in this spec before altering `ListRecipeSuggestions/Handler.cs`.

## API / contracts

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/recipes/suggestions` | Server reads current user inventory; returns suggestions with ingredient lines below |
| GET | `/api/recipes/{id}` | Detail view; same ingredient line shape when used by UI |

**V1 decision:** Server-read inventory (not client snapshot).

### Suggestion response (per recipe)

Extend the suggestion DTO beyond name-only chips. Minimal shape:

```json
{
  "id": "vegetable-omelette",
  "name": "Vegetable Omelette",
  "servings": 1,
  "estimatedMinutes": 15,
  "canCook": true,
  "missingIngredientCount": 0,
  "ingredients": [
    {
      "name": "eggs",
      "requiredQuantity": 2,
      "unit": "count",
      "optional": false,
      "inStockQuantity": 4,
      "status": "sufficient"
    },
    {
      "name": "spinach",
      "requiredQuantity": 60,
      "unit": "g",
      "optional": true,
      "inStockQuantity": 0,
      "status": "missing"
    }
  ]
}
```

**`status` values:** `sufficient` | `short` | `missing` (required line with zero matching stock).

**`canCook`:** `true` iff every line with `optional: false` has `status === sufficient`.

Existing fields (`score`, `cuisineType`, `description`, etc.) may remain; replace or deprecate string-only `usesIngredients` / `missingIngredients` in favor of `ingredients[]` when build implements this spec.

## Data model

- Read: `InventoryItem` (inline names; see `FEAT-INV-001`)
- Integration: `RecipeProvider` boundary (see [ADR-20260523-02](../decisions/ADR-20260523-02-recipe-provider-adapter.md))
- Migrations needed: **N** unless caching tables are introduced

## Acceptance criteria

- [x] Suggestions include per-ingredient **required** vs **in stock** quantities (same unit).
- [x] `canCook` reflects sufficient stock for all required ingredients at default servings.
- [x] Recipe card enables **Cook and deduct** only when `canCook` is true (plus client loading guard).
- [x] **Ready** badge aligned with `canCook`, not name-only presence.
- [x] Suggestions endpoint returns normalized recipe DTOs from configured provider.
- [x] No vendor-specific types leak outside provider implementation.
- [x] Documented configuration keys for provider selection and API keys (secrets not in repo) — **or V1 waiver:** hardcoded `StaticRecipeProvider` per [ADR-20260523-02](../decisions/ADR-20260523-02-recipe-provider-adapter.md) § Configuration (V1).
- [x] **Integration tests (DI-007):** `GET /api/recipes/suggestions` and `GET /api/recipes/{id}` in `backend/TrueSight.Api.Tests/` before BUILD-REC-001 re-build.

## Test plan (BUILD-REC-001)

Required integration tests:

1. **Suggestions:** seed inventory → GET suggestions → assert `ingredients[]` with required/in-stock, `canCook`, no vendor types in JSON.
2. **Detail:** GET known Static recipe id → 200 with ingredients; unknown id → 404.
3. **canCook gate:** insufficient quantity → `canCook: false` for that recipe.
4. **Isolation:** user A inventory does not affect user B suggestions.

## Traceability (AWP)

After approval, add/update rows in:

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- `.awp-workspace/1-design/DESIGN_STATES.yaml` — `decision_links`: `docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md`
- `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml`
- `.awp-workspace/2-build/WORK_QUEUE.yaml`

`spec_link` for build tasks → this file path.

## Advisor tracks

At build admission (see [advisor-policy.md](../advisor-policy.md)):

- Provider integration + suggestions endpoint → `security` (API keys server-side) and/or split `api_contract` for DTO contract

## Decisions

- [ADR-20260523-02](../decisions/ADR-20260523-02-recipe-provider-adapter.md) — recipe provider adapter.
