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
| docs/design/features/FEAT-REC-002-fridge-photo-recognition.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-REC-002-MOCKUP  
**Code links:** frontend/public/mockups/fridge-preset.jpg, frontend/src/features/app/MainApp.tsx, frontend/src/features/fridge-photo/FridgePhotoMockupOverlay.tsx, frontend/src/features/fridge-photo/stubDetections.ts, frontend/src/features/fridge-photo/saveDetectedItems.ts  
**Test links:** frontend/src/App.test.tsx, frontend/src/features/fridge-photo/saveDetectedItems.test.ts

> Phase A mockup admitted — preset photo + stub review UI; production Recognition slice TBD.

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

### FEAT-PRF-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-PRF-001-user-profile-and-settings.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** docs/design/features/FEAT-PRF-001-user-profile-and-settings.md, docs/product/domain-model.md  
**Test links:** —

> Design 2026-05-26 — no build tasks; OQ-058–062 open.

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
| docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md | 2026-05-26 | `aligned` | unassigned |

**Task IDs:** BUILD-SHP-001, BUILD-SHP-002, BUILD-SHP-003, BUILD-SHP-004  
**Code links:** backend/TrueSight.Api/Features/ShoppingList, backend/TrueSight.Api/Infrastructure/Data/TrueSightDbInitializer.cs, frontend/src/features/app/MainApp.tsx, frontend/src/styles.css, frontend/src/features/shopping-list, frontend/src/features/shopping-photo, frontend/src/features/recipes/RecipePager.tsx, frontend/src/features/recipes/RecipeCard.tsx, frontend/public/mockups/shopping-preset.png  
**Test links:** backend/TrueSight.Api.Tests/ShoppingListEndpointsTests.cs, backend/TrueSight.Api.Tests/TrueSightDbInitializerTests.cs, frontend/src/App.test.tsx, frontend/src/features/recipes/RecipePager.test.tsx

> Aligned 2026-05-26 — BUILD-SHP-004 accepted: shell-workspace two-column layout, shopping-tab persistence, centered tagline (OQ-057). BUILD-SHP-001–003 still awaiting_human_review.


---

### FEAT-SEC-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SEC-001-production-security-baseline.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-SEC-001, BUILD-SEC-002, BUILD-SEC-003, BUILD-SEC-004  
**Code links:** .gitignore, .github/workflows/ci.yml, backend/TrueSight.Api/Program.cs, backend/TrueSight.Api/appsettings.json, backend/TrueSight.Api/appsettings.Production.json, backend/TrueSight.Api/Infrastructure/Security, backend/TrueSight.Api/Infrastructure/ClaimsCurrentUser.cs, .awp-workspace/workspace-build/1-design/QUALITY_REQUIREMENTS.yaml, .awp-workspace/workspace-build/3-verify/SECURITY_REVIEWS.md  
**Test links:** backend/TrueSight.Api.Tests/ProductionSecurityTests.cs, backend/TrueSight.Api.Tests/ApiMutationRateLimitingTests.cs, backend/TrueSight.Api.Tests/AuthEndpointsTests.cs, backend/TrueSight.Api.Tests

> Sync 2026-05-24 — CAP-V1-SEC delivered (SEC-001–004, AUTH-002).

---

### FEAT-AUTH-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-AUTH-002-real-authentication.md | 2026-05-24 | `aligned` | unassigned |

**Task IDs:** BUILD-AUTH-002  
**Code links:** backend/TrueSight.Api/Features/Auth, backend/TrueSight.Api/Infrastructure/ClaimsCurrentUser.cs, backend/TrueSight.Api/Infrastructure/Data/ApplicationUser.cs, frontend/src/api/auth.ts, frontend/src/api/client.ts, frontend/src/features/auth/DemoLoginScreen.tsx  
**Test links:** backend/TrueSight.Api.Tests/AuthEndpointsTests.cs, backend/TrueSight.Api.Tests/ProductionSecurityTests.cs

> API shipped; design_priority P2 auth UI slice queued — sign-in/sign-up not in App flow.

---

### FEAT-INV-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-INV-002-expiry-proximity-warnings.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P1 — partial styling only (IDEA-006)

---

### FEAT-INV-003

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-INV-003-inventory-search-filter.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P1

---

### FEAT-REC-003

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-003-default-serving-context.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** frontend/src/features/recipes/RecipeCard.tsx, frontend/src/features/recipes/recipeScaling.ts  
**Test links:** frontend/src/features/recipes/recipeScaling.test.ts

> design_priority P1 — per-card stepper partial

---

### FEAT-SES-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SES-002-recipe-session-undo.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P2

---

### FEAT-SES-003

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SES-003-partial-deduction.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P3

---

### FEAT-PLT-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-PLT-001-pwa-offline-shell.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P2

---

### FEAT-REC-004

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-004-discovery-browse.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P3 — after FEAT-PRF-001

---

### FEAT-REC-005

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-REC-005-receipt-photo-inventory.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P3 — after REC-002 production

---

### FEAT-SHP-002

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-SHP-002-store-recommendations.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P4

---

### FEAT-HH-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-HH-001-household-sharing.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P4

---

### FEAT-ORG-001

| Spec | Last Synced | Drift Status | Owner |
| --- | --- | --- | --- |
| docs/design/features/FEAT-ORG-001-charity-food-bank-persona.md | 2026-05-26 | `review_needed` | unassigned |

**Task IDs:** —  
**Code links:** —  
**Test links:** —

> design_priority P4 — persona/design
