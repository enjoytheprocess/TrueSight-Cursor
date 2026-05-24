<!-- Generated from 1-design/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register

_Active tasks. Move completed tasks (WORK_QUEUE status: done) to `archive/TASK_READINESS.yaml` during Sync._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| none | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 1 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/product/project-brief.md`  
**QRs:**   
**Decisions:** 

> seeded by make init; mark done when setup is complete — keep this row as the setup record

---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 1 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md

> Admitted for V1 build; final auth remains a future design decision, development identity is header-scoped

---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 1 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md

> Admitted for V1 build with static provider implementation

---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 1 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**QRs:**   
**Decisions:** 

> Admitted for V1 build with same-unit required ingredient deduction
