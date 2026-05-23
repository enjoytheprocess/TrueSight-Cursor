## [API-NNN] — [Task title]

- **Task ID**:
- **Date**:
- **Child tasks**: none

### Change summary
What API surface is changing and why?

### Contract analysis
- Change type: `additive | non-breaking | breaking | deprecation | new-interface`
- Affected endpoints / events / types:
- Known consumers: (list internal and external callers; check component README Downstream consumers)
- Backwards compatible: (yes / no — explain)

### Versioning strategy
- Version bump required: (major / minor / patch / none — explain)
- Migration path for consumers: (if breaking — what must callers change, and by when?)
- Deprecation window: (if replacing an existing contract — how long does the old form remain valid?)

### Contract validation
- Does the implementation match the interface designed in the IRG? (ref: design doc or ADR)
- Are there undocumented behaviours introduced by this implementation?
- Are error responses, edge cases, and empty/null states specified?

### Analysis decision
- Status: `in_progress | complete | escalated`
- Gate action: set `advisor_status: complete` in TASK_READINESS when contract is sound and consumer impact is assessed; create a GAPS_AND_DEVIATIONS entry if escalated.
- Notes:
