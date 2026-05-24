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

> BUILD-INV-001 awaiting_human_review — AP-004 cross-user test added 2026-05-24

---

### FEAT-REC-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-001-recipe-suggestions.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-REC-001  
**Code links:** backend/TrueSight.Api/Features/Recipes, backend/TrueSight.Api/Infrastructure/Recipes, frontend/src/features/recipes  
**Test links:** dotnet build backend/MyApp.sln

> BUILD-REC-001 awaiting_human_review — DI-007 tests + canCook/ingredients[] 2026-05-24

---

### FEAT-SES-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-SES-001  
**Code links:** backend/TrueSight.Api/Features/Sessions, frontend/src/features/recipes  
**Test links:** backend/TrueSight.Api.Tests/RecipeSessionEndpointsTests.cs

> BUILD-SES-001 awaiting_human_review — servingMultiplier optional default 1; OQ-038 deferred

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
| docs/design/features/FEAT-AUTH-001-demo-login-screen.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-AUTH-001  
**Code links:** frontend/src/api/userId.ts, frontend/src/App.tsx, frontend/src/features/auth/DemoLoginScreen.tsx, frontend/src/features/app/MainApp.tsx  
**Test links:** frontend/src/api/userId.test.ts, frontend/src/App.test.tsx

> BUILD-AUTH-001 awaiting_human_review — TMP-001 demo login 2026-05-24

---

### FEAT-CAT-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-CAT-001-ingredient-catalog.md | 2026-05-24 | `review_needed` | unassigned |

**Task IDs:** BUILD-CAT-001  
**Code links:** docs/product/domain-model.md  
**Test links:** —

> Design queued 2026-05-24 — TMP-002; delete semantics per OQ-031; no implementation yet
