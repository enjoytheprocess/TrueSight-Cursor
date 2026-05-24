<!-- Generated from 3-verify/GAPS_AND_DEVIATIONS.yaml — do not edit directly. Run `make render` to update. -->

# Gaps and Deviations Staging

_Open entries. Move promoted/resolved entries to `archive/GAPS_AND_DEVIATIONS.yaml`._


---

### GD-003 · `gap` · `open`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| none | human_feedback | FM-001 | SETUP-001 |

**Summary:** V1 identity missing — project brief lists sign-up/login; only X-TrueSight-User dev header

**Resolution:** —

---

### GD-004 · `deviation` · `open`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-REC-001 | agent | verify-2026-05-24 | BUILD-REC-001 |

**Summary:** Recipe provider hardcoded — config keys and ADR acceptance criterion not met

**Resolution:** —

---

### GD-005 · `gap` · `open`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-SES-001 | agent | verify-2026-05-24 | BUILD-SES-001 |

**Summary:** Recipe accept is not idempotent — duplicate POST double-deducts inventory

**Resolution:** —

---

### GD-006 · `gap` · `open`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-INV-001 | agent | verify-2026-05-24 | BUILD-INV-001 |

**Summary:** IngredientCatalog entity absent — free-text names only

**Resolution:** —

---

### GD-007 · `deviation` · `open`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-INV-001 | agent | verify-2026-05-24 | BUILD-INV-001 |

**Summary:** Inventory API polish gaps — no PATCH, 404 without problem details, no pagination

**Resolution:** —

---

### GD-008 · `gap` · `open`

| Feature | Source | Source Ref | Discovered In |
| --- | --- | --- | --- |
| FEAT-REC-001 | agent | verify-2026-05-24 | BUILD-REC-001 |

**Summary:** No automated tests for recipe suggestions or recipe detail endpoints

**Resolution:** —
