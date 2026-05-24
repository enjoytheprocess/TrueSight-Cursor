<!-- Generated from 3-verify/TRACEABILITY_MATRIX.yaml — do not edit directly. Run `make render` to update. -->

# Feature Traceability Matrix


---

### FEAT-INV-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-INV-001-manual-inventory.md | 2026-05-23 | `aligned` | unassigned |

**Task IDs:** BUILD-INV-001  
**Code links:** backend/TrueSight.Api/Features/Inventory, frontend/src/features/inventory  
**Test links:** dotnet build backend/MyApp.sln, curl smoke test: inventory create/list

> Implemented beta V1 API and UI flow; awaiting human acceptance

---

### FEAT-REC-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-001-recipe-suggestions.md | 2026-05-23 | `aligned` | unassigned |

**Task IDs:** BUILD-REC-001  
**Code links:** backend/TrueSight.Api/Features/Recipes, backend/TrueSight.Api/Infrastructure/Recipes, frontend/src/features/recipes  
**Test links:** dotnet build backend/MyApp.sln, curl smoke test: recipe suggestions

> Implemented static provider and heuristic ranking; awaiting human acceptance

---

### FEAT-SES-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md | 2026-05-23 | `aligned` | unassigned |

**Task IDs:** BUILD-SES-001  
**Code links:** backend/TrueSight.Api/Features/Sessions, frontend/src/features/recipes  
**Test links:** dotnet build backend/MyApp.sln, curl smoke test: accept recipe and inventory deduction

> Implemented recipe-session persistence and required ingredient deduction; awaiting human acceptance

---

### FEAT-REC-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-002-fridge-photo-recognition.md | 2026-05-23 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** backend/  
**Test links:** —

> V2 spec draft; blocked on CAP-V2-VISION admission
