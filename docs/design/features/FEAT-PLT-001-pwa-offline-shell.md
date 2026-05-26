# FEAT-PLT-001: PWA install and offline shell

**Status:** draft  
**Module:** Platform  
**Related AWP feature_id:** `FEAT-PLT-001`  
**Promoted from:** IDEA-009 · **Design priority:** P2

## Summary

Web app manifest, installability, and a minimal service worker for shell caching and optional read-only offline inventory — per [ADR-20260523-01](../decisions/ADR-20260523-01-delivery-model-pwa-web.md).

## User story

As a user on my phone, I want to install the app and check my list with poor connectivity, so I can use it at the store.

## Scope

### In scope

- `manifest.webmanifest` (name, icons, theme, `display: standalone`).
- Service worker: cache app shell + `GET /api/inventory` last response (read-only offline).
- Install prompt UX (where browser supports).

### Out of scope

- Offline recipe accept / deduct.
- Native app store builds.
- Push (separate slice after PLT-001; supports FEAT-INV-002 push variant).

## Acceptance criteria

- [ ] Lighthouse PWA installable criteria met on production build.
- [ ] Installed app opens to demo/login → inventory.
- [ ] Last fetched inventory visible offline with clear “offline” indicator.

## Traceability (AWP)

- `design_priority`: P2 · `linked_idea`: IDEA-009
