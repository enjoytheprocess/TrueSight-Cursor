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

---

### GD-009 · `deviation` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-REC-001 | human_feedback | FM-004,FM-005,FM-006 | BUILD-REC-001 |

**Summary:** V1 recipe UX and ingredient model differ from FEAT-REC-001 spec

**Resolution:** Sync 2026-05-24 → DI-009 incorporated in FEAT-REC-001 + ui-principles.

---

### GD-010 · `deviation` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SES-001 | human_feedback | FM-004 | BUILD-SES-001 |

**Summary:** Accept/deduct applies to all recipe ingredients (no optional skip)

**Resolution:** Sync 2026-05-24 → DI-010 incorporated in FEAT-SES-001 + OQ-037.

---

### GD-011 · `deviation` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-INV-001 | human_feedback | FM-002,FM-007 | BUILD-INV-001 |

**Summary:** Inventory merge and add-form UX beyond original spec

**Resolution:** Sync 2026-05-24 → DI-008 incorporated in FEAT-INV-001.

---

### GD-012 · `deviation` · `promoted_to_sync`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-AUTH-001 | human_feedback | FM-003 | BUILD-AUTH-001 |

**Summary:** Demo-user inventory pre-seeded on API startup

**Resolution:** Sync 2026-05-24 → DI-011 incorporated in FEAT-AUTH-001 + backend README.

---

### GD-013 · `deviation` · `resolved_in_loop`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SHP-001 | agent |  | BUILD-SHP-003 |

**Summary:** Shopping list photo-add preview mockup (not in original FEAT-SHP-001 scope)

**Resolution:** Sync 2026-05-24 → DI-012 incorporated in FEAT-SHP-001 + ui-principles.

---

### GD-014 · `gap` · `resolved_in_loop`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SHP-001 | agent |  | BUILD-SHP-001 |

**Summary:** Legacy SQLite databases missing ShoppingListItems table (500 on GET)

**Resolution:** Sync 2026-05-24 → DI-013 documented in backend README + initializer tests.

---

### GD-015 · `deviation` · `resolved_in_loop`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SHP-001 | agent |  | BUILD-SHP-002 |

**Summary:** Tab-specific shell headlines and TRUESIGHT V2.1 branding

**Resolution:** Sync 2026-05-24 → DI-014 incorporated in FEAT-SHP-001.

---

### GD-016 · `deviation` · `resolved_in_loop`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SHP-001 | agent |  | BUILD-SHP-002 |

**Summary:** Move-to-stock and recipe cart actions use green icon buttons

**Resolution:** Sync 2026-05-24 → DI-015 incorporated in FEAT-SHP-001 + ui-principles.
