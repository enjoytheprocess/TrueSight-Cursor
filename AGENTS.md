# AGENTS

Runtime instructions for AI agents in the TrueSight monorepo.

## Cursor

Cursor loads **`.cursor/rules/awp.mdc`** (`alwaysApply: true`) so every agent session is directed to read AWP registers under `.awp-workspace/`. Register YAML edits use **`.cursor/rules/awp-registers.mdc`**.

## Layout

- **Design documentation:** `docs/` — product vision, feature specs, ADRs (`@docs/` in Cursor).
- **Planning workspace (AWP):** `.awp-workspace/` — execution registers (queue, readiness, traceability). Edit `.yaml`; hooks run `make awp-render`.
- **Backend component:** `backend/` — ASP.NET Core API. Read `backend/AGENTS.md` before code changes.
- **Cursor:** `.cursor/rules/awp*.mdc`, `.cursor/hooks.json`, snippets under `.cursor/snippets/awp-*.md`.

## Default read order

1. Active task: `.awp-workspace/2-build/WORK_QUEUE.yaml` (+ `TASK_READINESS.yaml`).
2. Task `spec_link` under `docs/` (e.g. `docs/product/project-brief.md`, `docs/design/features/`).
3. `backend/AGENTS.md` when implementing.

## Commands

From repo root:

```bash
make awp-render
make awp-docs-check
make awp-workflow-status
make awp-install-hooks   # pre-commit: render + docs-check
```

Equivalent from `.awp-workspace/`: `make init`, `make render`, `make docs-check`, `make workflow-status`.
