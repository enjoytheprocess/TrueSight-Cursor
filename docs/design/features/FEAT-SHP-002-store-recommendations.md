# FEAT-SHP-002: Store recommendations

**Status:** draft  
**Module:** Shopping  
**Related AWP feature_id:** `FEAT-SHP-002`  
**Promoted from:** IDEA-005 · **Design priority:** P4

## Summary

Suggest nearby stores or channels to buy **missing** ingredients from shopping list or recipe pager.

## User story

As a user with items on my shopping list, I want store suggestions, so I know where to buy missing ingredients efficiently.

## Scope

### In scope

- Design spike: data provider (maps, grocery API), privacy, and cost.
- UI placeholder: “Find nearby” on shopping list when items exist.

### Out of scope (until spike approved)

- Live price comparison.
- Affiliate checkout.

## Dependencies

- CAP-V1-SHOP (FEAT-SHP-001).
- Location permission (web geolocation).

## Acceptance criteria

- [ ] Spike doc or ADR for provider choice.
- [ ] No PII sent without documented consent.

## Traceability (AWP)

- `design_priority`: P4 · `linked_idea`: IDEA-005
