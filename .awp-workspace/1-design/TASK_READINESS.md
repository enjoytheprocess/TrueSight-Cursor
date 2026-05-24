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

> Design session 2026-05-24: start with DI-002 (identity). Fast-tracked from Verify/Sync. Re-admit when IRG A=2 I=2 and blocking_unknowns none.


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

> Design session: DI-005 catalog, DI-006 API polish, DI-002 identity. Code baseline exists.


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

> Design session: DI-003 provider config, DI-007 tests. Code baseline exists.


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

> Design session: DI-004 P0 CRITICAL idempotency first. Do not re-build accept path until closed.

