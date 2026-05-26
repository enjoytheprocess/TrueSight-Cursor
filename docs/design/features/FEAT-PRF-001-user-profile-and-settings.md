# FEAT-PRF-001: User profile and settings

**Status:** draft (design only — 2026-05-26)  
**Priority:** P3 (V1.2 — after V1.1 shopping acceptance; before or parallel with catalog extension)  
**Module:** Profile | Recipes (integration)  
**Related AWP feature_id:** `FEAT-PRF-001`  
**Linked ideation:** [IDEA-002](../../product/ideation.md#idea-002-cuisine-preferences--discovery-mode), [IDEA-003](../../product/ideation.md#idea-003-dietary-restrictions--allergy-filtering), [IDEA-004](../../product/ideation.md#idea-004-cooking-skill-level--kitchen-equipment), [IDEA-012](../../product/ideation.md#idea-012-prioritize-consumption--use-first-items)  
**Capability:** `CAP-V1-PROFILE` (`planned` in ROADMAP.yaml)  
**Depends on (build):** `CAP-V1-CORE`; **recommended before production profile:** [FEAT-AUTH-002](FEAT-AUTH-002-real-authentication.md) (persisted identity). Demo mode may ship profile keyed by `X-TrueSight-User` first.

## Summary

Give users a **Settings** surface (not a third main tab) to configure **dietary restrictions and allergies**, **cuisine and cooking preferences**, **global “use up expiring food” behavior**, and **per-inventory-item “use first”** priority. Settings drive **recipe filtering and ranking** in [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md); they do not change inventory CRUD rules except an optional `useFirstPriority` field on `InventoryItem`.

## User stories

- As a user, I open **Settings** from the main app header so I can manage preferences without leaving the In Stock / Shopping List workflow.
- As a user with dietary needs, I set **restrictions and allergens** so recipe suggestions **exclude** unsafe recipes globally.
- As a user, I set **preferred cuisines**, **skill level**, and **available equipment** so suggestions better match how I cook *(soft signals — filter or rank per OQ-059)*.
- As a user, I turn on **prioritize expiring items** so recipes that use soon-to-expire stock rank higher *(extends existing automatic `expiringSoon` signal — OQ-060)*.
- As a user, I mark specific **In Stock** items as **use first** so recipes using those ingredients rank higher even when expiry is distant or missing.
- As a user, my settings **persist per account** and apply on every device after sign-in *(requires FEAT-AUTH-002 in production; demo user id sufficient for interim)*.

## Scope

### In scope

#### Settings UI (frontend)

| Area | Decision |
|------|----------|
| **Entry** | **Gear icon** (or avatar) in the **compact header** on the main shell ([FEAT-SHP-001](FEAT-SHP-001-shopping-list-and-main-shell.md)); does **not** add a third tab |
| **Navigation** | Full-screen or slide-over **Settings** route/modal; **Back** returns to previous tab (In Stock or Shopping List) |
| **Sections** | See [Settings sections](#settings-sections) below |
| **In Stock integration** | Per-row **“Use first”** control (star or tri-state) on inventory list rows; syncs via inventory PATCH |

**Reserve header affordance** when implementing [BUILD-SHP-004](FEAT-SHP-001-shopping-list-and-main-shell.md) responsive shell — icon may be disabled until profile API ships.

#### Settings sections

| Section | Controls | Effect |
|---------|----------|--------|
| **Diet & allergies** | Multi-select tags: e.g. vegetarian, vegan, gluten-free, dairy-free, nut-free; separate **allergen** chips (peanuts, shellfish, …); optional free-text **custom avoid** (max length TBD) | **Hard filter:** recipes with conflicting tags/allergens **hidden** from suggestions (OQ-058) |
| **Cuisine & cooking** | Preferred cuisines (multi-select); skill: beginner \| intermediate \| advanced; equipment (multi-select: oven, stovetop, air fryer, …) | **Soft signal:** boost or filter per OQ-059 |
| **Use-up preferences** | Toggle **Prioritize expiring items** (default **on** — matches today’s ranking behavior) | When off, set `expiringSoon` contribution in ranking to **0** (OQ-060) |
| **Account** *(stub until AUTH-002)* | Display current user label; link placeholder “Sign in” / “Manage account” disabled in demo | No OAuth in this feature |

**Out of this screen:** serving-size scaling ([IDEA-001](../../product/ideation.md#idea-001-serving-size-selector)), full **discovery mode** browsing ([IDEA-002](../../product/ideation.md#idea-002-cuisine-preferences--discovery-mode)), push **expiry notifications** ([IDEA-006](../../product/ideation.md#idea-006-expiry-proximity-warnings)).

#### Profile API (backend — Profile slice)

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/profile` | Returns current user’s profile; **404 → create default** on first read (lazy init) or always return defaults — decide at build (OQ-061) |
| PUT | `/api/profile` | Replace profile document (full document PUT for V1.2 simplicity) |

Authenticated as today: `X-TrueSight-User` (demo) or bearer token when AUTH-002 ships.

#### Inventory extension (backend — Inventory slice)

| Method | Path | Notes |
|--------|------|-------|
| PATCH | `/api/inventory/{id}` | Body may include `useFirstPriority`: `normal` \| `high` (default `normal`) |

Create inventory (`POST`) accepts optional `useFirstPriority`; defaults to `normal`.

#### Recipe integration (backend — Recipes slice)

`ListRecipeSuggestions` reads **profile + inventory priorities** for current user:

1. **Filter** (diet/allergens/custom avoid) — drop non-compliant recipes before scoring.
2. **Score** — extend [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md) formula (document weight changes here before code change):

**Proposed score** *(draft — finalize at build, update OQ-036 successor)*:

```
base = (owned×12) − (missing×18) + (expiringSoon×8) − min(minutes,60)/10
     + (useFirstMatch×10)   // recipe uses ≥1 inventory row with useFirstPriority=high
     + (cuisineMatch×6)     // when OQ-059 = boost
profileOffExpiring: expiringSoon term → 0 when prioritizeExpiringItems = false
```

Sort order unchanged unless OQ-062 changes it: missing count ↑, score ↓, minutes ↑.

**StaticRecipeProvider:** recipes gain optional metadata fields for filtering (`dietTags`, `allergens`, `cuisine`, `skillLevel`, `equipment[]`) — stub provider fills representative values for demo recipes.

### Out of scope

- Third main tab for settings.
- Recipe **discovery mode** (browse beyond inventory match) — remains IDEA-002 stretch.
- **Serving size** profile default — IDEA-001; pager may still scale per session locally.
- **Push/email** expiry warnings — IDEA-006.
- **Store recommendations** — IDEA-005.
- **Household / multi-profile** per account (single profile per user id for V1.2).
- Provider-side diet filters only (must apply server-side for consistency).

## Behavior

### Defaults (new user)

| Field | Default |
|-------|---------|
| `dietaryTags` | `[]` |
| `allergens` | `[]` |
| `customAvoid` | `null` |
| `cuisinePreferences` | `[]` |
| `skillLevel` | `intermediate` |
| `equipment` | `[]` |
| `prioritizeExpiringItems` | `true` |
| Inventory `useFirstPriority` | `normal` |

### Diet / allergy filtering (OQ-058)

- If user selects **vegan**, exclude recipes tagged containing meat, dairy, eggs, honey *(tag vocabulary maintained in provider metadata + server-side rules table for Static provider)*.
- **Allergens** are **strict exclude**: any recipe listing that allergen is hidden.
- **Custom avoid** (substring or token list) applied to recipe **name + ingredient names** (case-insensitive normalized match).

When filter removes all recipes, return `[]` with optional `filterActive: true` flag in response meta *(build-time choice)* — UI shows empty state: “No recipes match your diet settings — adjust Settings.”

### Use-first vs expiring-soon

| Mechanism | User action | Ranking |
|-----------|-------------|---------|
| **Expiring soon** | Automatic from `expiryDate` within 3 days ([OQ-040](../../product/open-questions.md)) | `expiringSoon` ingredient count in score |
| **Prioritize expiring** (profile toggle) | Settings | When **off**, disable expiring term |
| **Use first** (per item) | Star / “Use first” on In Stock row | `useFirstMatch` when recipe uses that inventory line |

User can star **spinach** bought for a specific meal even if expiry is a week out.

### Persistence

- Table `UserProfiles` (1:1 with user id string used by `ICurrentUser`).
- `InventoryItem.useFirstPriority` column (string enum stored as text).

### Dependencies

| Dependency | Reason |
|------------|--------|
| `CAP-V1-CORE` | Inventory + suggestions must exist |
| `FEAT-REC-001` | Ranking hook |
| `FEAT-INV-001` | PATCH inventory |
| `FEAT-AUTH-002` *(production)* | Real accounts; optional for demo profile by header user id |
| `FEAT-SHP-001` shell | Header placement for Settings entry |

**Suggested build slices** *(not admitted — for future WORK_QUEUE)*:

1. `BUILD-PRF-001` — schema + GET/PUT profile API + defaults  
2. `BUILD-PRF-002` — inventory `useFirstPriority` + PATCH  
3. `BUILD-PRF-003` — recipe filter + extended ranking + StaticRecipeProvider metadata  
4. `BUILD-PRF-004` — Settings UI + In Stock use-first control  

## API / contracts

### Profile response (`GET /api/profile`)

```json
{
  "dietaryTags": ["vegetarian"],
  "allergens": ["peanuts"],
  "customAvoid": null,
  "cuisinePreferences": ["mediterranean", "japanese"],
  "skillLevel": "intermediate",
  "equipment": ["oven", "stovetop"],
  "prioritizeExpiringItems": true
}
```

### Profile update (`PUT /api/profile`)

Same shape; server validates enums and max array lengths (e.g. ≤ 20 tags).

### Inventory PATCH fragment

```json
{ "useFirstPriority": "high" }
```

### Suggestions

No API shape change to suggestion DTO required for V1.2; optional future `rankReasons: ["uses_expiring_spinach"]` for explainability — **deferred**.

## Data model

### UserProfile (new persisted entity)

| Field | Type | Notes |
|-------|------|-------|
| `userId` | string PK | Same id as `ICurrentUser` |
| `dietaryTags` | string[] JSON | Controlled vocabulary |
| `allergens` | string[] JSON | Controlled vocabulary |
| `customAvoid` | string? | Max 200 chars |
| `cuisinePreferences` | string[] JSON | |
| `skillLevel` | enum | beginner \| intermediate \| advanced |
| `equipment` | string[] JSON | |
| `prioritizeExpiringItems` | bool | default true |
| `updatedAt` | timestamp | |

### InventoryItem (extend)

| Field | Type | Notes |
|-------|------|-------|
| `useFirstPriority` | enum | `normal` \| `high`; default `normal` |

**Migrations needed:** Y

## UI notes

- Mobile-first: large tap targets for tag chips; sections separated by headings.
- **Diet & allergies** at top (safety-critical).
- Unsaved changes: prompt on navigate away if dirty *(frontend)*.
- In Stock: visual distinction for `high` priority (e.g. accent border or star filled) — align with [ui-principles](../ui-principles.md).

## Acceptance criteria

- [ ] Settings reachable from main shell header; no third inventory/shopping tab added.
- [ ] User can set dietary tags, allergens, cuisines, skill, equipment; values persist across reload for same user id.
- [ ] Toggle **Prioritize expiring items** changes whether expiring-soon affects suggestion order (verified with test inventory dates).
- [ ] User can set **use first** on an inventory row; suggestions using that item rank higher vs control without star.
- [ ] Recipes conflicting with diet/allergen settings do not appear in `/api/recipes/suggestions`.
- [ ] Empty filter state shows helpful copy in recipe pager area.
- [ ] `dotnet test` and `npm run test` cover profile API and ranking/filter behavior; manual smoke on phone-width layout.

## Open questions (design)

| ID | Question | Options | Default recommendation |
|----|----------|---------|------------------------|
| OQ-058 | Allergen/diet rule source | Provider metadata only vs server rules table for Static provider | **Both** — provider tags + small server map for vegan/vegetarian inference |
| OQ-059 | Cuisine/skill/equipment | Hard filter vs score boost only | **Boost only** for V1.2 (avoid empty lists) |
| OQ-060 | `prioritizeExpiringItems` off | Zero expiring term vs hide expiring-highlight styling | **Zero term only**; keep 3-day row styling |
| OQ-061 | First GET profile | 404 vs auto-create empty profile | **Auto-create** on first GET |
| OQ-062 | Sort order with filters | Keep missing↑ score↓ minutes↑ | **Unchanged** unless user testing says otherwise |

Track in [open-questions.md](../../product/open-questions.md).

## Traceability (AWP)

- Feature registry: `FEAT-PRF-001`
- Design state: `spec_review` until OQ-058–062 decided and AC reviewed
- **Do not admit build** until human promotes V1.2 on roadmap and IRG gates pass
- Update [FEAT-REC-001](FEAT-REC-001-recipe-suggestions.md) ranking table when weights are finalized

## Related docs

- [domain-model.md](../../product/domain-model.md) — `UserProfile`, `useFirstPriority`
- [vertical-slices.md](../../architecture/vertical-slices.md) — Profile slice
- [ui-principles.md](../ui-principles.md) — Settings entry, use-first row styling
