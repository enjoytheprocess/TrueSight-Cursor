<!-- Generated from 2-build/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue

_Active tasks. Move completed tasks to `archive/WORK_QUEUE.yaml`._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| none | backend | P1 | verify | `awaiting_human_review` | sequential | none |

**Spec:** `docs/product/project-brief.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `make awp-docs-check; verify 2026-05-24 — scaffold OK; identity/PWA gaps in GD-003/DI-002`

> Verify loop 2026-05-24: stack wired; auth is dev header only (GD-003). IRG bypass suspected (GD-002→DI-001).

---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | P1 | verify | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** SETUP-001 · **Design deps:** none  
**Validation:** `dotnet build backend/MyApp.sln; InventoryEndpointsTests CRUD+validation; no cross-user test`

> Verify 2026-05-24: API CRUD matches paths; GD-006 catalog, GD-007 PATCH/404/pagination; UI lacks update.

---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | P1 | verify | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-INV-001 · **Design deps:** none  
**Validation:** `dotnet build backend/MyApp.sln; manual/curl only — GD-008 no suggestion tests`

> Verify 2026-05-24: heuristic ranking OK; GD-004 hardcoded provider; GD-008 missing tests.

---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | P1 | verify | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-REC-001 · **Design deps:** none  
**Validation:** `dotnet build backend/MyApp.sln; RecipeSessionEndpointsTests accept+insufficient stock`

> Verify 2026-05-24: deduct+session OK; GD-005 no idempotency (duplicate POST double-deducts).
