# ADR-20260524-01: V1 interim identity — login off, header user id

**Date:** 2026-05-24  
**Status:** Accepted  
**Classification:** High-Level Design

## Context

- [Project brief](../../product/project-brief.md) listed user sign-up/login in V1 scope (OQ-001).
- The API isolates data per user via `ICurrentUser` and `X-TrueSight-User` (`HeaderCurrentUser`); the web client currently sends a fixed `demo-user`.
- Full sign-up/login (ASP.NET Identity, JWT, etc.) is not required to validate the inventory → recipes → deduct loop for the current milestone.
- Product decision (Design 2026-05-24): **login is off for now**; real auth ships in a later task.

## Decision

1. **Login/sign-up:** **Off** for V1 core loop. Tracked as temporary measure **TMP-001** in `.awp-workspace/workspace-build/2-build/TEMP_MEASURES.yaml`.
2. **Interim identity:** `X-TrueSight-User` request header (non-empty string, max 120 chars). Client should generate/store a stable id (e.g. UUID in `localStorage`) and send it on every API call.
3. **Server default:** Missing/blank header → `"demo-user"` for local convenience only; production clients must send an explicit user id.
4. **Isolation:** All inventory and session data filtered by `UserId`; cross-user access by id returns 404.
5. **Follow-on:** Replace header identity with real auth in a dedicated future build task (removes TMP-001).

## Consequences

### Positive

- Unblocks V1 feature re-build without auth sprint.
- `ICurrentUser` abstraction preserves a swap path to claims-based auth.

### Negative

- Header identity is not secure (trivial impersonation) — acceptable only while login is explicitly off.
- Brief and specs must state login is deferred, not dropped.

## AWP follow-up

- Resolves DESIGN_INPUT **DI-002**.
- Link from `SETUP-001`, `FEAT-INV-001`, `FEAT-REC-001`, `FEAT-SES-001` via `decision_links`.
- Close OQ-001 (interim header; full auth deferred) in [open-questions.md](../../product/open-questions.md).

## References

- [Project brief — Scope](../../product/project-brief.md)
- `backend/TrueSight.Api/Infrastructure/HeaderCurrentUser.cs`
- `.awp-workspace/workspace-build/2-build/TEMP_MEASURES.yaml` — TMP-001
