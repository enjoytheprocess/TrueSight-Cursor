# Specialist Analysis Tracks

When a task touches a domain with well-defined concern patterns — security, experimentation, incident response, data migration, or API contracts — the agent applies specialist-level thinking in-band with the normal workflow rather than waiting for a human expert.

The `advisor_track` field flags which type of analysis is needed. The `advisor_status` field tracks whether that analysis is complete.

## Analysis types

- `security`: threat exposure, auth/permission changes, sensitive data handling, input validation, compliance risk.
- `experiment`: hypothesis-driven changes with metrics, rollout limits, and decision criteria.
- `incident`: production/service failures requiring containment, root-cause analysis, and corrective action.
- `data_migration`: schema or data changes that require a documented rollback path, backwards-compatibility window, and pre/post-migration validation.
- `api_contract`: changes to a shared or external-facing interface that require backwards-compatibility analysis, a versioning decision, and consumer impact assessment.

One analysis type per task is the default. If a task genuinely requires two types, create a child task for the secondary concern.

## When to apply specialist analysis

Apply `advisor_track` when any condition is true:
1. Changes touch authentication, authorization, secrets, encryption, or sensitive data → `security`
2. A task introduces behavioral uncertainty that must be validated with explicit metrics → `experiment`
3. A live issue affects reliability, availability, or data correctness → `incident`
4. A task modifies database schema, migrates stored data, or changes data format in a way that requires a rollback path → `data_migration`
5. A task changes a `stable` or `beta` interface (endpoint, event, SDK type, protocol), or introduces any new external-facing interface → `api_contract`

The stability tier annotated on each interface in the component README is the trigger signal for condition 5: `stable` → required, `beta` → recommended, `internal` → not required.

For other specialist concerns (database design, infra, performance):
- If no formal gate is needed, record guidance in task notes, design docs, or `1-design/QUALITY_REQUIREMENTS.md`.
- If the concern becomes substantial, create a child task.

## Analysis lifecycle

1. **Design** — identify the concern type; set `advisor_track` and `advisor_status` in `1-design/TASK_READINESS.yaml`.
2. **Build** — open the matching analysis record in `3-verify/`; work through the relevant questions while implementing.
3. **Verify** — confirm findings are documented and residual risks are acknowledged.
4. **Gate resolution** — set `advisor_status: complete` in `TASK_READINESS.yaml` once analysis is complete and findings are recorded.

Analysis is in-band with the main task. Only create a child task when the specialist work itself becomes a separate deliverable with its own scope, owner, or timeline.

## Gate semantics

In `1-design/TASK_READINESS.yaml`:

```yaml
advisor_track: security    # security | experiment | incident | data_migration | api_contract | none
advisor_status: pending    # not_required | pending | complete
```

- `not_required`: no advisor analysis needed for this task.
- `pending`: analysis is required and not yet complete; blocks build admission when set.
- `complete`: analysis is done; findings are documented in the analysis record.

`complete` is set by the **agent** — it means the analysis was done, not that a human signed off. The human authority gate is the separate `specialist_sign_off` structure (see **Human specialist sign-off** below).

If the analysis surfaces something the agent cannot resolve (architectural ambiguity, compliance question requiring human judgement), create a `gap` entry in `3-verify/GAPS_AND_DEVIATIONS.yaml` and note it as needing Design or human input.

## Analysis records

| Type | Record file | Template |
|---|---|---|
| Security | `3-verify/SECURITY_REVIEWS.md` | `3-verify/templates/SECURITY_ANALYSIS_TEMPLATE.md` |
| Experiment | `3-verify/EXPERIMENT_REVIEWS.md` | `3-verify/templates/EXPERIMENT_PLAN_TEMPLATE.md` |
| Incident | `3-verify/INCIDENT_RESPONSES.md` | `3-verify/templates/INCIDENT_RESPONSE_TEMPLATE.md` |
| Data migration | `3-verify/DATA_MIGRATION_REVIEWS.md` | `3-verify/templates/DATA_MIGRATION_REVIEW_TEMPLATE.md` |
| API contract | `3-verify/API_CONTRACT_REVIEWS.md` | `3-verify/templates/API_CONTRACT_REVIEW_TEMPLATE.md` |

Add one entry per task using the template as the section format. `make docs-check` verifies that the backing file exists whenever `advisor_track ≠ none`.

## Choosing the analysis type

- `security` — when risk, auth, secrets, permissions, or sensitive data is the primary concern.
- `experiment` — when hypothesis validation, rollout metrics, and guardrails are the primary concern.
- `incident` — when live-service containment, recovery, and corrective action are the primary concern.
- `data_migration` — when a schema change, data backfill, or format migration requires a tested rollback path.
- `api_contract` — when a shared or external-facing interface is changing and consumer impact must be assessed before the task closes.

