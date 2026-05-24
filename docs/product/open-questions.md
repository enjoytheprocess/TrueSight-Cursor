# Open questions register

Track **unresolved product and technical decisions** before they become ADRs, roadmap changes, or code.

**Not the same as:**

| Register | What it holds |
|----------|----------------|
| [ideation.md](ideation.md) | **Future features** (serving size, receipt scan, store recs…) — promote to roadmap when committed |
| [DESIGN_INPUTS.yaml](../../.awp-workspace/4-sync/DESIGN_INPUTS.yaml) | Gaps/deviations **from Verify/Sync**, not brainstorming |
| `TASK_READINESS` `blocking_unknowns` | Per-task gate — only what blocks **that** build task |

Close a row here when you decide — then update [project-brief.md](project-brief.md), an ADR, or the relevant `FEAT-*.md` spec.

**How to use**

1. Add a row with the next `OQ-###` id.
2. Set `Status` to `open` | `decided` | `deferred`.
3. When `decided`, link the ADR or doc and move the row to [Resolved](#resolved) or delete the open row.

---

## Backend

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-001 | **Auth mechanism for V1** — how do users sign up / sign in? | ASP.NET Identity + cookies; JWT + SPA; external (Google/Apple); hackathon-only dev auth | `FEAT-INV-001`, all per-user APIs | open |
| OQ-002 | **Recipe provider for hackathon** — which vendor first? | Spoonacular; Edamam; in-memory stub for demo | `FEAT-REC-001` | open |
| OQ-003 | **Hosting / deploy** for API + DB | Azure App Service; Railway; Docker on VPS; local-only demo | Demo, CI | open |
| OQ-004 | **Production database** after SQLite MVP | Stay on SQLite; PostgreSQL; SQL Server | Scale, hosting | deferred |
| OQ-005 | **V2 fridge image storage** | API-hosted files; S3-compatible blob; cloud vendor TBD | `FEAT-REC-002` | deferred |
| OQ-006 | **V2 vision provider** | OpenAI Vision; Gemini; other | `FEAT-REC-002` | deferred |
| OQ-007 | **Backend test stack** — xUnit vs NUnit, integration test DB | Document in `backend/README` when chosen | Build admission | open |

---

## Frontend

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-010 | **App toolchain** — how is the client built? | Vite + React SPA; Next.js; Expo (RN + web) | Scaffolding, CI | open |
| OQ-011 | **RN migration strategy** | Web now + shared hooks/types later; Expo from day one; web-only, no RN path | Mentor expectations, timeline | open |
| OQ-012 | **Styling approach** | Tailwind; CSS modules; plain CSS; NativeWind (if Expo) | UI velocity, RN reuse | open |
| OQ-013 | **Component / UI library** | Headless only; minimal custom; full kit (harder RN port) | Consistency vs migration | open |
| OQ-014 | **Client data fetching** | fetch; axios; TanStack Query (works on web + RN) | Caching, loading UX | open |
| OQ-015 | **Client state** | React Context; Zustand; other | Cross-screen inventory/recipes | open |
| OQ-016 | **Frontend repo layout** | `frontend/` at repo root; `apps/web` monorepo | Tooling | open |
| OQ-017 | **PWA depth for hackathon** | Responsive web only; manifest + install; service worker / offline ([IDEA-009](ideation.md#idea-009-pwa-install--offline-shell)) | Demo polish | open |
| OQ-018 | **Frontend hosting** | Static (Netlify/Vercel/GitHub Pages); same host as API | CORS, env URLs | open |

---

## Cross-cutting

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-020 | **CORS and API base URL** per environment | Dev proxy; explicit origins; env files | Local dev, deploy | open |
| OQ-021 | **OpenAPI / contract-first** — generate TS types from API? | Yes (openapi-typescript); hand-written DTOs | Frontend–backend sync | open |

---

## V1 feature design (from specs — not stack)

These are **build-time design choices** documented as TBD in `docs/design/features/`. Often decided when admitting the build task, not before picking React vs Vite.

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-030 | **Ingredient catalog vs free-text name** on add | Require `IngredientCatalog` row; allow inline name until catalog seeded | `FEAT-INV-001` | open |
| OQ-031 | **Inventory delete semantics** | Hard delete; soft delete + audit | `FEAT-INV-001` | open |
| OQ-032 | **Recipe suggestions API shape** | Client sends inventory snapshot vs server reads DB | `FEAT-REC-001` | open |
| OQ-033 | **Ingredient ↔ provider ID mapping** | Fuzzy match; manual mapping table; provider search only | `FEAT-REC-001` | open |
| OQ-034 | **Suggestion response “match” fields** | Missing count; used/missing ingredient lists; score only | `FEAT-REC-001` | open |
| OQ-035 | **Recipe provider failure UX** | Empty list + error; partial results; cached fallback | `FEAT-REC-001` | open |
| OQ-036 | **Recipe ranking weights** | Heuristic in spec (expiry, match, time); exact weights TBD at build | `FEAT-REC-001` | open |
| OQ-037 | **Optional recipe ingredients on accept** | Skip if missing; deduct only if present | `FEAT-SES-001` | open |
| OQ-038 | **Accept-recipe idempotency** | Idempotency key; reject duplicate session | `FEAT-SES-001` | open |
| OQ-039 | **RecipeSession request body** | Recipe id + serving multiplier + overrides shape | `FEAT-SES-001` | open |
| OQ-040 | **“Expiring soon” UI threshold** | Days before expiry for highlight; ties to [IDEA-006](ideation.md#idea-006-expiry-proximity-warnings) | UI, optional V1 | open |

---

## Planning & ops (not product stack)

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-050 | **Capability target windows** | Dates for CAP-V1-CORE / CAP-V2-VISION | `.awp-workspace/1-design/ROADMAP.yaml` | open |
| OQ-051 | **Backend operational contract** | SLO, health metric, rollback — placeholders in `backend/README.md` | Production | deferred |
| OQ-052 | **Local verification commands** | `dotnet test`, lint, run — fill `backend/README` before build admission | `backend/AGENTS.md` | open |

---

## Committed (for reference — not open)

These are **decided in docs**; do not re-litigate here unless changing an ADR.

| Area | Decision | Doc |
|------|----------|-----|
| Backend language & API | C# / ASP.NET Core (.NET 9), vertical slices + CQRS | [project-brief](project-brief.md), [architecture overview](../architecture/overview.md) |
| Backend persistence (MVP) | EF Core + SQLite | Same |
| Client delivery (MVP) | Mobile-first **responsive web**, not native store app | [ADR-20260523-01](../design/decisions/ADR-20260523-01-delivery-model-pwa-web.md) |
| Client UI (language) | React + TypeScript | [project-brief](project-brief.md) |
| Recipe / vision integration | Adapter boundaries, vendor swappable | [ADR-02](../design/decisions/ADR-20260523-02-recipe-provider-adapter.md), [ADR-03](../design/decisions/ADR-20260523-03-v2-vision-boundary.md) |
| Parked alternate stack | Firebase / React Native first | [IDEA-010](ideation.md#idea-010-firebase-first-stack-alternative) |
| Specialist advisors (AWP) | `security` + `api_contract` active; `experiment` / `incident` off for MVP | [advisor-policy.md](../design/advisor-policy.md) |

---

## Resolved

| ID | Decision | Resolved in | Date |
|----|----------|-------------|------|
| — | *(move rows here when decided)* | ADR link or doc path | YYYY-MM-DD |
