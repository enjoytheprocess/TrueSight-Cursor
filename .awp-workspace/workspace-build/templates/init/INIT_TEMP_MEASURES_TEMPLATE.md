# Temporary Measures Register

Track short-term exceptions or tactical decisions that must be removed later.

## Rules
- Every temporary measure must have an owner.
- Every temporary measure must define an exit trigger.
- Every temporary measure must define a removal target date/task.
- Close the measure in the same sync cycle where removal lands.

## Register

Add entries only when a real temporary measure needs an owner and removal target. Run `make render` to regenerate `TEMP_MEASURES.md` from `TEMP_MEASURES.yaml`. Example card:

---

### TMP-001 · **Short description of the temporary measure**

| Scope | Status | Introduced On | Owner | Removal Target |
| --- | --- | --- | --- | --- |
| component-name | `open` | YYYY-MM-DD | unassigned | YYYY-MM-DD or TASK-ID |

**Exit trigger:** describe what must be true before this can be removed  
**Linked tasks:** TASK-ID or —

## Status values
- `open`: still active
- `removal_in_progress`: being removed now
- `closed`: removed and validated
