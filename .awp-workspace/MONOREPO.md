# Monorepo layout (TrueSight)

This directory is the **AWP planning workspace**. Product code lives outside it.

| Path | Role |
|------|------|
| `docs/` | **Design documentation** (specs, ADRs, product) — use `@docs/` in Cursor |
| `.awp-workspace/` | AWP registers, workflow docs, `make` targets |
| `backend/` | Primary service component (`COMPONENT_NAME=backend`) |

Configuration: `workspace-layout.yaml` in this directory.

Component `README.md` / `AGENTS.md` are generated under `backend/` and link back here via `.awp-workspace/...` paths.
