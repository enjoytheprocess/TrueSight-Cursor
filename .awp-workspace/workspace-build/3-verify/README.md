# Verify

Use this folder for traceability, validation alignment, and specialist advisory records that may begin in `Design` and finish in `Verify`.

This `README.md` is the human stage guide.
The uppercase files below hold the canonical verification state.

## Core artifacts

- `TRACEABILITY_MATRIX.md` — spec/code/test linkage and alignment gate per feature
- `FEEDBACK_MATRIX.md` — structured human test observations; issues loop back to Build, gaps/deviations promote to staging
- `GAPS_AND_DEVIATIONS.md` — staging register for all gaps and deviations discovered during Build/Verify; passed to Sync as a unit
- `acceptance-gate.md` — human-facing checklist; the agent prepares evidence and moves the task to `awaiting_human_review`, then the human works through this checklist to accept or reject

## Optional artifacts (deployed by `make init` when opted in)

- `SIGN_OFF.md` — formal acceptance audit trail; one entry per accepted task
- `SECURITY_REVIEWS.md` — agent-maintained security analysis records (**active** — see [advisor-policy.md](../../docs/design/advisor-policy.md))
- `API_CONTRACT_REVIEWS.md` — agent-maintained API contract reviews (**active**)
- `EXPERIMENT_REVIEWS.md` — agent-maintained experiment plans and outcomes
- `INCIDENT_RESPONSES.md` — agent-maintained incident response records

## Stage templates (per-entry scaffolds)

- `templates/SECURITY_ANALYSIS_TEMPLATE.md`
- `templates/API_CONTRACT_REVIEW_TEMPLATE.md`
- `templates/EXPERIMENT_PLAN_TEMPLATE.md`
- `templates/INCIDENT_RESPONSE_TEMPLATE.md`

If a specialist advisor track is active, start the relevant record as soon as the analysis begins, then continue updating it with build/verification evidence and the final decision. Set `advisor_status: complete` in `1-design/TASK_READINESS.yaml` once the analysis is complete.
