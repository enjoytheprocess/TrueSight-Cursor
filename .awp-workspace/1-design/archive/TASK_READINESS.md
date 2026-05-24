<!-- Generated from 1-design/archive/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register — Done

_Completed tasks. Active tasks are in `TASK_READINESS.yaml`._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| none | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/product/project-brief.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md

> Completed 2026-05-24. IRG 10/10. TMP-001 client user id in frontend/src/api/userId.ts.


---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md, docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md

> Done 2026-05-24 — Sync archived.

---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md

> Done 2026-05-24 — Sync archived.

---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md

> Done 2026-05-24 — Sync archived.

---

### BUILD-AUTH-001 · **Implement demo login screen (temporary)**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-AUTH-001 | frontend | `ready_for_build` | none | not_required |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-AUTH-001-demo-login-screen.md`  
**QRs:**   
**Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md

> Done 2026-05-24 — Sync archived.

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

> Sync 2026-05-24 — done.

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

> Sync 2026-05-24 — done.

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

> Sync 2026-05-24 — done.

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

> Sync 2026-05-24 — done.

---

### BUILD-AUTH-002 · **Implement real authentication (close TMP-001)**

| Feature | Component | Readiness | Advisor Track | Advisor Status |
| --- | --- | --- | --- | --- |
| FEAT-AUTH-002 | backend | `ready_for_build` | security | complete |

| S | A | I | R | V |
| --- | --- | --- | --- | --- |
| 2 | 2 | 2 | 2 | 2 |

**Blocking unknowns:** none

**Spec:** `docs/design/features/FEAT-AUTH-002-real-authentication.md`  
**QRs:** QR-SEC-001  
**Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md, docs/design/decisions/ADR-20260524-02-cookie-authentication.md

> Sync 2026-05-24 — done; TMP-001 closed.
