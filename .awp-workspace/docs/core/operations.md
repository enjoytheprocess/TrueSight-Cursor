# Operations

Operational commands for this template.

## Prerequisites

- **`yq` (mikefarah/yq v4)** — required by `make render`, `make docs-check`, and most `meta/checks/` scripts.
- **`graphviz`** — required by `make diagram` to render `.dot` source files to SVG.

Install both via:
  ```bash
  make install-tools
  ```
  `yq` installs to `~/.local/bin/` by default (override with `YQ_INSTALL_DIR=<path>`). Graphviz installs via the system package manager (`apt`, `dnf`, or `brew`).

## Core commands
- `make init`: seed the registers with a workspace-setup task, configure the repo mode and component name, and optionally prune advanced registers; also calls `make render`.
- `make render`: regenerate the `.md` table views from the YAML register files. Run this after editing any `.yaml` register.
- `make diagram`: render `docs/diagrams/tiered-adoption.dot` → `docs/diagrams/tiered-adoption.svg`. Run this after editing the `.dot` source.
- `make init-smoke`: verify the bootstrap command in a disposable temp copy.
- `make docs-check`: run documentation quality checks.
- `make docs-boundary`: enforce documentation-and-stage-file edit boundary.
- `make migrate-plan`: compare live register schema versions against the expected versions and print which schema_change migrations still need to be applied. Pass a bundle's upgrade-notes.md as an argument when upgrading from a sideload: `make migrate-plan ARGS=.workspace-template-inbox/<version>/upgrade-notes.md`.
- `make adapt-diff BUNDLE=<path>`: diff consumer files against a sideloaded bundle. Lists replace_reference_paths that will be refreshed and shows unified diffs for adapt_in_place_paths. Use the output as structured input for the local agent's adaptation pass.
- `make roadmap-check`: validate roadmap schema and queue scheduling coverage.
- `make dependency-check`: validate queue-to-dependency consistency.
- `make locks-check`: validate active lock discipline for parallel work.
- `make specialist-check`: validate advisory-record backing for tasks with specialist advisors.
- `make template-package`: build a sideload release bundle under `/tmp/workspace-template-releases` by default.
- `make manifest-lint`: validate `workspace.manifest.yaml`.
- `make sync`: sync component repositories to manifest refs.
- `make status`: show ref/dirty drift by component.
- `make verify`: run per-component verification commands.
- `make ci-verify`: run sync + verify + status in one pass.

## Documentation checks
- `meta/checks/check-canonicality.sh`
- `meta/checks/check-work-queue-columns.sh`
- `meta/checks/check-ready-queue-admission.sh`
- `meta/checks/check-roadmap-columns.sh`
- `meta/checks/check-task-dependencies.sh`
- `meta/checks/check-locks.sh`
- `meta/checks/check-doc-code-drift.sh`
- `meta/checks/check-specialist-gates.sh`
- `meta/checks/check-component-doc-contract.sh`
- `meta/checks/check-register-schema-versions.sh`

## Core vs advanced files

Registers with terminal statuses use a split-YAML pattern: active entries stay in `REGISTER.yaml`; completed/terminal entries are moved to `archive/REGISTER.yaml`. Both render to their own `.md` view via `make render`. Never edit `.md` files directly.

Agents read `REGISTER.yaml` (active) by default. Open `archive/REGISTER.yaml` only when history is needed. Moving a completed entry out of the active YAML is what keeps agent context lean.

Core stage files (active `.yaml` + done `.yaml`; `.md` files are generated):
- `1-design/PROJECT_BRIEF.md` (Markdown narrative — edit directly)
- `1-design/DESIGN_STATES.yaml` → `1-design/DESIGN_STATES.md`
- `1-design/TASK_READINESS.yaml` → `1-design/TASK_READINESS.md`
- `1-design/ROADMAP.yaml` + `1-design/archive/ROADMAP.yaml` → `.md` views
- `2-build/WORK_QUEUE.yaml` + `2-build/archive/WORK_QUEUE.yaml` → `.md` views
- `3-verify/TRACEABILITY_MATRIX.yaml` → `3-verify/TRACEABILITY_MATRIX.md`
- `3-verify/FEEDBACK_MATRIX.yaml` + `3-verify/archive/FEEDBACK_MATRIX.yaml` → `.md` views
- `3-verify/GAPS_AND_DEVIATIONS.yaml` + `3-verify/archive/GAPS_AND_DEVIATIONS.yaml` → `.md` views

