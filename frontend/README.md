# frontend

Mobile-first web client for TrueSight (FridgeWise). V1 UI: inventory list, recipe suggestions, and cook/deduct.

## Stack

- React 18 + TypeScript
- Vite
- React Router
- TanStack Query
- Lucide icons

See [docs/product/open-questions.md](../docs/product/open-questions.md) for future toolchain decisions (Tailwind, PWA depth, etc.).

## Structure

```text
public/
  about.html     # Team About page → /about.html
src/
  api/           # HTTP client + interim user id (TMP-001)
  features/      # inventory + recipes types/formatting
  App.tsx        # V1 inventory and recipe suggestion screens
```

The main app footer links to `/about.html`. The About page logo and footer link back to `/`.

## Identity (V1 interim)

Login is off ([TMP-001](../.awp-workspace/2-build/TEMP_MEASURES.yaml)). The client generates a UUID on first visit, stores it in `localStorage` under `truesight-user-id`, and sends it on every request as `X-TrueSight-User`. See [ADR-20260524-01](../docs/design/decisions/ADR-20260524-01-v1-interim-identity-header.md).

## Setup

```bash
cd frontend
npm install
cp .env.example .env   # optional
```

## Run

```bash
npm run dev
```

Opens http://localhost:5173 (or next free port). Dev server proxies `/api` → `http://localhost:5158` when the backend is running (`make backend-run` from repo root).

## Test & build

```bash
npm run test
npm run build
```

## Links

- UI principles: [docs/design/ui-principles.md](../docs/design/ui-principles.md)
- Project brief: [docs/product/project-brief.md](../docs/product/project-brief.md)
- Backend: [backend/README.md](../backend/README.md)
- Agent rules: [AGENTS.md](./AGENTS.md), [.cursor/rules/frontend.mdc](../.cursor/rules/frontend.mdc)
