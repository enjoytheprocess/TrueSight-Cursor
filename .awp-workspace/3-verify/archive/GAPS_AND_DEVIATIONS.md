<!-- Generated from 3-verify/archive/GAPS_AND_DEVIATIONS.yaml — do not edit directly. Run `make render` to update. -->

# Gaps and Deviations — Done

_Promoted and resolved entries. Open entries are in `GAPS_AND_DEVIATIONS.yaml`._


---

### GD-001 · `deviation` · `resolved_in_loop`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SES-001 | verify |  | BUILD-SES-001 |

**Summary:** GET /api/recipe-sessions failed — SQLite cannot ORDER BY DateTimeOffset

**Resolution:** Client-side OrderByDescending after ToListAsync in backend/TrueSight.Api/Features/Sessions/ListRecipeSessions/Handler.cs. Documented in docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md and backend/README.md.


---

### GD-002 · `gap` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| none | human_feedback | FM-001 | BUILD-INV-001 |

**Summary:** Possible IRG bypass at build admission — scores on file without rubric evidence

**Resolution:** Fast Sync 2026-05-24: promoted to DESIGN_INPUTS DI-001 for Design-cycle IRG re-score; Verify loop continues for spec/code fit (GD-003–GD-008).


---

### GD-003 · `gap` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| none | human_feedback | FM-001 | SETUP-001 |

**Summary:** V1 identity missing — project brief lists sign-up/login; only X-TrueSight-User dev header

**Resolution:** Sync 2026-05-24 fast-track → DI-002

---

### GD-004 · `deviation` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-REC-001 | agent | verify-2026-05-24 | BUILD-REC-001 |

**Summary:** Recipe provider hardcoded — config keys and ADR acceptance criterion not met

**Resolution:** Sync 2026-05-24 fast-track → DI-003

---

### GD-005 · `gap` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SES-001 | agent | verify-2026-05-24 | BUILD-SES-001 |

**Summary:** Recipe accept is not idempotent — duplicate POST double-deducts inventory

**Resolution:** Sync 2026-05-24 fast-track → DI-004 (P0 critical)

---

### GD-006 · `gap` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-INV-001 | agent | verify-2026-05-24 | BUILD-INV-001 |

**Summary:** IngredientCatalog entity absent — free-text names only

**Resolution:** Sync 2026-05-24 fast-track → DI-005

---

### GD-007 · `deviation` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-INV-001 | agent | verify-2026-05-24 | BUILD-INV-001 |

**Summary:** Inventory API polish gaps — no PATCH, 404 without problem details, no pagination

**Resolution:** Sync 2026-05-24 fast-track → DI-006

---

### GD-008 · `gap` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-REC-001 | agent | verify-2026-05-24 | BUILD-REC-001 |

**Summary:** No automated tests for recipe suggestions or recipe detail endpoints

**Resolution:** Sync 2026-05-24 fast-track → DI-007
