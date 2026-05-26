# TrueSight (FridgeWise)

**Waste-first kitchen companion:** know what you have, get recipes ranked toward what expires soon, and keep inventory honest after you cook.

Built for the **Cursor Calgary hackathon** (submitted as **FridgeChef** by TrueSight Labs) — prompt: *build something that solves a real pain point in your personal life.* Mobile-first responsive web app (ASP.NET Core API + React SPA).

> **Previous README:** the hackathon-era narrative version is preserved in [`README.hackathon-backup.md`](README.hackathon-backup.md).

## Why we built this

It starts with something small and daily: you get home after a long day, open the fridge, stare at it for two minutes, and still order takeout — not because the fridge is empty, but because your brain is empty. You have eggs, half a pepper, leftover rice, and things you bought with good intentions three days ago. Turning that into a meal *right now*, when you're tired, is where the idea dies.

A few days later, the pepper has turned. You throw things away, feel quietly guilty, and repeat the cycle next week. The food was already paid for and already in your kitchen; it just never became dinner. That pattern — **forgetting what you have, running out of energy to decide, and losing perishables anyway** — is the pain we kept living with.

One of us also spent time around nonprofits and food banks, where people sometimes receive ingredients they do not know how to cook. That widened our lens: the problem is not only “empty fridge,” it is **not knowing how to turn what is already there into a meal you will actually make** — at home, when you are tired, before it spoils.

**TrueSight is our answer to that personal loop:** remember what is in stock, surface recipes you can cook *now*, nudge you toward what expires soon, and update inventory when you commit to cooking — so the app stays honest and the waste cycle has a chance to break.

## What makes this different

Most “what can I cook?” apps stop at suggestions. TrueSight closes the loop:

| Idea | What we did |
|------|-------------|
| **Honest inventory** | Accepting a recipe **deducts** ingredients server-side so the list reflects what you actually used. |
| **Use it before it spoils** | Suggestions are **ranked** with a transparent score that boosts recipes using items expiring within 3 days — not a black-box recommender. |
| **Cook with eyes open** | Each recipe card shows **required vs in-stock** per ingredient, servings scaling, and a **Cook and deduct** gate when stock is insufficient. |
| **Store ↔ fridge** | **In Stock** and **Shopping List** tabs; move items to stock, add missing ingredients from recipes to the cart. |

This is **perishable-aware decision support**, not another recipe search engine.

## What is built (in this repo)

| Capability | Status | Where to look |
|------------|--------|----------------|
| Demo entry (`Enter Demo`) | Shipped | [`frontend/src/features/auth/DemoLoginScreen.tsx`](frontend/src/features/auth/DemoLoginScreen.tsx) |
| Manual inventory (CRUD, expiry, merge) | Shipped | [`docs/design/features/FEAT-INV-001-manual-inventory.md`](docs/design/features/FEAT-INV-001-manual-inventory.md) |
| Recipe suggestions + ranking | Shipped | [`backend/TrueSight.Api/Features/Recipes/ListRecipeSuggestions/Handler.cs`](backend/TrueSight.Api/Features/Recipes/ListRecipeSuggestions/Handler.cs) — score: `(owned×12) − (missing×18) + (expiringSoon×8) − min(minutes,60)/10` |
| Cook and deduct | Shipped | [`docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md`](docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md) |
| Shopping list + main shell | Shipped | [`docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md`](docs/design/features/FEAT-SHP-001-shopping-list-and-main-shell.md) |
| Fridge photo → review → save | **UI mockup** (stub scan) | [`docs/design/features/FEAT-REC-002-fridge-photo-recognition.md`](docs/design/features/FEAT-REC-002-fridge-photo-recognition.md) |
| Profile (diet, use-first, cuisines) | **Design only** | [`docs/design/features/FEAT-PRF-001-user-profile-and-settings.md`](docs/design/features/FEAT-PRF-001-user-profile-and-settings.md) |
| Food bank / donation flows | **Ideation only** | [`docs/product/ideation.md`](docs/product/ideation.md) (IDEA-007) |

Full committed roadmap: [`docs/product/roadmap.md`](docs/product/roadmap.md). Product brief: [`docs/product/project-brief.md`](docs/product/project-brief.md).

## Try it locally

