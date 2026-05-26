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

### BUILD-SHP-004 · **Responsive two-column shell and shopping-tab persistence**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| FEAT-SHP-001 | frontend | P4 | build | `accepted` | sequential | CAP-V1-SHOP |

**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** BUILD-SHP-002 · **Design deps:** none  
**Validation:** `npm run build && npm run test (30 passed); manual: >840px two-column on both tabs; move confirm stays on Shopping List`

> Accepted 2026-05-26 — shell-workspace grid, shopping-tab persistence, centered tagline polish (FM-008).

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
