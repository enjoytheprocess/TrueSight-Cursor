<!-- Generated from 2-build/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue

_Active tasks. Move completed tasks to `archive/WORK_QUEUE.yaml`._


---

### BUILD-SHP-001 · **Implement shopping list API and schema**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SHP-001 | backend | P4 | build | `awaiting_human_review` | sequential | CAP-V1-SHOP |

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-INV-001 · **Design deps:** none  
**Validation:** `dotnet test — 18 passed; GET/POST/DELETE /api/shopping-list, move-to-inventory`

> Shipped 2026-05-24 — ShoppingListItems + TrueSightDbInitializer for legacy SQLite.

---

### BUILD-SHP-002 · **Implement shopping list tab shell and recipe pager**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SHP-001 | frontend | P4 | build | `awaiting_human_review` | sequential | CAP-V1-SHOP |

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SHP-001 · **Design deps:** none  
**Validation:** `npm run build && npm run test (29 passed); manual: tabs, pager, move/delete icons`

> Shipped 2026-05-24 — In Stock | Shopping List shell, tab headlines, item-count bar.

---

### BUILD-SHP-003 · **Recipe add-to-shopping-list and shopping photo mockup**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SHP-001 | frontend | P4 | build | `awaiting_human_review` | sequential | CAP-V1-SHOP |

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SHP-001 · **Design deps:** none  
**Validation:** `npm run test; manual: cart icons, ALL add-missing, shopping photo preview flow`

> Shipped 2026-05-24 — /mockups/shopping-preset.png stub scan → POST /api/shopping-list.

---

### BUILD-REC-002-MOCKUP · **Implement fridge photo UI mockup (demo scan)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-REC-002 | frontend | P2 | build | `awaiting_human_review` | parallel | CAP-V2-VISION |

**Spec:** `docs/design/features/FEAT-REC-002-fridge-photo-recognition.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md, docs/design/decisions/ADR-20260523-03-v2-vision-boundary.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `npm run build && npm run test (22 passed); manual: demo flow + mockup AC in FEAT-REC-002`

> Phase A mockup shipped — overlay, demo labeling, stub scan, all-or-nothing POST inventory.

---

### BUILD-CAT-001 · **Implement ingredient catalog**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-CAT-001 | backend | P3 | design | `todo` | sequential | CAP-V1-EXT |

**Spec:** `docs/design/features/FEAT-CAT-001-ingredient-catalog.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-INV-001 · **Design deps:** none  
**Validation:** `Design only — tick AC before build admit (post-V1 / TMP-002)`

> V1 core synced 2026-05-24 — BUILD-INV-001 done; not build-admitted.

---

### BUILD-SEC-001 · **Security hygiene and sustained quality requirements**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | P1 | build | `awaiting_human_review` | parallel | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** QR-SEC-001, QR-SEC-002, QR-SEC-003 · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `make awp-docs-check passed; .gitignore .env*; QR-SEC-001–003 in QUALITY_REQUIREMENTS; backend/README production keys`

> Shipped 2026-05-24 — hygiene slice for SEC audit.

---

### BUILD-SEC-002 · **CI security automation (GitHub Actions)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | P1 | build | `awaiting_human_review` | parallel | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** QR-SEC-003 · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `.github/workflows/ci.yml — backend test + vulnerable packages; frontend build/test + npm audit --audit-level=high`

> Shipped 2026-05-24 — CI on push/PR to main|master.

---

### BUILD-SEC-003 · **API production edge hardening**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | backend | P1 | build | `awaiting_human_review` | sequential | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** QR-SEC-001, QR-SEC-002 · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SEC-001 · **Design deps:** none  
**Validation:** `dotnet test — 28 passed; Production 401/400 + Testing fallback; CORS/rate-limit/headers/HSTS`

> Shipped 2026-05-24 — SEC-02–SEC-09 mitigations; TMP-001 remains until BUILD-AUTH-002.

---

### BUILD-SEC-004 · **Retroactive SECURITY_REVIEWS for shipped V1 APIs**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SEC-001 | repo | P2 | verify | `todo` | parallel | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-SEC-001-production-security-baseline.md`  
**Advisor track:** security · **Advisor status:** complete · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `SECURITY_REVIEWS.md has retroactive entries for INV/REC/SES/SHP build tasks`

> Audit SEC-14. Process debt — can run anytime; does not block SEC-003.

---

### BUILD-AUTH-002 · **Implement real authentication (close TMP-001)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-AUTH-002 | backend | P1 | design | `todo` | sequential | CAP-V1-SEC |

**Spec:** `docs/design/features/FEAT-AUTH-002-real-authentication.md`  
**Advisor track:** security · **Advisor status:** pending · **QRs:** QR-SEC-001 · **Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SEC-003 · **Design deps:** none  
**Validation:** `dotnet test + npm test; TMP-001 closed; login form enabled`

> Audit SEC-01/SEC-04. Needs auth mechanism ADR before build admit.
