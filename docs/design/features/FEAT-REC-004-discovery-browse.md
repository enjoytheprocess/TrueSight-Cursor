# FEAT-REC-004: Discovery browse beyond inventory

**Status:** draft  
**Module:** Recipes  
**Related AWP feature_id:** `FEAT-REC-004`  
**Promoted from:** IDEA-017 (remainder of archived IDEA-002) · **Design priority:** P3

## Summary

Browse and filter recipes **without** requiring all ingredients in stock — inspiration mode — while keeping “cook from stock” as the primary flow.

## User story

As a user, I want to explore recipes by cuisine or diet even when I am missing items, so I can plan what to buy or cook later.

## Scope

### In scope

- Separate **Discover** entry or tab with provider catalog browse.
- Filters from FEAT-PRF-001 (cuisine, diet) when available.
- Cards show missing vs owned; **Cook and deduct** still gated by `canCook`.

### Out of scope

- Replacing inventory-matched suggestions as default home experience.

## Dependencies

- FEAT-PRF-001 (filter metadata).
- FEAT-REC-001 provider adapter.

## Acceptance criteria

- [ ] Discover list returns recipes when inventory is empty.
- [ ] Accept remains disabled until stock sufficient.

## Traceability (AWP)

- `design_priority`: P3 · `linked_idea`: IDEA-017
