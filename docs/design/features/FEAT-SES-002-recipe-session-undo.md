# FEAT-SES-002: Recipe session undo / adjust

**Status:** draft  
**Module:** Sessions  
**Related AWP feature_id:** `FEAT-SES-002`  
**Promoted from:** IDEA-013 · **Design priority:** P2

## Summary

Allow users to **undo** the most recent cook-and-deduct (restore prior inventory quantities) or correct obvious mistakes within a short window.

## User story

As a user who accepted a recipe, I want to undo the deduction if I did not actually cook it, so my inventory stays trustworthy.

## Scope

### In scope

- Undo last completed `RecipeSession` for current user (single level).
- Restore inventory quantities from session audit data (or reversal transaction).
- UI: “Undo last cook” on confirmation toast or inventory screen.

### Out of scope

- Arbitrary history edit.
- Partial line corrections (see FEAT-SES-003).

## API / contracts

| Method | Path | Notes |
|--------|------|-------|
| POST | `/api/recipes/sessions/{id}/undo` | Idempotent if already undone; 409 if not latest |

## Data model

- `RecipeSession` status: `completed` | `undone`.
- Store pre-deduct snapshot or reversal lines.

## Acceptance criteria

- [ ] Undo restores quantities verified by integration test.
- [ ] Second undo rejected or only affects new latest session.
- [ ] UI reflects restored stock.

## Traceability (AWP)

- `design_priority`: P2 · `linked_idea`: IDEA-013 · Depends on FEAT-SES-001
