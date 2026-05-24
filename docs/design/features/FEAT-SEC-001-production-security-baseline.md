# FEAT-SEC-001: Production security baseline

**Status:** approved  
**Module:** Platform / API / DevOps  
**Related AWP feature_id:** `FEAT-SEC-001`

## Summary

Harden TrueSight for production deployment based on the 2026-05-24 security audit. Covers repo hygiene, sustained quality requirements, CI automation, and API edge controls (CORS, transport, rate limiting, security headers, interim identity validation). **Real authentication** is a separate feature ([FEAT-AUTH-002](FEAT-AUTH-002-real-authentication.md)) that closes TMP-001.

## Audit reference

Findings SEC-01–SEC-19 from agent security audit 2026-05-24. Intentional MVP risk (TMP-001 header identity) remains until FEAT-AUTH-002 ships.

## User story

As an operator deploying TrueSight, I want baseline security controls and automated checks, so that the app is not exposed with default-dev settings on a public URL.

## Scope

### In scope

- Sustained quality requirements (QR-SEC-001–003) in `.awp-workspace/1-design/QUALITY_REQUIREMENTS.yaml`
- `.gitignore` coverage for local env files
- GitHub Actions CI: `dotnet test`, `npm test`, `npm audit`, `dotnet list package --vulnerable`
- Production-oriented API configuration:
  - CORS allowlist from configuration (Development keeps permissive policy)
  - `AllowedHosts` from configuration
  - ASP.NET rate limiter on `/api/*` mutation routes
  - Security response headers (API middleware)
  - `UseHttpsRedirection` + HSTS in non-Development environments
  - No `demo-user` fallback when `ASPNETCORE_ENVIRONMENT=Production`
  - Validate `X-TrueSight-User` max 120 chars at API edge (interim until auth)
- Retroactive SECURITY_REVIEWS entries for shipped V1 API tasks
- Document production env vars in `backend/README.md`

### Out of scope

- Real sign-up/login (FEAT-AUTH-002 / BUILD-AUTH-002)
- SQLite encryption or managed DB migration
- WAF / CDN / reverse-proxy Terraform
- V2 upload security (FEAT-REC-002 production slice)

## Build tasks

| Task ID | Title | Component |
|---------|-------|-----------|
| BUILD-SEC-001 | Security hygiene and sustained QRs | repo |
| BUILD-SEC-002 | CI security automation | repo |
| BUILD-SEC-003 | API production edge hardening | backend |
| BUILD-SEC-004 | Retroactive SECURITY_REVIEWS | verify |

## Configuration (BUILD-SEC-003)

| Key | Purpose | Production example |
|-----|---------|-------------------|
| `Cors:AllowedOrigins` | Web client origin(s) | `https://app.example.com` |
| `AllowedHosts` | Host header allowlist | `app.example.com;api.example.com` |
| `RateLimiting:PermitLimit` | Requests per window per IP | `100` |
| `RateLimiting:WindowSeconds` | Fixed window length | `60` |

Development: existing Vite proxy + permissive CORS unchanged.

## Acceptance criteria

### BUILD-SEC-001

- [ ] `.gitignore` includes `.env`, `.env.*`, `!.env.example`
- [ ] `QUALITY_REQUIREMENTS.yaml` lists QR-SEC-001 (no TMP-001 in Production), QR-SEC-002 (CORS allowlist), QR-SEC-003 (no high/critical vulns at merge)
- [ ] `backend/README.md` documents production security env keys

### BUILD-SEC-002

- [ ] `.github/workflows/ci.yml` runs on push/PR to main
- [ ] Workflow runs `dotnet test`, `npm test`, `npm audit --omit=dev`, `dotnet list package --vulnerable`
- [ ] Failed audit or tests block merge

### BUILD-SEC-003

- [ ] CORS allowlist applied in Production; Development allows local dev origins
- [ ] Rate limiting on POST/PUT/DELETE under `/api`
- [ ] Security headers on API responses (minimum: `X-Content-Type-Options`, `Referrer-Policy`)
- [ ] HTTPS redirection + HSTS when not Development
- [ ] Production rejects missing/blank `X-TrueSight-User` (401); no `demo-user` default
- [ ] Oversized user id (>120) rejected (400)
- [ ] Integration tests cover Production identity rejection
- [ ] SECURITY_REVIEWS entry SEC-003 for this task

### BUILD-SEC-004

- [ ] SECURITY_REVIEWS entries for BUILD-INV-001, BUILD-REC-001, BUILD-SES-001, BUILD-SHP-001 (retroactive)
- [ ] Residual risks documented (TMP-001 until BUILD-AUTH-002)

## Traceability (AWP)

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml` — FEAT-SEC-001
- `.awp-workspace/1-design/ROADMAP.yaml` — CAP-V1-SEC
- `.awp-workspace/2-build/WORK_QUEUE.yaml` — BUILD-SEC-*
