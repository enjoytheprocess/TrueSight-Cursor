# ADR-20260524-02: Real authentication — ASP.NET Identity cookie sessions

**Date:** 2026-05-24  
**Status:** Accepted  
**Classification:** High-Level Design

## Context

- [ADR-20260524-01](ADR-20260524-01-v1-interim-identity-header.md) provided interim `X-TrueSight-User` identity (TMP-001).
- BUILD-SEC-003 enforces Production API edge controls but header identity remains spoofable until real auth ships.
- Mobile-first PWA ([ADR-20260523-01](ADR-20260523-01-delivery-model-pwa-web.md)) favors same-site cookie sessions over bearer tokens in `localStorage`.

## Decision

1. **Mechanism:** ASP.NET Core Identity with **HTTP-only, SameSite=Lax** authentication cookies.
2. **API surface:** `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me`.
3. **`ICurrentUser`:** Resolve `UserId` from `ClaimTypes.NameIdentifier` when authenticated.
4. **Development / Testing:** `Auth:AllowHeaderIdentity` and `Auth:AllowDemoUser` may be enabled (default true in Development and Testing) so existing header-based tests and demo flows continue without cookies.
5. **Production:** Fallback authorization requires authenticated user for `/api/*` except `/api/health` and `/api/auth/*`. `X-TrueSight-User` is not trusted.
6. **Frontend:** API client uses `credentials: 'include'`; `DemoLoginScreen` form enabled for register/login (no cold-start gate required in `App.tsx`).

## Consequences

### Positive

- Closes TMP-001 and SEC-01/SEC-04 for Production.
- Cookies avoid storing tokens in `localStorage`.

### Negative

- Cross-origin deployments require explicit CORS credentials + allowed origins (already configured in BUILD-SEC-003).
- Existing SQLite files lack Identity tables until `EnsureCreated` on fresh DB or manual reset.

## Supersedes (Production only)

- ADR-20260524-01 header identity for **Production** clients; header remains a **Development/Testing** convenience when config allows.

## References

- [FEAT-AUTH-002](../features/FEAT-AUTH-002-real-authentication.md)
- BUILD-AUTH-002
