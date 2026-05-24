<!-- Generated from 1-design/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register

_Active tasks. Move completed tasks (WORK_QUEUE status: done) to `archive/TASK_READINESS.yaml` during Sync._


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

> Admitted 2026-05-24 after OQ triage. Build: AP-004 cross-user isolation test if missing. Code baseline retained.


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

> Admitted 2026-05-24. Build: DI-007 recipe integration tests. Depends BUILD-INV-001.


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

> Admitted 2026-05-24. OQ-038 idempotency deferred. Depends BUILD-REC-001.


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

> Admitted 2026-05-24 — TMP-001 demo login (OQ-045/OQ-046). No build deps; parallel with backend.


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

> Post-V1 (P3). OQ-053–055 closed in spec. Tick AC before build admit; depends BUILD-INV-001.

