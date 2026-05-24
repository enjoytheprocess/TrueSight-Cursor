# Specialist advisor policy (TrueSight)

AWP **advisor tracks** for this project. Authoritative workflow rules: [`.awp-workspace/docs/optional/specialist-tracks.md`](../../.awp-workspace/docs/optional/specialist-tracks.md).

## Active tracks

| Track | Status | Review file |
|-------|--------|-------------|
| **`security`** | **Active** | [`.awp-workspace/3-verify/SECURITY_REVIEWS.md`](../../.awp-workspace/3-verify/SECURITY_REVIEWS.md) |
| **`api_contract`** | **Active** | [`.awp-workspace/3-verify/API_CONTRACT_REVIEWS.md`](../../.awp-workspace/3-verify/API_CONTRACT_REVIEWS.md) |
| `experiment` | Not used (hackathon MVP) | — |
| `incident` | Not used until production | — |
| `data_migration` | Use when EF schema changes need rollback notes | `DATA_MIGRATION_REVIEWS.md` (create on first migration task) |

## One track per task

AWP default: **one** `advisor_track` per `WORK_QUEUE` task. If both security and contract matter:

1. Prefer **split tasks** (e.g. “Implement inventory API” = `security`; “Document inventory OpenAPI” = `api_contract`), or  
2. Pick the **primary** risk for the task and cover the other concern in the review entry’s notes.

## When to set each track

### `security`

Set when the task touches:

- Authentication, sessions, or per-user authorization  
- Inventory or sessions data isolation  
- Recipe / vision **API keys** (server-side only)  
- CORS, HTTPS, cookies or JWT storage  
- File upload (V2 fridge photos) or image retention  
- Input validation on user-controlled fields  

### `api_contract`

Set when the task:

- Adds or changes **REST endpoints** the web client will call  
- Changes request/response DTOs, status codes, or error shapes  
- Promotes an endpoint from `internal` → `beta` or `beta` → `stable` in `backend/README.md`  

Mark new V1 endpoints **`beta`** until after the hackathon demo; breaking changes require a contract review entry.

## Feature → recommended tracks (at task admission)

Use when splitting work into `WORK_QUEUE` tasks. Adjust if scope is combined.

| Feature | Typical tasks | `advisor_track` |
|---------|---------------|-----------------|
| Identity / auth | Sign-up, login, token/cookie | `security` |
| `FEAT-INV-001` | Implement inventory CRUD | `security` |
| `FEAT-INV-001` | Publish/document inventory API contract | `api_contract` |
| `FEAT-REC-001` | Recipe suggestions endpoint + provider wiring | `security` (keys) **or** split: impl = `security`, contract doc = `api_contract` |
| `FEAT-SES-001` | Accept recipe / deduct inventory | `security` |
| `FEAT-SES-001` | Document session API contract | `api_contract` |
| `FEAT-REC-002` | Fridge upload + vision (V2) | `security` |
| Frontend UI-only | Layout, routing, no API change | `none` |
| `SETUP-001` | Workspace setup | `none` |

## Admission checklist

When admitting a task to build (`TASK_READINESS` → `WORK_QUEUE`):

1. Set `advisor_track` and `advisor_status: pending` (or `not_required` if `none`).  
2. Copy the same fields into `WORK_QUEUE` at admission (AWP snapshot).  
3. During build/verify, add an entry to the matching `3-verify/*_REVIEWS.md` file.  
4. Set `advisor_status: complete` on the **WORK_QUEUE** row when the entry is done.  

`make awp-docs-check` fails if a task uses `security` or `api_contract` but the backing review file is missing.

## Webapp-specific security focus

For the mobile-first **web** client + ASP.NET API, each `security` entry should at least address:

- Secrets not in the frontend bundle  
- Authenticated calls only for user-scoped routes  
- CORS aligned with deployed web origin(s)  
- Safe handling of provider errors (no key leakage in responses)  

## Human sign-off

Optional. Not required for hackathon unless a mentor must formally approve — see **Human specialist sign-off** in [specialist-tracks.md](../../.awp-workspace/docs/optional/specialist-tracks.md).

## Related

- [Open questions](../product/open-questions.md) — resolved: interim identity (OQ-001), V1 dev proxy (OQ-020); see **Resolved** section  
- [Architecture overview](../architecture/overview.md)  
- Feature specs under [features/](features/)
