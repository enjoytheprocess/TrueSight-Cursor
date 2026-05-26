# Traceability Matrix

**Trigger**: Add this module when spec/code/test linkage needs to be maintained and unrecorded changes need to be detectable. Particularly useful when a human reviewer is involved, when the codebase is touched by multiple contributors, or when a compliance audit trail is required.

## Files

| File | Role |
|------|------|
| `3-verify/TRACEABILITY_MATRIX.yaml` | Feature-level linkage and drift status |

## How it works

Each feature row declares its legitimate implementation scope:
- `spec_ref` — the spec or design document the feature was built against
- `code_refs` — code paths considered "in scope" for this feature
- `test_refs` — tests that verify the feature
- `drift_status` — `aligned` or `drift_detected`

**Drift detection**: when `drift_status` is set to `drift_detected`, a corresponding entry must be created in `3-verify/GAPS_AND_DEVIATIONS.yaml`. Reset to `aligned` only after that G&D entry is `resolved_in_loop` or `promoted_to_sync`.

TM is **Build-writable** — agents may update `drift_status` during Build and Verify. `DESIGN_STATES.yaml` is Design-owned and must not be written during Build (except in the fail-quickly path). TM is the load-bearing reason this separation exists: it gives Build a feature-level alignment signal to write without touching the Design record.

Changes to the codebase **within** declared `code_refs` are caught by `drift_detected`. Changes **outside** all declared scope are caught by the unlinked-changes workflow rule (any such change requires a G&D deviation entry before the session ends).

## Connection to the loop

Sync reconciles TM after triage: once all tasks for a feature are `done` and all G&D entries are resolved, the feature row can be archived alongside its DESIGN_STATES entry.
