# FEAT-SES-003: Partial ingredient deduction

**Status:** draft  
**Module:** Sessions  
**Related AWP feature_id:** `FEAT-SES-003`  
**Promoted from:** IDEA-016 · **Design priority:** P3

## Summary

On cook-and-deduct, let the user deduct **less than** the recipe’s scaled amount per ingredient line (OQ-042).

## User story

As a user who used only part of an ingredient, I want to deduct the amount I actually used, so inventory stays accurate without full recipe adherence.

## Scope

### In scope

- Per-line editable deduct quantity before confirm (≤ in-stock, ≤ recipe required).
- Server validates and persists actual deducted amounts on `RecipeSession`.

### Out of scope

- Adding ingredients not in recipe.
- Unit conversion.

## Behavior

- Default all lines to full recipe amounts; user may lower any line.
- Pair with FEAT-SES-002 only after undo semantics are clear.

## Acceptance criteria

- [ ] Accept with reduced line deducts correct smaller quantities.
- [ ] Cannot deduct more than in-stock or required.

## Traceability (AWP)

- `design_priority`: P3 · `linked_idea`: IDEA-016
