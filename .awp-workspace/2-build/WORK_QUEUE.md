<!-- Generated from 2-build/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue

_Active tasks. Move completed tasks to `archive/WORK_QUEUE.yaml`._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| none | backend | P1 | build | `awaiting_human_review` | sequential | none |

**Spec:** `docs/product/project-brief.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `make awp-docs-check`

> Backend solution, API project, and frontend client scaffolded; V1 implementation added for human review

---

### BUILD-INV-001 · **Implement manual inventory CRUD**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-INV-001 | backend | P1 | build | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-INV-001-manual-inventory.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** SETUP-001 · **Design deps:** none  
**Validation:** `dotnet build backend/MyApp.sln; curl smoke test for inventory CRUD`

> Implemented beta API with X-TrueSight-User development identity and hard deletes

---

### BUILD-REC-001 · **Implement V1 recipe suggestions**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-REC-001 | backend | P1 | build | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-REC-001-recipe-suggestions.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-INV-001 · **Design deps:** none  
**Validation:** `dotnet build backend/MyApp.sln; curl smoke test for /api/recipes/suggestions`

> Implemented static RecipeProvider adapter and transparent heuristic ranking

---

### BUILD-SES-001 · **Implement recipe acceptance and inventory deduction**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SES-001 | backend | P1 | build | `awaiting_human_review` | sequential | CAP-V1-CORE |

**Spec:** `docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** —  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-REC-001 · **Design deps:** none  
**Validation:** `dotnet build backend/MyApp.sln; curl smoke test for /api/recipe-sessions`

> Implemented transactional accept flow for required ingredients with same-unit deduction
