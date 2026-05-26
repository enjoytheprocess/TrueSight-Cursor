# FEAT-REC-003: Default serving context

**Status:** draft  
**Module:** Recipes  
**Related AWP feature_id:** `FEAT-REC-003`  
**Promoted from:** IDEA-001 · **Design priority:** P1 · **Partial:** per-recipe servings stepper shipped in V1

## Summary

Remember a default “cooking for N people” across recipe cards and sessions, instead of resetting every card to recipe default servings.

## User story

As a user who usually cooks for my household size, I want my serving preference remembered, so I do not adjust every recipe manually.

## Scope

### In scope

- User-level default servings (1–12), stored in profile (FEAT-PRF-001) or localStorage for demo.
- New recipe cards open with `max(recipe.servings, default)` or user-chosen rule documented in build.
- Accept flow still uses card’s selected servings for multiplier.

### Out of scope

- Per-recipe remembered overrides.
- Nutrition scaling.

## Behavior

- Demo: `localStorage` key per `userId`.
- Production: `UserProfiles.defaultServings` when PRF-001 ships.

## Acceptance criteria

- [ ] Changing default updates new recipe cards opened after save.
- [ ] Accept still sends correct `servingMultiplier` to session API.

## Traceability (AWP)

- `design_priority`: P1 · `linked_idea`: IDEA-001
