# Open questions register

Track **unresolved product and technical decisions** before they become ADRs, roadmap changes, or code.

**Not the same as:**

| Register | What it holds |
|----------|----------------|
| [ideation.md](ideation.md) | **Future features** (serving size, receipt scan, store recs…) — promote to roadmap when committed |
| [DESIGN_INPUTS.yaml](../../.awp-workspace/workspace-build/4-sync/DESIGN_INPUTS.yaml) | Gaps/deviations **from Verify/Sync**, not brainstorming |
| `TASK_READINESS` `blocking_unknowns` | Per-task gate — only what blocks **that** build task |

Close a row here when you decide — then update [project-brief.md](project-brief.md), an ADR, or the relevant `FEAT-*.md` spec.

**Last reviewed:** 2026-05-24 — one-by-one triage. **Resolved this session:** OQ-004 (SQLite), OQ-040 (3-day expiry highlight). **Deferred:** V2 block (OQ-005–006), OQ-038/041/042, OQ-051. See [Resolved](#resolved) and deferred tables below.

**How to use**

1. Add a row with the next `OQ-###` id.
2. Set `Status` to `open` | `decided` | `deferred`.
3. When `decided`, link the ADR or doc and move the row to [Resolved](#resolved) or delete the open row.

---

## Backend

### V2 (phase 2) — all deferred

**Policy (2026-05-24):** Do not decide V2 questions until fridge-photo recognition is committed to delivery. Near-term V2 completion is unlikely; revisit OQ-005+ when promoting `FEAT-REC-002` / `CAP-V2-VISION`.

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-005 | **V2 fridge image storage** | API-hosted files; S3-compatible blob; cloud vendor TBD | `FEAT-REC-002` | deferred |
| OQ-006 | **V2 vision provider** | OpenAI Vision; Gemini; other | `FEAT-REC-002` | deferred |

---

## Frontend

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|

---

## Cross-cutting

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|

### Profile (V1.2 — FEAT-PRF-001)

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-058 | **Diet/allergen rule source** | Provider tags only vs server rules table for Static provider | `FEAT-PRF-001` | open |
| OQ-059 | **Cuisine / skill / equipment** | Hard filter vs score boost only | `FEAT-PRF-001` | open |
| OQ-060 | **`prioritizeExpiringItems` off** | Zero ranking term only vs also hide 3-day row highlight | `FEAT-PRF-001` | open |
| OQ-061 | **First GET `/api/profile`** | 404 vs auto-create empty profile | `FEAT-PRF-001` | open |
| OQ-062 | **Sort order with profile filters** | Keep missing↑ score↓ minutes↑ vs other | `FEAT-PRF-001` | open |

---

## V1 feature design (from specs — not stack)

These are **build-time design choices** documented as TBD in `docs/design/features/`. Often decided when admitting the build task, not before picking React vs Vite.

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-041 | **Recipe vs inventory unit conversion** | e.g. `50 g` cheese vs `1 wheel`; defer V1 | `FEAT-REC-001`, `FEAT-SES-001` | deferred |
| OQ-042 | **Partial recipe adherence on deduct** | User used less than recipe; defer V1 | `FEAT-SES-001` | deferred |
| OQ-038 | **Accept-recipe idempotency** | Idempotency key; reject duplicate session | `FEAT-SES-001` | deferred |

---

## Planning & ops (not product stack)

| ID | Question | Options / notes | Blocks | Status |
|----|----------|-----------------|--------|--------|
| OQ-051 | **Backend operational contract** | SLO, health metric, rollback — placeholders in `backend/README.md` | Production | deferred |

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
| OQ-001 | Login off for V1 core loop; interim `X-TrueSight-User`; auth follow-on task | [ADR-20260524-01](../design/decisions/ADR-20260524-01-v1-interim-identity-header.md), TMP-001 | 2026-05-24 |
| OQ-002 | V1 hardcoded Static provider; config when live vendor added | [ADR-20260523-02](../design/decisions/ADR-20260523-02-recipe-provider-adapter.md) | 2026-05-24 |
| OQ-032 | Server reads inventory for suggestions (not client snapshot) | [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md) | 2026-05-24 |
| OQ-030 | V1 inline names only; IngredientCatalog deferred (TMP-002) | [FEAT-INV-001](../design/features/FEAT-INV-001-manual-inventory.md), [domain-model](domain-model.md), TMP-002 | 2026-05-24 |
| OQ-031 | Hard delete for inventory items; catalog adoption does not change delete behavior | [FEAT-INV-001](../design/features/FEAT-INV-001-manual-inventory.md), [domain-model](domain-model.md) | 2026-05-24 |
| OQ-034 | `ingredients[]` with required/in-stock + `canCook`; recipe card UX | [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md), [ui-principles](../design/ui-principles.md) | 2026-05-24 |
| OQ-010 | Vite + React SPA | `frontend/package.json`, [project-brief](project-brief.md) | 2026-05-24 |
| OQ-011 | Web-first MVP; native RN not on V1 roadmap | [ADR-20260523-01](../design/decisions/ADR-20260523-01-delivery-model-pwa-web.md) | 2026-05-24 |
| OQ-014 | TanStack Query for server state | `frontend/package.json` | 2026-05-24 |
| OQ-016 | `frontend/` at repo root | repo layout | 2026-05-24 |
| OQ-037 | V1 has **no optional ingredients** — every recipe line is required for `canCook` and deduct | [FEAT-SES-001](../design/features/FEAT-SES-001-recipe-acceptance-deduction.md), [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md) | 2026-05-24 |
| OQ-039 | `{ recipeId, servingMultiplier? }` — multiplier optional, defaults to **1**, **integer only** (no decimals); no line overrides | [FEAT-SES-001](../design/features/FEAT-SES-001-recipe-acceptance-deduction.md) | 2026-05-24 |
| OQ-045 | Helper copy: **“Welcome to the Demo”** (above or near disabled login form) | [FEAT-AUTH-001](../design/features/FEAT-AUTH-001-demo-login-screen.md) | 2026-05-24 |
| OQ-046 | Full login mock: email/password + disabled sign-up/forgot links + disabled OAuth buttons (Google, Facebook, etc.); **Enter Demo** remains the only enabled action | [FEAT-AUTH-001](../design/features/FEAT-AUTH-001-demo-login-screen.md) | 2026-05-24 |
| OQ-033 | V1 Static provider: **normalized name match only** — same name strings as inventory; no provider IDs or fuzzy match | [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md) | 2026-05-24 |
| OQ-035 | Provider failure: **empty list + error message**; UI shows a **Refetch** button to retry | [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md) | 2026-05-24 |
| OQ-036 | **Keep current ranking** — score = `(owned×12) − (missing×18) + (expiringSoon×8) − min(minutes,60)/10`; sort by missing count ↑, score ↓, minutes ↑ | `ListRecipeSuggestions/Handler.cs`, [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md) | 2026-05-24 |
| OQ-053 | Catalog grows **organically** — add/upsert catalog entry when user adds an ingredient to inventory; no static seed file or external import for V1 | [FEAT-CAT-001](../design/features/FEAT-CAT-001-ingredient-catalog.md) | 2026-05-24 |
| OQ-054 | Inventory add uses **typeahead/AJAX search** against catalog as user types; pick existing entry (FK) or submit a new name (creates catalog row per OQ-053) | [FEAT-CAT-001](../design/features/FEAT-CAT-001-ingredient-catalog.md) | 2026-05-24 |
| OQ-055 | **No catalog delete/retire in V1** — append-only; admin/merge tooling deferred | [FEAT-CAT-001](../design/features/FEAT-CAT-001-ingredient-catalog.md) | 2026-05-24 |
| OQ-056 | **Optional expiry on Move to In Stock** — inline date when user initiates move; null if skipped | [FEAT-SHP-001](../design/features/FEAT-SHP-001-shopping-list-and-main-shell.md) | 2026-05-24 |
| OQ-057 | **Responsive main shell** — ≤840px stacked; >840px two columns (tab list \| recipe pager) for both tabs; **stay on Shopping List** after move-to-inventory confirm | [FEAT-SHP-001](../design/features/FEAT-SHP-001-shopping-list-and-main-shell.md) | 2026-05-26 |
| OQ-007 | **xUnit** + `WebApplicationFactory` + in-memory SQLite — light V1 stack; document in `backend/README`; note room to improve (file DB, NUnit, coverage gates) later | `TrueSight.Api.Tests/`, [backend/README.md](../../backend/README.md) | 2026-05-24 |
| OQ-052 | **Light V1 verify:** `make backend-build` + `dotnet test backend/MyApp.sln` + `make frontend-build` | [backend/README.md](../../backend/README.md), [backend/AGENTS.md](../../backend/AGENTS.md) | 2026-05-24 |
| OQ-012 | **Tailwind CSS** for V1 styling (migrate from plain `styles.css`) | `frontend/` | 2026-05-24 |
| OQ-013 | **Minimal custom components** + Lucide icons — no shadcn/full kit (RN-friendly path) | `frontend/` | 2026-05-24 |
| OQ-015 | **TanStack Query + local `useState` only** — no Zustand/Context for V1 | `frontend/` | 2026-05-24 |
| OQ-017 | **Responsive web only** for V1 demo — no manifest, install prompt, or service worker | [ADR-20260523-01](../design/decisions/ADR-20260523-01-delivery-model-pwa-web.md) | 2026-05-24 |
| OQ-018 | **Local dev only** for tomorrow’s demo — `npm run dev` + API on `:5158`; static/deploy hosting deferred | `frontend/README.md` | 2026-05-24 |
| OQ-020 | **Vite dev proxy only for V1 demo** — `/api` → `:5158`; prod CORS/env deferred | `frontend/vite.config.ts` | 2026-05-24 |
| OQ-021 | **Hand-written DTOs** for V1 demo — OpenAPI/codegen deferred post-demo | `frontend/src/features/*/types.ts` | 2026-05-24 |
| OQ-003 | **Local only** for demo — `dotnet run` + SQLite on dev machine; cloud deploy deferred | `backend/README.md` | 2026-05-24 |
| OQ-050 | **Keep `target_window: TBD`** for CAP-V1-CORE and CAP-V2-VISION — revisit after demo | `.awp-workspace/workspace-build/1-design/ROADMAP.yaml` | 2026-05-24 |
| OQ-004 | **Stay on SQLite** for MVP and first production scale — no PostgreSQL/SQL Server migration until usage or hosting forces it | [project-brief](project-brief.md), [architecture overview](../architecture/overview.md), `backend/README.md` | 2026-05-24 |
| OQ-040 | **“Expiring soon” threshold = 3 days** before expiry for inventory highlight | [ui-principles](../design/ui-principles.md), [IDEA-006](ideation.md#idea-006-expiry-proximity-warnings) | 2026-05-24 |
