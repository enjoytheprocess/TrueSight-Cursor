# FEAT-INV-003: Inventory search and filter

**Status:** draft  
**Module:** Inventory  
**Related AWP feature_id:** `FEAT-INV-003`  
**Promoted from:** IDEA-014 · **Design priority:** P1

## Summary

Client-side search by ingredient name and quick filter for expiring-soon rows on **In Stock** (and optionally Shopping List).

## User story

As a user with a long inventory list, I want to search and filter, so I can find items quickly at home or in the store.

## Scope

### In scope

- Text search (case-insensitive) on display name / normalized name.
- Toggle or chip: **Expiring soon** only.
- Works with existing list from `GET /api/inventory`.

### Out of scope

- Server-side full-text search.
- Barcode scan.

## Behavior

- Filter applies to rendered list; no API change required for V1 slice.
- Preserve add/edit flows while filter active.

## Acceptance criteria

- [ ] Search narrows visible rows without mutating server data.
- [ ] Expiring-soon filter matches 3-day rule (OQ-040).
- [ ] Clear search resets list.

## Traceability (AWP)

- `design_priority`: P1 · `linked_idea`: IDEA-014
