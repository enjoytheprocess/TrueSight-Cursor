# Design priority queue

**Purpose:** All active ideation items are **promoted to design** (draft specs + AWP registers). This file is the **single sort order** for design and future build admission — **not** build order until IRG gates pass.

**Legend:** `P1` = highest design priority · `P4` = lowest · **Ease:** S / M / L (web stack, current codebase).

| Rank | Design priority | Feature | Source idea | Capability | Ease | Design state |
|------|-----------------|--------|-------------|------------|------|--------------|
| 1 | **P1** | [FEAT-PRF-001](features/FEAT-PRF-001-user-profile-and-settings.md) | IDEA-002/003/004/012 | CAP-V1-PROFILE | M | spec_review |
| 2 | **P1** | [FEAT-INV-003](features/FEAT-INV-003-inventory-search-filter.md) | IDEA-014 | CAP-V1-POLISH | S | spec_draft |
| 3 | **P1** | [FEAT-INV-002](features/FEAT-INV-002-expiry-proximity-warnings.md) | IDEA-006 | CAP-V1-POLISH | S–M | spec_draft |
| 4 | **P1** | [FEAT-REC-003](features/FEAT-REC-003-default-serving-context.md) | IDEA-001 | CAP-V1-POLISH | S | spec_draft |
| 5 | **P2** | [FEAT-SES-002](features/FEAT-SES-002-recipe-session-undo.md) | IDEA-013 | CAP-V1-TRUST | M | spec_draft |
| 6 | **P2** | [FEAT-PLT-001](features/FEAT-PLT-001-pwa-offline-shell.md) | IDEA-009 | CAP-V1-PLATFORM | M | spec_draft |
| 7 | **P2** | [FEAT-REC-002](features/FEAT-REC-002-fridge-photo-recognition.md) (production slice) | — | CAP-V2-VISION | L | ready (mockup); prod TBD |
| 8 | **P2** | [FEAT-AUTH-002](features/FEAT-AUTH-002-real-authentication.md) (auth UI slice) | — | CAP-V1-IDENTITY | M | aligned (API); UI design queued |
| 9 | **P3** | [FEAT-SES-003](features/FEAT-SES-003-partial-deduction.md) | IDEA-016 | CAP-V1-TRUST | M–L | spec_draft |
| 10 | **P3** | [FEAT-REC-004](features/FEAT-REC-004-discovery-browse.md) | IDEA-017 | CAP-V1-DISCOVERY | M | spec_draft |
| 11 | **P3** | [FEAT-REC-005](features/FEAT-REC-005-receipt-photo-inventory.md) | IDEA-008 | CAP-V2-INPUT | L | spec_draft |
| 12 | **P3** | [FEAT-CAT-001](features/FEAT-CAT-001-ingredient-catalog.md) | — | CAP-V1-EXT | M | spec_review |
| 13 | **P4** | [FEAT-HH-001](features/FEAT-HH-001-household-sharing.md) | IDEA-015 | CAP-V1-HOUSEHOLD | L | concept |
| 14 | **P4** | [FEAT-SHP-002](features/FEAT-SHP-002-store-recommendations.md) | IDEA-005 | CAP-V1-COMMERCE | L | concept |
| 15 | **P4** | [FEAT-ORG-001](features/FEAT-ORG-001-charity-food-bank-persona.md) | IDEA-007 | CAP-V2-ORG | L | concept |

## Sequencing rules

1. Finish **CAP-V1-PROFILE** (PRF-001) before **CAP-V1-DISCOVERY** (REC-004).
2. **CAP-V1-POLISH** items are independent of each other; any order within P1 is fine.
3. **CAP-V1-TRUST:** ship **SES-002** (undo) before or instead of **SES-003** (partial deduct).
4. **CAP-V2-INPUT:** receipt (REC-005) after fridge photo production (REC-002).
5. **CAP-V1-HOUSEHOLD** and **CAP-V2-ORG** after auth UI + real accounts.

## Registers

- Features: `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- Design maturity: `.awp-workspace/1-design/DESIGN_STATES.yaml`
- Roadmap capabilities: `.awp-workspace/1-design/ROADMAP.yaml`
- Ideation archive: `.awp-workspace/0-ideation/archive/IDEATION_BACKLOG.yaml`

**Promoted:** 2026-05-26 — all former open `IDEA-*` rows moved to design; see [ideation.md](../product/ideation.md).