## Non-formal specialist concerns

Many concerns do not need a formal track:

- Cross-cutting quality expectations → `1-design/QUALITY_REQUIREMENTS.md`
- Architecture or contract decisions → `1-design/decisions/`
- Domain guidance from other specialists → task notes or child task

## Example: backend auth with security analysis

Task adds refresh-token rotation. Agent sets `advisor_track: security`, `advisor_status: pending`.

During Build, agent opens `3-verify/SECURITY_REVIEWS.md`, adds a new entry, and works through:
- What attack surfaces does token rotation touch?
- What replay, invalidation, or storage risks exist?
- What mitigations are applied in this implementation?
- What residual risks are acceptable?

When the analysis is complete and findings are documented, agent sets `advisor_status: complete`.

If an open question cannot be resolved (e.g., compliance requirement unclear), agent records it in `GAPS_AND_DEVIATIONS.yaml` and does not set `approved` until it is addressed.

## Example: rollout experiment

Task changes cache policy. Agent sets `advisor_track: experiment`, `advisor_status: pending`.

Agent opens `3-verify/EXPERIMENT_REVIEWS.md`, defines the hypothesis, success metrics, guardrails, and decision policy before or during implementation. Sets `advisor_status: complete` once the plan is documented and the rollout design is sound.

## Example: API contract change

Task renames a response field on a `stable` endpoint. Agent sets `advisor_track: api_contract`, `advisor_status: pending`.

Agent opens `3-verify/API_CONTRACT_REVIEWS.md`, adds a new entry, and works through:
- Is this a breaking change? (yes — field rename is not backwards compatible)
- Who are the known consumers? (list from component README downstream consumers)
- What is the versioning strategy? (add new field, deprecate old field with a removal window)
- Does the implementation include a deprecation path or does it break immediately?

When the analysis is complete and the versioning decision is documented, agent sets `advisor_status: complete`. If the deprecation window requires a follow-up removal task, agent creates it before closing.

---

## Human specialist sign-off (optional)

The agent advisor (`advisor_track` / `advisor_status`) is agent-driven — the agent self-approves after completing its analysis. For teams that require formal human domain-expert approval, a separate **specialist sign-off** can be layered on top.

This is opt-in. Enable it by adding the fields below to the specific task rows or GD entries that need it — do not add them globally to registers where sign-off is not required.

### When to use

- Your organisation requires a named human to approve security, compliance, or architectural decisions before work proceeds or ships.
- The agent advisor output is input to a human expert's review rather than a final gate in itself.

### Three gates, three stages

Sign-off can be required at any combination of stages. Each gate blocks the transition it guards.

**Design gate** — does the proposed design meet the standard?
Blocks `readiness: ready_for_build`. Add to the task row in `1-design/TASK_READINESS.yaml`:

```yaml
specialist_sign_off:
  domain: security          # security | architecture | compliance
  required_at: [design]     # list: design | verify | sync — declare all stages up front
  design_status: pending    # pending | approved | waived
  design_approved_by: ""
  design_date: ""
  design_notes: ""
```

`design_status: approved` is set only when the designated human has reviewed and approved. The agent must not self-approve this field.

**Verify gate** — does the implementation meet the standard?
Blocks task acceptance. When `verify` is in `required_at`, add a specialist entry to `3-verify/SIGN_OFF.md` before marking the task `accepted`:

```markdown
- **Specialist sign-off**:
  - Domain: security | architecture | compliance
  - Approved by: [name / role]
  - Date: [YYYY-MM-DD]
  - Notes: [conditions or "none"]
```

**Sync gate** — does a specific deviation or gap violate the standard?
Blocks archival of a GD entry at Sync. Add to the relevant entry in `3-verify/GAPS_AND_DEVIATIONS.yaml` when the deviation has domain-sensitive implications:

```yaml
specialist_review:
  domain: security    # security | architecture | compliance
  status: pending     # pending | approved | waived
  approved_by: ""
  date: ""
  notes: ""
```

A GD entry with `specialist_review.status: pending` must not be archived until a specialist approves or waives it.

### Coexistence with agent advisor

Both gates are independent and can be required on the same task. Typical order:
1. Agent completes its analysis (`advisor_status: complete`) — findings documented in the `3-verify/` record.
2. Human specialist reads the agent's findings, conducts their own review, and approves the relevant stage gate(s).

The agent analysis record serves as input to the human review, not a substitute for it.

### Enabling

No init step is required. Add the fields to the specific rows or entries that need sign-off, and document the designated reviewer in the task `notes` field so the requirement is visible before Build starts.
