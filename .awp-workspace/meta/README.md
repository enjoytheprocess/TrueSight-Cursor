# Meta Quality System

Lightweight canonicality and quality checks for workflow/docs structure.

## Structure
- `meta/schemas/`: required structure declarations.
- `meta/templates/`: template index, release-bundle path index, and canonicality pointers.
- `meta/checks/`: executable validations.

## Included checks
- `check-canonicality.sh`: validates required workflow files exist.
- `check-work-queue-columns.sh`: verifies queue schema columns.
- `check-ready-queue-admission.sh`: enforces readiness + advisor gate rules for build-ready tasks.
- `check-roadmap-columns.sh`: validates roadmap schema and queue scheduling coverage.
- `check-task-dependencies.sh`: validates dependency register coverage and queue consistency.
- `check-locks.sh`: validates queue/lock alignment for parallel work.
- `check-doc-code-drift.sh`: enforces feature traceability and drift constraints.
- `check-specialist-gates.sh`: enforces backing advisor records for tasks with specialist advisors.
- `check-component-doc-contract.sh`: enforces component README/AGENTS minimum contract.

## Run all checks
```bash
make docs-check
```
