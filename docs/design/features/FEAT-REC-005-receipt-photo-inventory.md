# FEAT-REC-005: Receipt photo → inventory

**Status:** draft  
**Module:** Recognition  
**Related AWP feature_id:** `FEAT-REC-005`  
**Promoted from:** IDEA-008 · **Design priority:** P3

## Summary

Photograph a grocery receipt; vision/OCR proposes line items; user reviews and confirms into inventory (same trust pattern as fridge photo).

## User story

As a user returning from shopping, I want to add purchases quickly from a receipt photo, so my inventory is up to date without manual entry.

## Scope

### In scope

- Capture/upload receipt image.
- Server vision adapter (shared boundary with FEAT-REC-002 production).
- Review UI: edit name, qty, unit, expiry before save.

### Out of scope

- Price analytics (IDEA-005).
- Automatic expiry without user confirm.

## Dependencies

- FEAT-REC-002 production vision pipeline (OQ-005/006).

## Acceptance criteria

- [ ] Confirmed lines appear in inventory with merge rules (FEAT-INV-001).
- [ ] Failed vision shows retry + manual add fallback.

## Traceability (AWP)

- `design_priority`: P3 · `linked_idea`: IDEA-008
