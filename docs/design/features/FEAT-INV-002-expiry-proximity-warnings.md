# FEAT-INV-002: Expiry proximity warnings

**Status:** draft  
**Module:** Inventory  
**Related AWP feature_id:** `FEAT-INV-002`  
**Promoted from:** IDEA-006 · **Design priority:** P1

## Summary

Proactive in-app warnings when inventory items are within the expiring-soon window (3 days per OQ-040), beyond row styling and tab counts already shipped.

## User story

As a user, I want a clear warning when food is about to spoil, so that I act before throwing it away.

## Scope

### In scope

- Banner or callout on **In Stock** when ≥1 item is expiring within 3 days.
- Link or CTA toward **Recipes** filtered or ranked toward those items.
- Copy that names count (“2 items expire soon”).

### Out of scope

- Push notifications (defer to FEAT-PLT-001 + follow-on slice).
- Email/SMS.
- Changing ranking weights (see FEAT-PRF-001 / FEAT-REC-001).

## Behavior

- Reuse `isExpiringSoon` logic aligned with recipe ranking (`expiryDate <= today + 3 days`).
- Banner dismissible per session (localStorage optional).
- Empty state: no banner when nothing expiring soon.

## API / contracts

Optional: `GET /api/inventory/summary` with `expiringSoonCount` — or compute client-side from existing list endpoint.

## Acceptance criteria

- [ ] Banner appears when demo inventory has items expiring within 3 days.
- [ ] Banner hidden when none expiring soon.
- [ ] Mobile and desktop layouts per [ui-principles.md](../ui-principles.md).

## Traceability (AWP)

- `design_priority`: P1 · `linked_idea`: IDEA-006
