# frontend

Mobile-first web client for TrueSight (FridgeWise). Stub scaffold — routes and feature folders only; API integration when backend slices ship.

## Stack (planned — see `docs/product/open-questions.md`)

- React + TypeScript
- Vite
- React Router
- TanStack Query
- Tailwind CSS

## Structure

```text
src/
  app/           # providers, shell pages
  routes/        # route table
  services/      # shared api-client
  shared/        # cross-feature UI
  features/      # vertical slices (inventory, recipes, …)
  components/    # shared presentational components
  hooks/         # shared hooks
```

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

Opens http://localhost:5173. Dev server proxies `/api` → `http://localhost:5158` (when backend is running — `make backend-run`).

## Build

```bash
npm run build
```

## Links

- UI principles: [docs/design/ui-principles.md](../docs/design/ui-principles.md)
- Project brief: [docs/product/project-brief.md](../docs/product/project-brief.md)
- Backend: [backend/README.md](../backend/README.md)
- Agent rules: [AGENTS.md](./AGENTS.md), [.cursor/rules/frontend.mdc](../.cursor/rules/frontend.mdc)
