# ADR-20260523-03: V2 vision service boundary

**Date:** 2026-05-23  
**Status:** Accepted  
**Classification:** High-Level Design

## Context

- Phase 2 adds fridge photos to reduce manual inventory entry.
- Vision vendors (e.g. OpenAI Vision, Gemini Vision) have different APIs, costs, and privacy postures.
- Incorrect detections must not corrupt inventory without user review.

## Decision

1. Expose image upload from the **web client** to **server-managed storage** (exact storage choice is an implementation detail).
2. The API invokes a **VisionService** interface that returns **candidate** items (`DetectedItem`), not final inventory.
3. The user **confirms, edits, or rejects** candidates before `InventoryItem` rows are created or updated.
4. Vendor SDKs and response types stay inside the infrastructure/adapter for the vision feature; core code consumes normalized DTOs only.

## Consequences

### Positive

- Vendor swap without rewriting inventory UX.
- Safer inventory: human-in-the-loop for V2.

### Negative

- Extra UI step latency vs fully automatic inventory.
- Ongoing cost and compliance review per vendor.

## AWP follow-up

- Reference in [FEAT-REC-002](../features/FEAT-REC-002-fridge-photo-recognition.md).
- Traceability paths for Recognition slice when code exists.

## References

- [User stories — Phase 2](../../product/user-stories.md)
- [Architecture overview](../../architecture/overview.md)
