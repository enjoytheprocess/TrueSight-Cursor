# Sync

Use this folder for design alignment, closeout records, and cleanup tracking
after verification is complete. Sync answers one question: **does what was
built fit what the design says?**

This `README.md` is the human stage guide.

## Core artifacts

- `DESIGN_INPUTS.md` — **live register** of open gaps and deviations for the next Design cycle.
  Read this first at the start of every Design session.
  Populated by Sync from `3-verify/GAPS_AND_DEVIATIONS.md`.
- `archive/DESIGN_INPUTS.yaml` — resolved entries; historical record only.
  **Created on demand** when `DESIGN_INPUTS` becomes large — use `templates/init/INIT_DESIGN_ARCHIVE_TEMPLATE.yaml` as the scaffold.

## Sync triage process

For each entry in `3-verify/GAPS_AND_DEVIATIONS.md`:
1. Can this be closed now (quick doc update, no Design cycle needed)?
   - Yes → update design docs; if `archive/DESIGN_INPUTS.yaml` exists (or create it from the template), add entry with `resolution_type: incorporated` or `dismissed`
   - No → add to `DESIGN_INPUTS` with `status: open` for the next Design cycle
2. After triage, ensure `2-build/WORK_QUEUE.md`, `1-design/ROADMAP.md`, and
   `3-verify/TRACEABILITY_MATRIX.md` are aligned with the accepted state.

## Optional advanced artifacts

- `HANDOFFS.md` — ownership transfer history
