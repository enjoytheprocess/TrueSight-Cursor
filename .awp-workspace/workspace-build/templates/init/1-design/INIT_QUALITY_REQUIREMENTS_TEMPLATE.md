# Quality Requirements Register

Use this register for cross-cutting or nonfunctional requirements that should stay visible across the workflow even when no formal specialist advisor track is needed.

## When to use this file
Use it when:
- a quality requirement needs a durable origin point that humans can trace later
- the requirement applies across more than one task or spans `Design`, `Build`, and `Verify`
- a formal specialist advisor gate would be too heavy for the situation

Keep small, local, and easily reversible quality notes in task `Notes` instead.

## Workflow expectations
1. Record the requirement during `Design`.
2. Link relevant `QR-*` IDs in design notes, ADRs, and task `Notes` when the requirement shapes implementation.
3. Reflect the requirement in task `Validation` and implementation decisions during `Build`.
4. Confirm each active requirement is satisfied, deferred, or turned into follow-up work during `Verify`.
5. If a requirement is intentionally deferred, link a `TMP-*` in `2-build/TEMP_MEASURES.yaml` or a follow-up task.

## Register

The entries below are pre-seeded starting points for production readiness. Adapt, delete, or extend them to match your project. Run `make render` to regenerate `QUALITY_REQUIREMENTS.md` from `QUALITY_REQUIREMENTS.yaml`.

---

### QR-OBS-001

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| observability | sustained | __PROJECT_NAME__ | all components | `active` |

**Requirement:** Structured logs emitted at key operations, including request IDs or trace IDs  
**Validation:** Logs searchable by trace ID in observability stack

> Adapt log format to your stack

---

### QR-REL-001

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| reliability | per_task | __PROJECT_NAME__ | all components | `active` |

**Requirement:** Timeout and retry policy defined for all external calls  
**Validation:** Policy documented in component README; validated in integration tests

> Prevents cascading failures on dependency degradation; link in TASK_READINESS for tasks adding external calls

---

### QR-PERF-001

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| performance | milestone | __PROJECT_NAME__ | __PROJECT_NAME__ | `active` |

**Requirement:** Availability and latency SLO targets defined before first production deployment  
**Validation:** Targets recorded in component READMEs; baseline captured in load test

> Fill in concrete numbers before going live; link in TASK_READINESS for the pre-production milestone task

---

### QR-SEC-001

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| security | per_task | __PROJECT_NAME__ | all components | `active` |

**Requirement:** Authentication and authorisation model documented for each external-facing interface  
**Validation:** Auth model in design docs or ADRs; reviewed via security advisor track

> Use `advisor_track: security` for tasks that change auth; link in TASK_READINESS for auth design tasks

---

### QR-SEC-002

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| security | sustained | __PROJECT_NAME__ | all components | `active` |

**Requirement:** Secrets and credentials are never hardcoded; all are injected via environment variables  
**Validation:** No secrets in VCS; env vars listed in component README

---

### QR-TEST-001

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| testability | per_task | __PROJECT_NAME__ | all components | `active` |

**Requirement:** Unit, integration, and e2e test layers defined with clear scope boundaries  
**Validation:** Test types and scope documented in component AGENTS.md Verify section

> Define the split before build begins to avoid test gap

---

### QR-DATA-001

| Category | Enforcement | Scope | Applies To | Disposition |
| --- | --- | --- | --- | --- |
| data-safety | per_task | __PROJECT_NAME__ | all components | `active` |

**Requirement:** All schema changes have a documented, tested rollback path  
**Validation:** Rollback demonstrated; data_migration advisor record approved where applicable

> Use `advisor_track: data_migration` for schema-changing tasks; link in TASK_READINESS for each schema-change task

## Disposition values
- `active`: still applies and must be carried through the workflow
- `satisfied`: validated for the current scope
- `deferred`: intentionally postponed with explicit follow-up
- `superseded`: replaced by a newer requirement or decision
- `dropped`: intentionally removed and no longer applicable
