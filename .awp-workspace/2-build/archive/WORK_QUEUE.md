<!-- Generated from 2-build/archive/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue — Done

_Completed tasks. Active tasks are in `WORK_QUEUE.yaml`._


---

### SETUP-001 · **Configure workspace and connect project components**

| Feature | Component | Priority | Phase | Status | Mode | Capability |
| --- | --- | --- | --- | --- | --- | --- |
| none | backend | P1 | sync | `done` | sequential | none |

**Spec:** `docs/product/project-brief.md`  
**Advisor track:** none · **Advisor status:** not_required · **QRs:** — · **Decisions:** docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md  
**Owner:** unassigned · **Lock:** none · **Target:** TBD  
**Build deps:** none · **Design deps:** none  
**Validation:** `make awp-docs-check; make backend-test; frontend npm run test; frontend/src/api/userId.ts sends X-TrueSight-User from localStorage UUID (TMP-001)
`

> Completed 2026-05-24. Workspace wired; backend+frontend connected; client user id fixed; READMEs updated. Archived after verify.

