<!-- Generated from 3-verify/TRACEABILITY_MATRIX.yaml — do not edit directly. Run `make render` to update. -->

# Feature Traceability Matrix


---

### FEAT-INV-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-INV-001-manual-inventory.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-INV-001  
**Code links:** backend/TrueSight.Api/Features/Inventory, frontend/src/features/inventory  
**Test links:** dotnet build backend/MyApp.sln, backend/TrueSight.Api.Tests/InventoryEndpointsTests.cs

> Verify 2026-05-24: API CRUD OK; GD-006 catalog, GD-007 contract polish; UI update missing

---

### FEAT-REC-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-001-recipe-suggestions.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-REC-001  
**Code links:** backend/TrueSight.Api/Features/Recipes, backend/TrueSight.Api/Infrastructure/Recipes, frontend/src/features/recipes  
**Test links:** dotnet build backend/MyApp.sln

> Verify 2026-05-24: GD-004 provider config AC gap; GD-008 no suggestion tests (review_needed — active verify)

---

### FEAT-SES-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-SES-001  
**Code links:** backend/TrueSight.Api/Features/Sessions, frontend/src/features/recipes  
**Test links:** backend/TrueSight.Api.Tests/RecipeSessionEndpointsTests.cs

> Verify 2026-05-24: core accept/deduct tested; GD-005 idempotency missing

---

### FEAT-REC-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-002-fridge-photo-recognition.md | 2026-05-23 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** backend/  
**Test links:** —

> V2 spec draft; blocked on CAP-V2-VISION admission
