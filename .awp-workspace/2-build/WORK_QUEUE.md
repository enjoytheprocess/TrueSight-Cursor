<!-- Generated from 2-build/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue

_Active tasks. Move completed tasks to `archive/WORK_QUEUE.yaml`._


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
