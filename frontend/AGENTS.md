# AGENTS

Instructions for AI agents working in the frontend component.

## Scope

- Owns the mobile-first web UI (PWA-capable per ADR-20260523-01).
- Does not own API business rules or persistence — those live in `backend/`.

## Required context before changes

1. Read `frontend/README.md`.
2. Follow `.cursor/rules/awp.mdc` — active task in `.awp-workspace/2-build/WORK_QUEUE.yaml`.
3. Read task `spec_link` under `docs/design/features/` when implementing a feature.
4. Read `.cursor/rules/frontend.mdc` for stack and folder conventions.

## Execution rules

1. Only implement tasks marked `ready_for_build`.
2. Prefer TanStack Query for server state; keep feature logic in `features/<name>/api`, `hooks`, `types`.
3. Use the shared `api-client` in `src/services/` for HTTP.
4. Match [ui-principles.md](../docs/design/ui-principles.md) for inventory and recipe screens.

## Verification contract

- `npm run build` must pass before handoff.
- Manual: `npm run dev` and smoke-test affected routes.

## Model tier

Routine UI slice: **medium**. New routing/data patterns or auth: **high**. See repo root `AGENTS.md`.
