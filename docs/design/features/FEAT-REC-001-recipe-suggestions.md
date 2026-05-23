# FEAT-REC-001: Recipe suggestions from inventory

**Status:** draft  
**Module:** Recipes  
**Related AWP feature_id:** `FEAT-REC-001`

## Summary

Given the user's current inventory, return recipe suggestions by calling a **RecipeProvider** adapter that normalizes external or internal recipe data into the product's recipe model. Ranking and “how well it matches” behavior are defined at implementation time within this feature.

## User story

As a user, I want to see recipes I can make with what I have now, so that I use food before it expires.

## Scope

### In scope

- Query endpoint(s) that consume current inventory and return a list of suggested recipes.
- Integration with **one** configured `RecipeProvider` implementation (Spoonacular, Edamam, or stub for dev).
- Basic match explanation in response (e.g. uses all / missing N ingredients — exact shape TBD).

### Out of scope

- Cuisine discovery mode, dietary filters, serving-size scaling UX ([IDEA-001](../../product/ideation.md#idea-001-serving-size-selector), [IDEA-002](../../product/ideation.md#idea-002-cuisine-preferences--discovery-mode), [IDEA-003](../../product/ideation.md#idea-003-dietary-restrictions--allergy-filtering)) — unless explicitly promoted later.
- Deducting inventory (see `FEAT-SES-001`).
- Persisting recipes locally (optional cache — separate task if needed).

## Behavior

- Read-only from inventory perspective — no mutations in this feature.
- Map catalog ingredient names/ids to provider ingredient ids as needed (fuzzy matching or manual mapping — TBD).
- Handle provider errors with degraded UX (empty list + error code vs partial results — decide at build).

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

Weights and tie-breakers are implementation details; document chosen weights in the API or ops notes when built.

## API / contracts

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/recipes/suggestions` | Query params or body: inventory snapshot vs server-read — **TBD** |
| GET | `/api/recipes/{id}` | Detail view if required by UI |

## Data model

- Read: `InventoryItem`, `IngredientCatalog`
- Integration: `RecipeProvider` boundary (see [ADR-20260523-02](../decisions/ADR-20260523-02-recipe-provider-adapter.md))
- Migrations needed: **N** unless caching tables are introduced

## Acceptance criteria

- [ ] Suggestions endpoint returns normalized recipe DTOs from configured provider.
- [ ] No vendor-specific types leak outside provider implementation.
- [ ] Documented configuration keys for provider selection and API keys (secrets not in repo).

## Traceability (AWP)

After approval, add/update rows in:

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- `.awp-workspace/1-design/DESIGN_STATES.yaml` — `decision_links`: `docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md`
- `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml`
- `.awp-workspace/2-build/WORK_QUEUE.yaml`

`spec_link` for build tasks → this file path.

## Decisions

- [ADR-20260523-02](../decisions/ADR-20260523-02-recipe-provider-adapter.md) — recipe provider adapter.
