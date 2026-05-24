<!-- Generated from 2-build/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue

_Active tasks. Move completed tasks to `archive/WORK_QUEUE.yaml`._


---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | P1 | build | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `Run: dotnet test backend/MyApp.sln — InventoryEndpointsTests (AP-004 added)`

> Build slice 2026-05-24 — AP-004 InventoryItem_is_isolated_per_user. Awaiting acceptance gate.

---

### BUILD-AUTH-001 · **Implement demo login screen (temporary)**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-AUTH-001 | frontend | P2 | build | `todo` | parallel | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-AUTH-001-demo-login-screen.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `Build when admitted — TMP-001 demo login per FEAT-AUTH-001`

> Admitted 2026-05-24 after OQ triage; no implementation in this pass.

---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | P1 | build | `todo` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-INV-001 · **Design deps:** none  
**Validation:** `Build when admitted — DI-007 integration tests per FEAT-REC-001`

> build_dependencies BUILD-INV-001 (implementation). Start when INV awaiting_human_review+.

---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | P1 | build | `todo` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-REC-001 · **Design deps:** none  
**Validation:** `dotnet test — RecipeSessionEndpointsTests; OQ-039 body shape`

> build_dependencies BUILD-REC-001 (implementation). Start when REC awaiting_human_review+.

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

> Not admitted — P3; OQ-053–055 spec ready; awaits V1 core done.
