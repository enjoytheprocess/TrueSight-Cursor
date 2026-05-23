# __PROJECT_NAME__

Federated planning workspace initialized in sideload/adapt mode.

Starting component: `__COMPONENT_NAME__`

## Human quick path
- Read `docs/core/workflow-summary.md`.
- Use `1-design/PROJECT_BRIEF.md`, `2-build/WORK_QUEUE.md`, and `3-verify/TRACEABILITY_MATRIX.md` as the shared planning state.
- Read `components/COMPONENT_REPOS.md` and `workspace.manifest.yaml` before cross-repo work.

## Mode notes
- Component implementation may live outside this repo.
- Use sibling or explicit external refs in traceability.
- Use `docs/guides/template-sideloading.md` for adoption or upgrade flow.
- Use `docs/guides/repo-modes.md` for topology guidance and `docs/core/operations.md` for commands.

## Setup
- `make install-tools` — one-time install of `yq` (required by `make docs-check` and `make render`)

## Common commands
- `make docs-check`
- `make manifest-lint`
- `make status`
- `make install-hooks` (optional — installs a pre-commit hook that runs `make docs-check`)
