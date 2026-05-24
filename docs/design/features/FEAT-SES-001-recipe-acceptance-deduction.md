# FEAT-SES-001: Recipe acceptance and inventory deduction

**Status:** ready  
**Module:** Sessions  
**Related AWP feature_id:** `FEAT-SES-001`

## Summary

When a user accepts a recipe, record a `RecipeSession` and **deduct** the ingredients used from `InventoryItem` stock according to the recipe’s required quantities and an optional serving multiplier (minimum: 1x or recipe default — full scaling UX is [IDEA-001](../../product/ideation.md#idea-001-serving-size-selector)).

## User story

As a user, when I choose to cook a suggested recipe, I want my inventory updated automatically so my fridge list stays accurate.

## Scope

### In scope

- Accept action: input recipe id, optional serving multiplier within allowed range.
- Atomic or transactional deduction: either all applicable deductions succeed or none (define per-item partial stock rules).
- Persist `RecipeSession` with timestamp and parameters for audit.

### Out of scope

- Reverting a session / “I didn’t cook this” undo flow (ideation unless requested).
- Nutritional tracking.
- Shopping for missing ingredients ([IDEA-005](../../product/ideation.md#idea-005-store-recommendations-distance-price)).

## Behavior

- Validate user has sufficient quantity for required (non-optional) ingredients; return validation errors if not.
- **UI alignment:** [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md) disables **Cook and deduct** when stock is insufficient (`canCook === false`); this endpoint must still enforce the same rules so API clients cannot bypass the gate.
- **Optional ingredients (OQ-037):** **Not deducted in V1.** Handler processes **required** (`optional: false`) lines only; optional lines on provider data are ignored for deduct (same rule as `canCook` in [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md)).
- **Idempotency (OQ-038):** **Deferred for V1.** Reported “double deduct” was recipe card UX (required qty per serving); see [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md). Client loading guard optional; no server idempotency key for V1.

**Deferred (not V1):** unit conversion ([OQ-041](../../product/open-questions.md)); partial adherence ([OQ-042](../../product/open-questions.md)).

## API / contracts

| Method | Path | Notes |
|--------|------|-------|
| POST | `/api/recipe-sessions` | Body (OQ-039): `{ "recipeId": string, "servingMultiplier"?: integer }` — multiplier optional, defaults to **1**, **integer only** (no decimals); no per-line overrides |
| GET | `/api/recipe-sessions` | Optional history for UI |

## Data model

- Entities: `RecipeSession`, `InventoryItem`, `Recipe` / `RecipeIngredient` (from provider or cache)
- Migrations needed: **Y**

## Acceptance criteria

- [x] Accepting a recipe reduces inventory for used ingredients.
- [x] Insufficient stock returns a clear, actionable error.
- [x] Session is persisted and linked to user.

## Traceability (AWP)

After approval, add/update rows in:

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- `.awp-workspace/1-design/DESIGN_STATES.yaml`
- `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml`
- `.awp-workspace/2-build/WORK_QUEUE.yaml`

`spec_link` for build tasks → this file path.

## Advisor tracks

At build admission (see [advisor-policy.md](../advisor-policy.md)):

- Accept / deduct implementation → `security`
- Document session API → `api_contract` (if separate task)

## Decisions

- Depends on manual inventory (`FEAT-INV-001`) and recipe identity from `FEAT-REC-001`.

## Implementation notes (MVP / SQLite)

**Bug (resolved):** `GET /api/recipe-sessions` returned 500 when listing sessions ordered by `AcceptedAt` (`DateTimeOffset`). EF Core 9 + SQLite does **not** translate `ORDER BY` on `DateTimeOffset` — this is a [known provider limitation](https://learn.microsoft.com/en-us/ef/core/providers/sqlite/limitations), not a version mismatch fixable by upgrading packages.

**Mitigation:** `ListRecipeSessions` loads the user's sessions from SQLite, then sorts by `AcceptedAt` in memory before mapping the response. Fine for V1 personal session history; revisit if session volume or server-side paging requires a sortable column (e.g. store `AcceptedAtUtcTicks` as `long`).

**AWP record:** `GD-001` in `.awp-workspace/3-verify/archive/GAPS_AND_DEVIATIONS.yaml` (`resolved_in_loop`).
