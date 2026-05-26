<!-- Generated from 1-design/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register

_Active tasks. Move completed tasks (WORK_QUEUE status: done) to `archive/TASK_READINESS.yaml` during Sync._


---

### BUILD-SHP-001 · **Implement shopping list API and schema**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**QRs:**   
**Decisions:** 

> Retroactive admission at sync 2026-05-24. Build complete; awaiting human acceptance gate.


---

### BUILD-SHP-002 · **Implement shopping list tab shell and recipe pager**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 | frontend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md

> Retroactive admission at sync 2026-05-24. Tab headlines and TRUESIGHT V2.1 documented in spec.


---

### BUILD-SHP-003 · **Recipe add-to-shopping-list and shopping photo mockup**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 | frontend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md

> Shopping photo mockup is a V1.1 preview extension (parallel to FEAT-REC-002 mockup pattern).


---

### BUILD-SHP-004 · **Responsive two-column shell and shopping-tab persistence**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 | frontend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md

> Design revision 2026-05-26 (OQ-057). Depends on BUILD-SHP-002 accepted or done for shell baseline.


---

### BUILD-REC-002-MOCKUP · **Implement fridge photo UI mockup (demo scan)**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-REC-002 | frontend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-REC-002-fridge-photo-recognition.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md, docs/design/decisions/ADR-20260523-03-v2-vision-boundary.md

> Phase A only: preset /mockups/fridge-preset.jpg, stub detections, demo labeling, POST /api/inventory all-or-nothing. Production vision (OQ-005/006) out of scope.


---

### BUILD-CAT-001 · **Implement ingredient catalog**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-CAT-001 | backend | `needs_detail` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 1 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-CAT-001-ingredient-catalog.md`  
**QRs:**   
**Decisions:** 

> Post-V1 (P3). OQ-053–055 closed in spec. Tick AC before build admit; BUILD-INV-001 done.
