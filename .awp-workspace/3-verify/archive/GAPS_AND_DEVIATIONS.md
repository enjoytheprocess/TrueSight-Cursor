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

