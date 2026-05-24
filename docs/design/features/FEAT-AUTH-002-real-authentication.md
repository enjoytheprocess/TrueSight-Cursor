# FEAT-AUTH-002: Real authentication

**Status:** approved  
**Module:** Profile / Identity  
**Related AWP feature_id:** `FEAT-AUTH-002`

## Summary

Replace interim header identity ([TMP-001](../../../.awp-workspace/2-build/TEMP_MEASURES.yaml), [ADR-20260524-01](../decisions/ADR-20260524-01-v1-interim-identity-header.md)) with real sign-up and sign-in. Closes the largest production security gap (audit SEC-01, SEC-04).

## User story

As a user, I want to create an account and sign in, so that my inventory and sessions are protected from impersonation.

## Scope

### In scope

- Sign-up and sign-in (email + password minimum)
- Server-issued authenticated session (mechanism chosen at build admission — cookie session or JWT)
- `ICurrentUser` backed by authenticated claims, not client-supplied header
- Retire `X-TrueSight-User` for production clients
- Enable login screen controls currently disabled in [FEAT-AUTH-001](FEAT-AUTH-001-demo-login-screen.md)
- Close TMP-001 on completion
- SECURITY_REVIEWS entry for BUILD-AUTH-002

### Out of scope

- OAuth / social login (follow-on)
- Password reset email flow (follow-on)
- MFA

## Blocking unknown (Design)

**Auth mechanism:** ASP.NET Identity with HTTP-only cookie vs JWT bearer — decide before build admit (recommend cookie for same-site PWA).

## Dependencies

- BUILD-SEC-003 (production edge baseline) should be **accepted** before auth build starts
- All user-scoped API handlers already filter by `ICurrentUser.UserId`

## Acceptance criteria

- [ ] Sign-up creates user; sign-in returns authenticated session
- [ ] Unauthenticated API mutations return 401
- [ ] Cross-user IDOR tests still pass with real auth tokens/sessions
- [ ] Demo mode: optional retained for local dev only via explicit config flag
- [ ] Frontend login form enabled; `enterDemoUser()` gated to dev/demo config
- [ ] ADR documents auth mechanism; ADR-20260524-01 marked superseded for production
- [ ] TMP-001 status → closed in TEMP_MEASURES

## Traceability (AWP)

- BUILD-AUTH-002 in WORK_QUEUE (phase: design until mechanism ADR)
