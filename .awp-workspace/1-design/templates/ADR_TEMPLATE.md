# ADR-YYYYMMDD-NN: <Short Title>

**Date:** YYYY-MM-DD  
**Status:** Proposed | Accepted | Rejected | Superseded  
**Classification:** High-Level Design | Implementation

## How to Use This Template
Create an ADR when a decision changes architecture, contracts, data ownership, rollout strategy, or cross-component behavior in a way that should stay understandable later.

Use lighter notes instead of an ADR when the choice is local, reversible, or unlikely to matter outside the current task.

After writing:
- link the ADR from the relevant feature/task notes when it shapes implementation
- update `1-design/DESIGN_STATES.md`, `1-design/ROADMAP.md`, or `2-build/WORK_QUEUE.md` if the decision changes readiness or sequencing
- keep `3-verify/TRACEABILITY_MATRIX.md` aligned if the ADR changes code/test expectations

## 1. Workflow Metadata

| Field | Value |
| --- | --- |
| Related Feature ID | `FEAT-XXX | none` |
| Related Task ID(s) | `TASK-XXX, TASK-YYY | none` |
| Milestone | `M-XXX | none` |
| Dependency Impact | `build | design | verification | none` |
| Specialist Advisor Involved | `none | security | experiment | incident` |
| Last Synced On | `YYYY-MM-DD` |

## 2. Context

- What problem are we solving?
- What constraints, risks, or requirements matter?
- What changed to trigger this decision now?
- What realistic alternatives were considered?

## 3. Decision

State the decision clearly:
- what was decided
- why it was chosen
- which alternatives were ruled out
- what principle or boundary this establishes

## 4. Consequences

### Positive
- [Benefit]
- [Benefit]

### Negative
- [Trade-off]
- [Constraint introduced]

## 5. Follow-Up Actions

| Action | Owner | Target Date | Tracking |
| --- | --- | --- | --- |
| `<task/doc update>` | `<owner>` | `YYYY-MM-DD | none` | `TASK-XXX | doc update | none` |
| `<task/doc update>` | `<owner>` | `YYYY-MM-DD | none` | `TASK-YYY | doc update | none` |

## 6. References

- [Related design docs]
- [Related ADRs]
- [Relevant tasks, PRs, or discussions]
