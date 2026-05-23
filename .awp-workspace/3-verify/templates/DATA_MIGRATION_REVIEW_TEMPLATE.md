## [MIG-NNN] — [Task title]

- **Task ID**:
- **Date**:
- **Child tasks**: none

### Change summary
What schema or data change is being made? What state is affected?

### Migration design
- Type: `additive | destructive | restructuring | backfill`
- Backwards-compatible window: (how long must the old schema remain readable?)
- Zero-downtime path: (is this migration safe to apply without a service restart?)
- Rollback procedure: (exact steps to reverse this migration if it fails)

### Pre-migration validation
- Data audit: (what pre-flight checks confirm the data is in expected shape?)
- Volume estimate: (rows / bytes affected)
- Risk of data loss: (none / low / high — explain)

### Post-migration validation
- What confirms the migration succeeded?
- Are rollback markers or feature flags in place to revert if anomalies appear?

### Analysis decision
- Status: `in_progress | complete | escalated`
- Gate action: set `advisor_status: complete` in TASK_READINESS when complete; create a GAPS_AND_DEVIATIONS entry if escalated.
- Notes:
