# ADR-20260523-01: Delivery model — mobile-first web and PWA

**Date:** 2026-05-23  
**Status:** Accepted  
**Classification:** High-Level Design

## Context

- Target users are anyone with a fridge; the product must work on phones and desktops without forcing an app store install for MVP.
- Perishable inventory benefits from quick access on the device people already carry.
- A future native app is possible but increases cost and distribution friction before product validation.

**Alternatives considered**

- Native iOS/Android apps first.
- **Firebase + Next.js** full stack (see [ideation IDEA-010](../../product/ideation.md#idea-010-firebase-first-stack-alternative), parked) — not chosen as the committed stack; product uses ASP.NET Core + React.

## Decision

Ship **MVP as a mobile-first responsive web application** with **PWA-style** capabilities (install prompt where supported, app-like shell). **Do not** require a native app for core flows. Desktop remains a first-class target with the same codebase.

## Consequences

### Positive

- Single codebase for phone and desktop; shareable URL; faster iteration.
- Camera access via standard web APIs with user consent.
- Lower launch cost than dual native stores.

### Negative

- PWA capabilities vary by browser; offline and push require explicit scope (see IDEA-009).
- Some device features remain easier in native apps if needed later.

## AWP follow-up

- Link from `DESIGN_STATES` / feature specs as needed via `decision_links`.
- No change to primary component (`backend`) until frontend paths are added to traceability.

## References

- [Project brief — Delivery model](../../product/project-brief.md)
- [Architecture overview](../../architecture/overview.md)
