<!-- Generated from 1-design/DESIGN_STATES.yaml — do not edit directly. Run `make render` to update. -->

# Design States Register

_Active design triage. Move complete features to `archive/DESIGN_STATES.yaml` during Sync._


---

### FEAT-REC-002 · **Fridge photo recognition (V2)**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `ready` | unassigned | 2026-05-24 |

**Linked idea:** none · **Tasks:** BUILD-REC-002-MOCKUP  
**Spec:** `docs/design/features/FEAT-REC-002-fridge-photo-recognition.md`  
**Decisions:** docs/design/decisions/ADR-20260523-03-v2-vision-boundary.md, docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Blocking questions:** none

> Mockup build admitted (BUILD-REC-002-MOCKUP). Production vision OQ-005/006 deferred.

---

### FEAT-CAT-001 · **Ingredient catalog**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_review` | unassigned | 2026-05-24 |

**Linked idea:** none · **Tasks:** BUILD-CAT-001  
**Spec:** `docs/design/features/FEAT-CAT-001-ingredient-catalog.md`  
**Decisions:**   
**Blocking questions:** spec AC checkboxes unchecked — P3 post-V1

> OQ-053–055 closed; V1 core synced — next extension slice.

---

### FEAT-PRF-001 · **User profile and settings**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_review` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-002,003,004,012 (archived → FEAT-PRF-001) · **Tasks:**   
**Spec:** `docs/design/features/FEAT-PRF-001-user-profile-and-settings.md`  
**Decisions:**   
**Blocking questions:** OQ-058–062 open; AC unchecked — not build-admitted

> design_priority P1 — highest design queue rank. CAP-V1-PROFILE. AUTH-002 recommended for production.


---

### FEAT-INV-002 · **Expiry proximity warnings**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-006 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-INV-002-expiry-proximity-warnings.md`  
**Decisions:**   
**Blocking questions:** none

> design_priority P1 — CAP-V1-POLISH

---

### FEAT-INV-003 · **Inventory search and filter**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-014 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-INV-003-inventory-search-filter.md`  
**Decisions:**   
**Blocking questions:** none

> design_priority P1 — CAP-V1-POLISH

---

### FEAT-REC-003 · **Default serving context**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-001 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-REC-003-default-serving-context.md`  
**Decisions:**   
**Blocking questions:** Storage: localStorage demo vs UserProfile when PRF-001 ships

> design_priority P1 — partial V1 stepper shipped

---

### FEAT-SES-002 · **Recipe session undo**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-013 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-SES-002-recipe-session-undo.md`  
**Decisions:**   
**Blocking questions:** Reversal model: snapshot vs audit lines

> design_priority P2 — CAP-V1-TRUST

---

### FEAT-PLT-001 · **PWA install and offline shell**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-009 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-PLT-001-pwa-offline-shell.md`  
**Decisions:** docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md  
**Blocking questions:** none

> design_priority P2 — CAP-V1-PLATFORM

---

### FEAT-SES-003 · **Partial ingredient deduction**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-016 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-SES-003-partial-deduction.md`  
**Decisions:**   
**Blocking questions:** OQ-042 — after SES-002 undo semantics

> design_priority P3 — CAP-V1-TRUST

---

### FEAT-REC-004 · **Discovery browse beyond inventory**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-017 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-REC-004-discovery-browse.md`  
**Decisions:**   
**Blocking questions:** Depends FEAT-PRF-001 filter metadata

> design_priority P3 — CAP-V1-DISCOVERY

---

### FEAT-REC-005 · **Receipt photo to inventory**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `spec_draft` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-008 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-REC-005-receipt-photo-inventory.md`  
**Decisions:** docs/design/decisions/ADR-20260523-03-v2-vision-boundary.md  
**Blocking questions:** FEAT-REC-002 production vision (OQ-005/006)

> design_priority P3 — CAP-V2-INPUT

---

### FEAT-HH-001 · **Household shared inventory**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `concept` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-015 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-HH-001-household-sharing.md`  
**Decisions:**   
**Blocking questions:** Auth UI not wired; household invite model TBD

> design_priority P4 — CAP-V1-HOUSEHOLD

---

### FEAT-SHP-002 · **Store recommendations**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `concept` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-005 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-SHP-002-store-recommendations.md`  
**Decisions:**   
**Blocking questions:** External provider + privacy spike

> design_priority P4 — CAP-V1-COMMERCE

---

### FEAT-ORG-001 · **Charity / food-bank persona**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `concept` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-007 · **Tasks:**   
**Spec:** `docs/design/features/FEAT-ORG-001-charity-food-bank-persona.md`  
**Decisions:**   
**Blocking questions:** Build vs persona-only decision

> design_priority P4 — CAP-V2-ORG; not consumer MVP

---

### FEAT-SHP-001 · **Shopping list and main shell navigation**

| Design State | Owner | Last Updated |
| --- | --- | --- |
| `ready` | unassigned | 2026-05-26 |

**Linked idea:** IDEA-011 (archived → CAP-V1-SHOP) · **Tasks:** BUILD-SHP-001, BUILD-SHP-002, BUILD-SHP-003, BUILD-SHP-004  
**Spec:** `docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`  
**Decisions:**   
**Blocking questions:** none

> Design revision 2026-05-26 (DI-017, DI-018): two-column shell >840px for both tabs; stay on Shopping List after move confirm. BUILD-SHP-001–003 awaiting acceptance; BUILD-SHP-004 admitted for frontend follow-on.

