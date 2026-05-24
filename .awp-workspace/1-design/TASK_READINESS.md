<!-- Generated from 1-design/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register

_Active tasks. Move completed tasks (WORK_QUEUE status: done) to `archive/TASK_READINESS.yaml` during Sync._


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

