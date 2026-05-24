<!-- Generated from 3-verify/TRACEABILITY_MATRIX.yaml — do not edit directly. Run `make render` to update. -->

# Feature Traceability Matrix


---

### FEAT-INV-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-INV-001-manual-inventory.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-INV-001  
**Code links:** backend/TrueSight.Api/Features/Inventory, backend/TrueSight.Api/Infrastructure/Data/InventoryConsolidator.cs, frontend/src/features/inventory, frontend/src/features/app/MainApp.tsx  
**Test links:** backend/TrueSight.Api.Tests/InventoryEndpointsTests.cs, backend/TrueSight.Api.Tests/DemoInventorySeederTests.cs, frontend/src/features/inventory/formatting.test.ts

> Sync 2026-05-24 — BUILD-INV-001 done; spec aligned (DI-008).

---

### FEAT-REC-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-001-recipe-suggestions.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-REC-001  
**Code links:** backend/TrueSight.Api/Features/Recipes, backend/TrueSight.Api/Infrastructure/Recipes, frontend/src/features/recipes  
**Test links:** backend/TrueSight.Api.Tests/RecipeSuggestionsEndpointsTests.cs, frontend/src/features/recipes/recipeScaling.test.ts, frontend/src/App.test.tsx

> Sync 2026-05-24 — BUILD-REC-001 done; spec aligned (DI-009).

---

### FEAT-SES-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-SES-001  
**Code links:** backend/TrueSight.Api/Features/Sessions, frontend/src/features/recipes/RecipeCard.tsx  
**Test links:** backend/TrueSight.Api.Tests/RecipeSessionEndpointsTests.cs

> Sync 2026-05-24 — BUILD-SES-001 done; spec aligned (DI-010). OQ-038 deferred.

---

### FEAT-REC-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-002-fridge-photo-recognition.md | 2026-05-23 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** backend/  
**Test links:** —

> V2 spec draft; blocked on CAP-V2-VISION admission

---

### FEAT-AUTH-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-AUTH-001-demo-login-screen.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-AUTH-001  
**Code links:** frontend/src/api/userId.ts, frontend/src/App.tsx, frontend/src/features/auth/DemoLoginScreen.tsx, backend/TrueSight.Api/Infrastructure/Data/DemoInventorySeeder.cs  
**Test links:** frontend/src/api/userId.test.ts, frontend/src/App.test.tsx

> Sync 2026-05-24 — BUILD-AUTH-001 done; spec aligned (DI-011).

---

### FEAT-CAT-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-CAT-001-ingredient-catalog.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-CAT-001  
**Code links:** docs/product/domain-model.md  
**Test links:** —

> Design queued — next extension after V1 core sync.

---

### FEAT-SHP-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md, frontend/src/features/app/MainApp.tsx  
**Test links:** —

> P4 parked — spec draft retained; build deferred behind FEAT-REC-002 photo design.
