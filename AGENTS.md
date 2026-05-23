# AGENTS

Runtime instructions for AI agents in the TrueSight monorepo.

## Layout

- **Planning workspace (AWP):** `.awp-workspace/` — canonical registers (`1-design/`, `2-build/`, `3-verify/`, `4-sync/`), workflow docs, and `make` targets. Read `.awp-workspace/AGENTS.md` for stage read order and register rules.
- **Backend component:** `backend/` — ASP.NET Core API (vertical slices + CQRS). Read `backend/AGENTS.md` before changing code there.
- **Cursor rules:** `.cursor/rules/` — language and architecture standards.

## Default read order

1. Active task: `.awp-workspace/2-build/WORK_QUEUE.md` (generated; edit `.yaml`).
2. Component context: `backend/AGENTS.md` and `backend/README.md`.
3. Project brief: `.awp-workspace/1-design/PROJECT_BRIEF.md`.

## Commands

From repo root:

```bash
make awp-init          # first-time workspace setup (non-interactive)
make awp-render        # regenerate register .md views
make awp-docs-check    # run AWP consistency checks
make awp-workflow-status
```

Equivalent from `.awp-workspace/`: `make init`, `make render`, `make docs-check`, `make workflow-status`.
