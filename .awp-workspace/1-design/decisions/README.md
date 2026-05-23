# Decision Records

Use this directory for optional Architecture Decision Records (ADRs) and other durable design decisions.

Start from:
- `1-design/templates/ADR_TEMPLATE.md`

## When to add an ADR
Create an ADR when a decision:
- changes architecture or system boundaries
- affects multiple components or repositories
- changes contracts, schema ownership, or rollout policy
- is likely to be questioned again later without a durable record

Do not force an ADR for every design note.
If the decision is small, local, and easily reversible, keep it in task notes or a feature spec instead.

## Suggested organization
- keep ADR files directly in this directory for small projects
- optionally add subdirectories later if the decision volume grows

Suggested naming:
- `ADR-YYYYMMDD-NN-short-title.md`

Examples:
- `ADR-20260324-01-auth-session-boundary.md`
- `ADR-20260324-02-event-contract-versioning.md`

## How ADRs fit the workflow
- create or update an ADR during `Design`
- link it from the relevant queue/task notes when it affects implementation
- update roadmap, readiness, and traceability if the decision changes sequencing or verification expectations