Optional advanced stage files (deployed by `make init` when opted in):
- `0-ideation/IDEATION_BACKLOG.yaml`
- `1-design/QUALITY_REQUIREMENTS.md`
- `2-build/TASK_DEPENDENCIES.yaml` → `2-build/TASK_DEPENDENCIES.md`
- `2-build/LOCKS.yaml` + `2-build/archive/LOCKS.yaml` → `.md` views
- `2-build/TEMP_MEASURES.yaml`
- `3-verify/SIGN_OFF.md`
- `3-verify/SECURITY_REVIEWS.md`, `3-verify/EXPERIMENT_REVIEWS.md`, `3-verify/INCIDENT_RESPONSES.md`
- `4-sync/RELEASE_QUEUE.yaml` + `4-sync/archive/RELEASE_QUEUE.yaml` → `.md` views
- `4-sync/HANDOFFS.md`

Use the advanced files when:
- multiple agents or owners are active
- dependency chains create real execution ambiguity
- design changes or temporary exceptions need explicit bookkeeping
- a formal acceptance audit trail is required (`SIGN_OFF.md`)
- specialist advisor analysis is needed

## Recommended reading paths
Human onboarding path:
- `README.md`
- `docs/core/workflow-summary.md`
- the current stage files and any linked specs or component docs

AI runtime path:
- `AGENTS.md`
- active row in `2-build/WORK_QUEUE.yaml` (edit) or `2-build/WORK_QUEUE.md` (read)
- linked rows in `1-design/DESIGN_STATES.yaml`, `1-design/ROADMAP.yaml`, and `3-verify/TRACEABILITY_MATRIX.yaml`
- optional files only when the task actually uses them

Deep reference path:
- `docs/core/workflow-reference.md` when workflow semantics are ambiguous
- `docs/core/glossary.md` when a term needs clarification
- specialist advisor files only when a specialist is active:
  - `3-verify/SECURITY_REVIEWS.md`
  - `3-verify/EXPERIMENT_REVIEWS.md`
  - `3-verify/INCIDENT_RESPONSES.md`
- `docs/guides/worked-example.md` when you want to see the lifecycle stitched together end-to-end

## Specialist preparation
When a task has `advisor_track` set (security, experiment, or incident), read `docs/optional/specialist-tracks.md` and use the matching template in `3-verify/templates/` to structure the analysis. Set `advisor_status: complete` once the analysis is recorded. If the concern cannot be resolved, create a GAPS_AND_DEVIATIONS entry and consider escalating via the Sync stage.

## Consistency and drift control
Use `docs/optional/consistency-gates.md`.
If drift is detected, set `drift_status: drift_detected` in `3-verify/TRACEABILITY_MATRIX.yaml`, create a matching entry in `3-verify/GAPS_AND_DEVIATIONS.yaml`, and block or re-baseline affected tasks.
If timing changes, update `1-design/ROADMAP.md` in the same change set.

`make docs-check` is stage-structure-safe:
- optional advanced checks skip cleanly when their stage-specific files are absent

## Docs-only boundary
`make docs-boundary` fails if changes include non-doc/non-stage areas such as checks, scripts, `Makefile`, or the manifest unless explicitly allowed.

## Manifest mode notes
- Use pinned refs for deterministic multi-repo work.
- Use `HEAD` only for local exploration.
- Keep `verify_command` accurate so `make verify` is reliable.

## Template sideloading
- Use `docs/guides/template-sideloading.md` for new-repo generation, adoption, and upgrade flow.
- Release metadata lives in `template-release.yaml`.
- Use `make template-package` to create a sideload bundle for consumer repos.

## Agent-specific setup

The template ships Claude Code integration files in `templates/agents/claude/`. If you are using Claude Code, copy these once after `make init`:

- `templates/agents/claude/CLAUDE_TEMPLATE.md` → `CLAUDE.md` (project root)
- `templates/agents/claude/settings_TEMPLATE.json` → `.claude/settings.json`

The `settings_TEMPLATE.json` includes a `Stop` hook that runs `make render` automatically after each Claude turn, keeping the generated `.md` table views in sync with the `.yaml` registers without manual intervention.

These files are agent-specific and not part of the core workflow. Other agents can ignore this directory.

## Pre-commit hook (opt-in)

The template ships a sample pre-commit hook in `templates/hooks/pre-commit` that runs `make docs-check` before every commit. To install it:

```bash
make install-hooks
```

This is intentionally opt-in. Teams with existing pre-commit tooling can copy the hook content into their own setup manually instead. `make install-hooks` will not overwrite an existing `.git/hooks/pre-commit`.

## Bootstrap workflow
Use `make init` in a fresh direct-use workspace to:
- render `PROJECT_BRIEF.md`, `README.md`, and `AGENTS.md` with project-specific values
- seed `WORK_QUEUE.yaml` and `TASK_READINESS.yaml` with a ready-to-complete workspace-setup task
- leave `DESIGN_STATES.yaml` and `TRACEABILITY_MATRIX.yaml` empty for the first real feature
- optionally prune advanced registers that the workspace does not plan to use yet

Common example:

```bash
make init MODE=single PROJECT_NAME="Acme Workspace" COMPONENT_NAME=app
```
