<!-- Generated from 1-design/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register

_Active tasks. Move completed tasks (WORK_QUEUE status: done) to `archive/TASK_READINESS.yaml` during Sync._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| none | backend | `needs_detail` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 1 | 1 | 1 | 2 |

**Blocking unknowns:** OQ-001 V1 identity (brief vs dev header); scaffold AC not tied to brief sign-up/login

**Spec:** `docs/product/project-brief.md`  
**QRs:**   
**Decisions:** 

> IRG 2026-05-24 retrospective: build ran on inflated A/I=2. Stack OK (GD-003). Re-admit after DI-002 closes identity scope or brief defers auth to post-V1.


---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | `needs_detail` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 1 | 1 | 1 | 1 |

**Blocking unknowns:** OQ-030 IngredientCatalog vs inline; OQ-001 per-user identity; spec AC still draft/unchecked

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md

> IRG 2026-05-24 retrospective: API CRUD implemented (GD-006/007). Prior admission invalid: A/I overstated. Do not accept until catalog/identity TBDs closed or spec updated + V≥2.


---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | `needs_detail` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 1 | 1 | 1 | 1 |

**Blocking unknowns:** Provider config contract (GD-004/DI-003); OQ-002 vendor selection; GD-008 test gap

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md

> IRG 2026-05-24 retrospective: ranking OK; hardcoded provider fails A (config AC). Re-admit after DI-003 + suggestion endpoint tests or waived AC in spec.


---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | `needs_detail` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 1 | 1 | 1 | 2 |

**Blocking unknowns:** OQ-038 idempotency on accept (GD-005); optional-ingredient policy TBD in spec

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**QRs:**   
**Decisions:** 

> IRG 2026-05-24 retrospective: deduct+session tested. A/I=2 was wrong — idempotency open. Fix GD-005 or spec waiver before accept.

