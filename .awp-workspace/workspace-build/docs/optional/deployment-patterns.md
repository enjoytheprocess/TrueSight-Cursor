# Deployment Patterns

Reference guide for choosing a deployment strategy and verifying rollout safety.

This doc covers the *decision* — not tooling setup. Wire your actual deployment tooling to whatever platform you use; record that in your component README.

## Choosing a strategy

| Strategy | When to use | Rollback speed | Risk |
|---|---|---|---|
| **Direct / restart** | Internal tools, low traffic, stateless | Fast (redeploy prior version) | Full exposure on deploy |
| **Feature flag** | Behavioural changes without infra impact | Instant (toggle off) | Low — blast radius is controlled by flag scope |
| **Rolling** | Stateless services with multiple instances | Medium (scale back old version) | Partial exposure during rollout window |
| **Blue-green** | Full environment swap with instant cutover | Instant (swap back) | Low if environments are truly identical |
| **Canary** | High-traffic or high-risk changes where you want metric-gated rollout | Medium (redirect traffic back) | Low — limited blast radius until metrics clear |

Default to **feature flags** for product behaviour changes and **rolling** for dependency/infra changes. Escalate to canary or blue-green when the change is irreversible, high-traffic, or data-modifying.

## Pre-deployment checklist

Before any production deployment:

- [ ] Rollback procedure is documented and has been tested in staging
- [ ] Observability is in place: key logs and metrics exist for the change
- [ ] Feature flags or traffic controls are ready if the rollout needs to be stopped mid-flight
- [ ] Data migrations (if any) have an approved `data_migration` advisor record and tested rollback path
- [ ] Downstream consumers are not broken by the new version (contract tested or coordinated)
- [ ] On-call or point-of-contact is aware the deployment is happening

## Blast radius control

Limit exposure before you have confidence in a change:

- **Scope the flag**: target internal users or a single region before widening
- **Set a kill switch**: every feature flag must have a documented off-state behaviour
- **Cap the canary**: default to 1–5% traffic; do not auto-advance without metric gates
- **Time-box the window**: define when you will declare success or roll back; don't let "in progress" drift for days

## Rollback criteria

Decide your rollback trigger **before** you deploy, not during an incident:

- Error rate exceeds `X%` for `Y` minutes → roll back immediately
- P99 latency exceeds `Xms` sustained for `Y` minutes → roll back
- Any data integrity anomaly → roll back and engage `incident` specialist track
- Business metric drops by `X%` within `Y` hours → escalate to human decision

Record these thresholds in the task `Notes` or in `3-verify/EXPERIMENT_REVIEWS.md` if the deployment is being treated as an experiment.

## Linking to the workflow

- Record deployment strategy in task `Notes` or as a `QR-*` in `1-design/QUALITY_REQUIREMENTS.md`.
- Schema or data changes → use `advisor_track: data_migration`.
- Metric-gated rollouts → use `advisor_track: experiment`.
- Production failures during rollout → use `advisor_track: incident`.
- Post-deployment verification belongs in the `Verify` stage and should be reflected in `3-verify/FEEDBACK_MATRIX.md`.
