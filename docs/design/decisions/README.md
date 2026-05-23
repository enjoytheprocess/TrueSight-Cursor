# Architecture decision records (ADRs)

Durable decisions live here — not under `.awp-workspace/1-design/decisions/`.

Start from [../../templates/ADR_TEMPLATE.md](../../templates/ADR_TEMPLATE.md).

## When to add an ADR

Create an ADR when a decision:

- changes architecture or system boundaries
- affects multiple components
- changes contracts, schema ownership, or rollout policy
- is likely to be questioned again later

Use a feature spec or task notes for small, local, reversible choices.

## Naming

`ADR-YYYYMMDD-NN-short-title.md`

Examples:

- `ADR-20260523-01-sqlite-persistence.md`
- `ADR-20260523-02-recipe-matching-strategy.md`

## Workflow

- Write or update during **Design**
- Link from `decision_links` in `WORK_QUEUE`, `TASK_READINESS`, or `DESIGN_STATES`
- Update `ROADMAP`, readiness, and `TRACEABILITY_MATRIX` if sequencing or verification changes
