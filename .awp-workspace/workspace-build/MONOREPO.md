# Monorepo layout (TrueSight)

This directory is the **AWP planning workspace**. Product code lives outside it.

| Path | Role |
|------|------|
| `docs/` (repo root) | **Stages 0–1 prose** (brief, ideation, design specs, ADRs) — use `@docs/` in Cursor |
| `.awp-workspace/workspace-build/` (this directory) | AWP Build registers, workflow docs, `make` targets |
| `backend/` | API service component |
| `frontend/` | Mobile-first web client (React + TypeScript) |

Configuration: `workspace-layout.yaml` in this directory — the **component registry** for this monorepo (`backend`, `frontend`).

Each component has `README.md` and `AGENTS.md` at its repo root and links back here via `.awp-workspace/workspace-build/...` paths. Sibling templates live under `.awp-workspace/` (see [`.awp-workspace/README.md`](../README.md)).
