<!-- Generated from 4-sync/archive/DESIGN_INPUTS.yaml — do not edit directly. Run `make render` to update. -->

# Design Archive


---

### DI-001 · `gap`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| none |  |  |  | `incorporated` |

**Summary:** Retrospective IRG audit for admitted V1 build tasks  
**Pointer:** —

> All four tasks needs_detail (7/10; A=1 I=1). Re-admit after Design closes DI-002–DI-007. IRG re-score 2026-05-24: SETUP-001 + BUILD-REC-001 ready_for_build; INV/SES need_detail.


---

### DI-002 · `gap`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| none |  |  |  | `incorporated` |

**Summary:** Resolve V1 identity — brief vs dev header (OQ-001)  
**Pointer:** —

> Login off for V1 core loop. ADR-20260524-01 + TMP-001 interim header identity; auth follow-on task removes TMP-001. Brief updated.


---

### DI-003 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-REC-001 |  |  |  | `incorporated` |

**Summary:** Recipe provider configuration contract (ADR-20260523-02)  
**Pointer:** —

> V1 waiver — hardcoded StaticRecipeProvider acceptable for demo. Config keys documented in ADR-02 as follow-on when adding live vendor.


---

### DI-004 · `gap`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-SES-001 |  |  |  | `incorporated` |

**Summary:** CRITICAL — Recipe accept idempotency (OQ-038 / GD-005)  
**Pointer:** —

> Reported "double deduct" was required quantity vs stock UX (e.g. 2 eggs/serving), not duplicate POST. FEAT-REC-001 recipe card (required vs in-stock, canCook) addresses user trust. Server idempotency (OQ-038) deferred for V1; optional UI click guard only.


---

### DI-005 · `gap`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-INV-001 |  |  |  | `incorporated` |

**Summary:** IngredientCatalog vs inline names (OQ-030)  
**Pointer:** —

> V1 inline names only; TMP-002. No catalog schema in current re-build. Domain model updated.


---

### DI-006 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-INV-001 |  |  |  | `incorporated` |

**Summary:** Inventory API contract polish (PATCH, 404 problem details, pagination)  
**Pointer:** —

> V1 waivers in FEAT-INV-001 § Deferred API polish (AP-001–AP-005). AP-004 cross-user test required; other items deferred individually.


---

### DI-007 · `gap`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-REC-001 |  |  |  | `incorporated` |

**Summary:** Recipe suggestions test coverage  
**Pointer:** —

> Required integration tests documented in FEAT-REC-001 test plan (DI-007).


---

### DI-008 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-INV-001 |  |  |  | `incorporated` |

**Summary:** Inventory merge on create and labeled add form  
**Pointer:** —

> FEAT-INV-001 behavior + backend InventoryConsolidator documented.

---

### DI-009 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-REC-001 |  |  |  | `incorporated` |

**Summary:** Recipe card table UX, adjustable servings, no optional ingredients  
**Pointer:** —

> FEAT-REC-001 + ui-principles updated; optional removed from API.

---

### DI-010 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-SES-001 |  |  |  | `incorporated` |

**Summary:** Deduct all recipe ingredients on accept  
**Pointer:** —

> FEAT-SES-001 + OQ-037 aligned with implementation.

---

### DI-011 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-AUTH-001 |  |  |  | `incorporated` |

**Summary:** Demo inventory seeder for demo-user  
**Pointer:** —

> FEAT-AUTH-001 + backend README document DemoInventorySeeder.

---

### DI-012 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 |  |  |  | `incorporated` |

**Summary:** Shopping list photo-add preview mockup  
**Pointer:** —

> FEAT-SHP-001 § Shopping photo preview; asset /mockups/shopping-preset.png; ui-principles cross-ref.


---

### DI-013 · `gap`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 |  |  |  | `incorporated` |

**Summary:** SQLite schema patch for ShoppingListItems on upgrade  
**Pointer:** —

> TrueSightDbInitializer at startup; backend README + initializer tests.

---

### DI-014 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 |  |  |  | `incorporated` |

**Summary:** Tab-specific headlines and per-tab item count  
**Pointer:** —

> FEAT-SHP-001 main shell table updated; TRUESIGHT V2.1 eyebrow.

---

### DI-015 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-SHP-001 |  |  |  | `incorporated` |

**Summary:** Icon controls for move-to-stock and add-to-shopping-list  
**Pointer:** —

> FEAT-SHP-001 + ui-principles — green cart/move icons, ALL header control.

---

### DI-016 · `deviation`

| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |
| --- | --- | --- | --- | --- |
| FEAT-AUTH-002 |  |  |  | `incorporated` |

**Summary:** App.tsx skips DemoLoginScreen cold-start gate  
**Pointer:** —

> Documented in FEAT-AUTH-002 and BUILD-AUTH-002 notes. Intentional UX choice; not a security bypass in Production.