Requires **.NET 9 SDK** and **Node.js 20+**.

```bash
make setup-dotnet      # first time if `dotnet` is not found
make frontend-install  # once per machine
make backend-run       # http://localhost:5158
make frontend-run      # http://localhost:5173 (separate terminal)
```

1. Open http://localhost:5173 → **Enter Demo**.
2. Add inventory with **expiry dates** (try one item expiring in 1–2 days).
3. Open **Recipes** — order should favor dishes using soon-to-expire stock.
4. **Cook and deduct** on a recipe with sufficient stock — confirm quantities drop in **In Stock**.

Windows: see [Platform notes](#platform-notes) and [`backend/README.md`](backend/README.md).

## Vision (not all in this submission)

Charity and food-bank-specific flows ([IDEA-007](docs/product/ideation.md)) are part of our long-term motivation, not the hackathon build. What we shipped targets the **household** loop above first.

| Direction | Notes |
|-----------|--------|
| **V2** | Real fridge photo → vision service → user confirms → inventory ([FEAT-REC-002](docs/design/features/FEAT-REC-002-fridge-photo-recognition.md)). |
| **V1.2** | Diet, allergens, cuisine, skill, equipment, per-item **use first** ([FEAT-PRF-001](docs/design/features/FEAT-PRF-001-user-profile-and-settings.md)). |
| **Ideation** | Expiry alerts, receipt scan, households, store hints — [`docs/product/ideation.md`](docs/product/ideation.md). |

## Stack

| Layer | Libraries / runtime |
|-------|---------------------|
| **Backend** | ASP.NET Core 9, EF Core (SQLite), MediatR, FluentValidation, ASP.NET Core Identity |
| **Backend tests** | xUnit, `Microsoft.AspNetCore.Mvc.Testing` |
| **Frontend** | React 18, TypeScript, Vite, React Router, TanStack Query |
| **Frontend tests** | Vitest, Testing Library |
| **CI** | GitHub Actions — [`.github/workflows/ci.yml`](.github/workflows/ci.yml) |

Architecture: vertical slices + CQRS on the backend; mobile-first SPA (PWA-capable). Details: [`docs/architecture/overview.md`](docs/architecture/overview.md), [`backend/README.md`](backend/README.md), [`frontend/README.md`](frontend/README.md).

## Documentation

| Path | Purpose |
|------|---------|
| [`docs/product/`](docs/product/) | Brief, roadmap, use cases, user stories |
| [`docs/design/features/`](docs/design/features/) | Feature specs (source of truth for behavior) |
| [`docs/design/decisions/`](docs/design/decisions/) | ADRs |
| [`cursor.md`](cursor.md) | Stack overview for Cursor |

## Platform notes

| Task | Linux / WSL | Native Windows |
|------|-------------|----------------|
| Run API | `make backend-run` | `dotnet run --project backend/TrueSight.Api/TrueSight.Api.csproj --launch-profile http` |
| Run frontend | `make frontend-run` | `cd frontend && npm run dev` |
| Stop API on port 5158 | `make backend-stop` | `pwsh scripts/backend-stop.ps1` |
| Stop frontend on port 5173 | `make frontend-stop` | `pwsh scripts/frontend-stop.ps1` |
| Install frontend deps | `make frontend-install` | `cd frontend && npm install` |
| Build frontend | `make frontend-build` | `cd frontend && npm run build` |

Web UI proxies `/api` to the backend. API health: `curl -s http://localhost:5158/api/health`.

## For contributors

**Design docs:** [`docs/`](docs/) · **AWP registers:** [`.awp-workspace/`](.awp-workspace/) (YAML queue/readiness; `make awp-render` after edits).

Agent entrypoints: [`AGENTS.md`](AGENTS.md), [`backend/AGENTS.md`](backend/AGENTS.md). Planning workflow adapted from [AWP Build](https://gitlab.com/agent-workspace-protocols/workspace-build) — see [`.awp-workspace/template-release.yaml`](.awp-workspace/template-release.yaml).

```bash
make awp-render
make awp-docs-check
make awp-install-hooks   # optional pre-commit
```

**Cursor:** [`.cursor/rules/`](.cursor/rules/), [`.cursor/hooks.json`](.cursor/hooks.json).
