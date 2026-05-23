# __PROJECT_NAME__

Workspace initialized in direct-use mode.

- Repo mode: `__REPO_MODE__`
- Primary component: `__COMPONENT_NAME__`

## Human quick path
- Read `docs/core/workflow-summary.md`.
- Use `1-design/PROJECT_BRIEF.md`, `2-build/WORK_QUEUE.md`, and `3-verify/TRACEABILITY_MATRIX.md` as the live workflow state.
- Use the component docs under `components/` for component-specific setup and behavior.

## Mode notes
- Tag tasks with concrete component names.
- Keep traceability links repo-relative.
- Reserve shared edits for cross-cutting docs, contracts, and coordination files.
- Use `docs/guides/repo-modes.md` only if the repo topology changes.
- Use `docs/core/operations.md` for command details.

## Setup
- `make install-tools` — one-time install of `yq` (required by `make docs-check` and `make render`)

## Common commands
- `make docs-check`
- `make init-smoke`
- `make install-hooks` (optional — installs a pre-commit hook that runs `make docs-check`)
