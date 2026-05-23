# FEAT-REC-002: Fridge photo recognition (V2)

**Status:** draft  
**Module:** Recognition  
**Related AWP feature_id:** `FEAT-REC-002`

## Summary

Let users upload a fridge photo from the web client. The server stores the image, calls a **VisionService** to propose `DetectedItem` candidates, and returns them for **user confirmation** before any `InventoryItem` rows are written or updated.

## User story

As a user, I want to photograph my fridge and review suggested items before they are saved, so I get speed without losing control over my inventory.

## Scope

### In scope

- Upload endpoint and storage for fridge images (implementation detail).
- Vision adapter returning normalized candidates (name, estimated quantity, confidence — exact DTO TBD).
- Confirmation endpoint: user accepts/edits/rejects candidates → creates/updates `InventoryItem`.
- Client flow documented: `getUserMedia` or file input with `capture="environment"` ([ADR-20260523-01](../decisions/ADR-20260523-01-delivery-model-pwa-web.md)).

### Out of scope

- Receipt scanning ([IDEA-008](../../product/ideation.md#idea-008-receipt-photo--inventory-list)) — may share infrastructure later.
- Fully automatic inventory without confirmation.
- Training custom vision models.

## Behavior

1. Client uploads image (multipart or signed URL — TBD).
2. API stores blob, invokes `VisionService`, returns `DetectedItem[]`.
3. User reviews in UI; client sends confirmation payload.
4. API materializes inventory changes transactionally.

**Confirmation UX (required):** Present each candidate with confidence (high / medium / low). User toggles lines on/off before save — e.g. accept eggs and milk, reject low-confidence lettuce. See [UI principles](../ui-principles.md).

Privacy: document retention and deletion policy for images (PII/location in EXIF — strip if needed).

## API / contracts

| Method | Path | Notes |
|--------|------|-------|
| POST | `/api/recognition/fridge-upload` | Upload image; returns job id or sync candidates — TBD |
| GET | `/api/recognition/jobs/{id}` | If async processing |
| POST | `/api/recognition/fridge-confirm` | Body: confirmed/edited line items → inventory writes |

## Data model

- Transient: `DetectedItem` (see [domain model](../../product/domain-model.md))
- Persistent: `InventoryItem`; optional `FridgeImage` / audit entity — TBD
- Migrations needed: **Y**

## Acceptance criteria

- [ ] No inventory mutation without explicit user confirmation step.
- [ ] Vision vendor types isolated behind `VisionService`.
- [ ] Documented flow matches [architecture overview](../../architecture/overview.md) V2 diagram.

## Traceability (AWP)

After approval, add/update rows in:

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- `.awp-workspace/1-design/DESIGN_STATES.yaml` — `decision_links`: `docs/design/decisions/ADR-20260523-03-v2-vision-boundary.md`, `docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md`
- `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml`
- `.awp-workspace/2-build/WORK_QUEUE.yaml` (when V2 is admitted)

`spec_link` for build tasks → this file path.

## Advisor tracks

At build admission (see [advisor-policy.md](../advisor-policy.md)):

- Upload, vision, confirmation → `security` (files, retention, keys)
- Recognition API contract → `api_contract` when endpoints are defined

## Decisions

- [ADR-20260523-03](../decisions/ADR-20260523-03-v2-vision-boundary.md) — vision boundary and human confirmation.
- [ADR-20260523-01](../decisions/ADR-20260523-01-delivery-model-pwa-web.md) — web camera capture.
