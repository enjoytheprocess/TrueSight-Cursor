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


---

### BUILD-SEC-001 · **Security hygiene and sustained quality requirements**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | `ready_for_build` | security | complete |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**QRs:** QR-SEC-001, QR-SEC-002, QR-SEC-003  
**Decisions:** 

> Security audit 2026-05-24 — .gitignore + sustained QRs.

---

### BUILD-SEC-002 · **CI security automation (GitHub Actions)**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**QRs:** QR-SEC-003  
**Decisions:** 

> GitHub Actions CI workflow.

---

### BUILD-SEC-003 · **API production edge hardening**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SEC-001 | backend | `ready_for_build` | security | complete |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**QRs:** QR-SEC-001, QR-SEC-002  
**Decisions:** 

> CORS, rate limit, headers, Production identity rules.

---

### BUILD-SEC-004 · **Retroactive SECURITY_REVIEWS for shipped V1 APIs**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | `ready_for_build` | security | complete |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 1 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**QRs:**   
**Decisions:** 

> Verify-phase documentation; no code required.

---

### BUILD-AUTH-002 · **Implement real authentication (close TMP-001)**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-AUTH-002 | backend | `needs_detail` | security | pending |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 1 | 2 | 2 | 2 |

**Blocking unknowns:** Auth mechanism — cookie session vs JWT bearer

**Spec:** `docs/design/features/FEAT-AUTH-002-real-authentication.md`  
**QRs:** QR-SEC-001  
**Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md

> Promote to ready_for_build after mechanism ADR + BUILD-SEC-003 accepted.
