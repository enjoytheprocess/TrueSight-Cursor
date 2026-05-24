# Security Analysis Records

Agent-maintained record of security analyses conducted during Build/Verify.
One entry per task that uses `advisor_track: security`.

Add entries using `3-verify/templates/SECURITY_ANALYSIS_TEMPLATE.md`.
Set `advisor_status: complete` in the task’s `WORK_QUEUE` row (admission snapshot) once the analysis is complete.
If a concern cannot be resolved, record it in `3-verify/GAPS_AND_DEVIATIONS.yaml` instead.

Project policy: [docs/design/advisor-policy.md](../../docs/design/advisor-policy.md)

## Entries

### [SEC-BASELINE] — Pre-admission security audit (2026-05-24)

- **Task ID:** BUILD-SEC-001 (admission baseline)
- **Date:** 2026-05-24
- **Child tasks:** BUILD-SEC-001, BUILD-SEC-002, BUILD-SEC-003, BUILD-SEC-004, BUILD-AUTH-002

#### Change summary
Full-stack security audit before production hardening work. Identified gaps in auth (TMP-001), CORS, transport, rate limiting, CI, and process (empty SECURITY_REVIEWS).

#### Risk surface
- **Auth / authz:** Header identity spoofable (SEC-01, SEC-04); per-user DB isolation is sound.
- **Sensitive data:** SQLite unencrypted at rest; no secrets in repo.
- **Input validation:** FluentValidation on writes; header length not enforced at edge.
- **Network:** AllowAnyOrigin CORS; no HTTPS/HSTS in pipeline.
- **Abuse:** No rate limiting.

#### Mitigations applied (planned via WORK_QUEUE)
- BUILD-SEC-001: hygiene + sustained QRs
- BUILD-SEC-002: CI audits
- BUILD-SEC-003: API edge hardening
- BUILD-AUTH-002: real auth closes TMP-001

#### Residual risks
- TMP-001 remains until BUILD-AUTH-002 accepted.
- SQLite encryption deferred.

#### Analysis decision
- **Status:** complete
- **Notes:** Admission analysis; per-task SEC entries added during BUILD-SEC-003 and BUILD-SEC-004.

### [SEC-001] — Security hygiene and sustained QRs

- **Task ID:** BUILD-SEC-001
- **Date:** 2026-05-24

#### Change summary
Repo hygiene: `.gitignore` for env files, sustained QR-SEC-001–003 registered, production config keys documented in `backend/README.md`.

#### Mitigations applied
- Prevents accidental commit of `.env` secrets
- Sustained QRs gate future Production deploy and CI merges
- Operators have explicit Production env var table

#### Residual risks
- Controls documented but not enforced until BUILD-SEC-002 (CI) and BUILD-SEC-003 (API)

#### Analysis decision
- **Status:** complete

### [SEC-003] — API production edge hardening

- **Task ID:** BUILD-SEC-003
- **Date:** 2026-05-24

#### Change summary
Production CORS allowlist, mutation rate limiting, security headers, HTTPS/HSTS, Production identity gate (401 without header, 400 if >120 chars, no demo-user fallback).

#### Mitigations applied
- SEC-02 CORS, SEC-03/06 transport, SEC-06 rate limit, SEC-07 headers, SEC-09 header validation, SEC-04 partial (identity gate; real auth deferred)

#### Residual risks
- TMP-001 spoofable if attacker sends arbitrary X-TrueSight-User in Production until BUILD-AUTH-002
- SQLite at rest unencrypted

#### Analysis decision
- **Status:** complete

### [SEC-RETRO-INV] — BUILD-INV-001 manual inventory API (retroactive)

- **Task ID:** BUILD-INV-001
- **Date:** 2026-05-24 (retroactive BUILD-SEC-004)

#### Risk surface
- Per-user isolation via `UserId`; cross-user access returns 404 (tested).
- Interim header identity spoofable until BUILD-AUTH-002.
- Input validation on create/update (name length, unit whitelist).

#### Mitigations applied
- Handler-level `UserId` filtering; FluentValidation; integration tests for isolation.

#### Residual risks
- TMP-001 header spoofing in non-Production environments without cookie auth.

#### Analysis decision
- **Status:** complete

### [SEC-RETRO-REC] — BUILD-REC-001 recipe suggestions API (retroactive)

- **Task ID:** BUILD-REC-001
- **Date:** 2026-05-24 (retroactive BUILD-SEC-004)

#### Risk surface
- Read-only recipe catalog via `StaticRecipeProvider` (no external API keys in V1).
- Suggestions scoped to caller inventory; recipe detail does not leak other users' stock.

#### Mitigations applied
- No secrets in repo; provider errors must not expose keys (N/A for static provider).

#### Residual risks
- Future external providers must keep keys server-side only.

#### Analysis decision
- **Status:** complete

### [SEC-RETRO-SES] — BUILD-SES-001 recipe acceptance / deduction (retroactive)

- **Task ID:** BUILD-SES-001
- **Date:** 2026-05-24 (retroactive BUILD-SEC-004)

#### Risk surface
- Accept recipe mutates inventory and creates session rows; must be atomic per user.
- Insufficient stock returns 400 without partial deduction.

#### Mitigations applied
- Transactional handler; user-scoped inventory reads; tests for failure paths.

#### Residual risks
- Concurrent accepts for same inventory not serialized (low risk for MVP).

#### Analysis decision
- **Status:** complete

### [SEC-RETRO-SHP] — BUILD-SHP-001 shopping list API (retroactive)

- **Task ID:** BUILD-SHP-001
- **Date:** 2026-05-24 (retroactive BUILD-SEC-004)

#### Risk surface
- CRUD + move-to-inventory; same isolation model as inventory.
- Schema bootstrap via `TrueSightDbInitializer` for legacy DB files.

#### Mitigations applied
- User-scoped queries; validation on create; cross-user tests mirror inventory.

#### Residual risks
- TMP-001 until BUILD-AUTH-002; SQLite DDL bootstrap is operational not migration-grade.

#### Analysis decision
- **Status:** complete

### [SEC-AUTH-002] — Real authentication (BUILD-AUTH-002)

- **Task ID:** BUILD-AUTH-002
- **Date:** 2026-05-24

#### Change summary
ASP.NET Identity cookie sessions; `/api/auth/register|login|logout|me`; `ClaimsCurrentUser`; Production requires authenticated API access; dev header/demo fallback via config.

#### Mitigations applied
- SEC-01/SEC-04 addressed for Production; TMP-001 closed
- API cookies return 401 instead of redirect

#### Residual risks
- App.tsx does not show login on cold start (product choice); production web must sign in via API/cookie before calls
- Cross-origin prod needs CORS credentials + HTTPS

#### Analysis decision
- **Status:** complete

---

<!-- Copy the template from 3-verify/templates/SECURITY_ANALYSIS_TEMPLATE.md for each new entry. -->
