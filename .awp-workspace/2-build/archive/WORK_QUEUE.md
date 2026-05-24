<!-- Generated from 2-build/archive/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue — Done

_Completed tasks. Active tasks are in `WORK_QUEUE.yaml`._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| none | backend | P1 | sync | `done` | sequential | none |

**Spec:** `docs/product/project-brief.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `make awp-docs-check; make backend-test; frontend npm run test; frontend/src/api/userId.ts sends X-TrueSight-User from localStorage UUID (TMP-001)
`

> Completed 2026-05-24. Workspace wired; backend+frontend connected; client user id fixed; READMEs updated. Archived after verify.


---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | P1 | sync | `done` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `dotnet test — 14 passed; npm test — 16 passed; npm run build`

> Sync 2026-05-24 — GD-011 incorporated (merge on create, form UX).

---

### BUILD-AUTH-001 · **Implement demo login screen (temporary)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-AUTH-001 | frontend | P2 | sync | `done` | parallel | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-AUTH-001-demo-login-screen.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `npm test — login gate + Enter Demo`

> Sync 2026-05-24 — GD-012 incorporated (DemoInventorySeeder).

---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | P1 | sync | `done` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-INV-001 · **Design deps:** none  
**Validation:** `RecipeSuggestionsEndpointsTests; recipe card + recipeScaling tests`

> Sync 2026-05-24 — GD-009 incorporated (table UX, no optional, servings).

---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | P1 | sync | `done` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-REC-001 · **Design deps:** none  
**Validation:** `RecipeSessionEndpointsTests — 14 backend total`

> Sync 2026-05-24 — GD-010 incorporated (deduct all ingredients). OQ-038 deferred.

---

### BUILD-SEC-001 · **Security hygiene and sustained quality requirements**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | P1 | sync | `done` | parallel | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** QR-SEC-001, QR-SEC-002, QR-SEC-003 · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `make awp-docs-check passed; .gitignore .env*; QR-SEC-001–003; backend/README production keys`

> Sync 2026-05-24 — accepted; commit 03cfb65.

---

### BUILD-SEC-002 · **CI security automation (GitHub Actions)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | P1 | sync | `done` | parallel | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** QR-SEC-003 · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `.github/workflows/ci.yml — backend test + vulnerable packages; frontend build/test + npm audit`

> Sync 2026-05-24 — accepted; commit d0612fa.

---

### BUILD-SEC-003 · **API production edge hardening**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | backend | P1 | sync | `done` | sequential | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** QR-SEC-001, QR-SEC-002 · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SEC-001 · **Design deps:** none  
**Validation:** `dotnet test — Production 401 + cookie auth path; CORS/rate-limit/headers/HSTS`

> Sync 2026-05-24 — accepted; commit f3fb113.

---

### BUILD-SEC-004 · **Retroactive SECURITY_REVIEWS for shipped V1 APIs**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | P2 | sync | `done` | parallel | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `SECURITY_REVIEWS — SEC-RETRO-INV/REC/SES/SHP`

> Sync 2026-05-24 — accepted; verify slice complete.

---

### BUILD-AUTH-002 · **Implement real authentication (close TMP-001)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-AUTH-002 | backend | P1 | sync | `done` | sequential | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-AUTH-002-real-authentication.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** QR-SEC-001 · **Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md, docs/design/decisions/ADR-20260524-02-cookie-authentication.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SEC-003 · **Design deps:** none  
**Validation:** `dotnet test 29; npm test 28; TMP-001 closed; cookie auth`

> Sync 2026-05-24 — accepted; ADR-20260524-02. App.tsx no cold-start login gate (DI-016).
