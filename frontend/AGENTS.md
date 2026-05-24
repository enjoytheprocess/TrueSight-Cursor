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

1. Follow [`docs/design/build-agent-loop.md`](../docs/design/build-agent-loop.md) — one BUILD-* task per pass (e.g. BUILD-AUTH-001 parallel with backend tasks but **separate commit**); re-scan when `build_dependencies` are satisfied.
2. Only implement tasks marked `ready_for_build`.
3. Prefer TanStack Query for server state; keep feature logic in `features/<name>/api`, `hooks`, `types`.
4. Use the shared `api` client in `src/api/` for HTTP.
5. Match [ui-principles.md](../docs/design/ui-principles.md) for inventory and recipe screens.

## Verification contract

- `npm run build` must pass before handoff.
- `npm run test` for unit/component tests (Vitest + Testing Library).
- Manual: `npm run dev` and smoke-test affected routes.

## Model tier

Routine UI slice: **medium**. New routing/data patterns or auth: **high**. See repo root `AGENTS.md`.
