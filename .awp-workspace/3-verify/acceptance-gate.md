# Acceptance Gate

Use this checklist when a task reaches `awaiting_human_review`.

The goal is to confirm that the implementation is safe to accept and that
all collected feedback has been recorded before the cycle moves to Sync.

This checklist covers Verify-scope concerns only.
Design-alignment questions (does what was built match the spec?) belong to Sync.

## 1. Validation Quality
- Is the recorded `Validation` evidence in `2-build/WORK_QUEUE.md` believable and sufficient?
- Were the right automated tests, manual checks, or contract checks run for this change?
- Are there known failures, skipped checks, or residual risks that need explicit acknowledgment?

## 2. Feedback Completeness
- Are all human test observations recorded in `3-verify/FEEDBACK_MATRIX.md`?
- Have all `issue` entries been resolved or explicitly deferred back to Build?
- Have all `gap` and `deviation` entries been promoted to `3-verify/GAPS_AND_DEVIATIONS.md`?

## 3. Advisor and Risk Follow-Up
- If a specialist advisor was involved, is the advisory record complete?
- If `Advisor Gate = required`, is the gate clearly resolved?
- Were follow-up or remediation tasks created when needed?

## 4. Operational Readiness
- **Deployment**: Is rollout or rollback guidance documented for this change? (See `docs/optional/deployment-patterns.md`)
- **Observability**: Are key logs and metrics emitted for this change? Can you tell if it's healthy in production?
- **Data handling**: If schema or data changes are involved, is a `data_migration` advisor record complete and approved?
- **Secrets / config**: Are any new environment variables or secrets listed in the component README?
- **Blast radius**: Is the change scoped to avoid unintended impact on other components or users?
- **Known gaps**: Is there anything a human operator must know before deployment that is not captured above?

## 5. Acceptance Decision
Choose one explicitly:
- `accept`: move to `awaiting_sync` — record a Sign Off entry if `3-verify/SIGN_OFF.md` is in use
- `needs_changes`: return to active Build with concrete review notes
- `needs_design_refresh`: issue is a design mismatch, not an implementation bug — record in GAPS_AND_DEVIATIONS and proceed to Sync
