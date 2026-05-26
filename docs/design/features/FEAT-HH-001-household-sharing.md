# FEAT-HH-001: Household shared inventory

**Status:** draft  
**Module:** Identity / Inventory  
**Related AWP feature_id:** `FEAT-HH-001`  
**Promoted from:** IDEA-015 · **Design priority:** P4

## Summary

Lightweight **household** model so two or more registered users share one inventory and shopping list.

## User story

As a household member, I want my partner to see the same fridge and shopping list, so we do not double-buy or miss updates.

## Scope

### In scope

- Household entity; invite by code or email (TBD).
- Shared `UserId` scope → `HouseholdId` on inventory and shopping items.
- Auth required (no demo-only).

### Out of scope

- Per-member permissions matrix.
- Charity/org flows (FEAT-ORG-001).

## Dependencies

- FEAT-AUTH-002 auth UI wired in app (sign-up / sign-in).
- Migration from per-user to household-scoped rows.

## Acceptance criteria

- [ ] Two users in same household see identical inventory after either edits.
- [ ] Users not in household cannot read data.

## Traceability (AWP)

- `design_priority`: P4 · `linked_idea`: IDEA-015
