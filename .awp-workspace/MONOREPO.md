# Monorepo layout (TrueSight)

This directory is the **AWP planning workspace**. Product code lives outside it.

| Path | Role |
|------|------|
| `docs/` | **Stages 0–1 prose** (brief, ideation, design specs, ADRs) — use `@docs/` in Cursor |
| `.awp-workspace/` | AWP registers, workflow docs, `make` targets |
| `backend/` | API service component |
| `frontend/` | Mobile-first web client (React + TypeScript) |

Configuration: `workspace-layout.yaml` in this directory — the **component registry** for this monorepo (`backend`, `frontend`).

Each component has `README.md` and `AGENTS.md` at its repo root and links back here via `.awp-workspace/...` paths.
