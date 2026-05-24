# backend

Seeded by `make init`.

## Current phase
- Phase: build
- Primary objective: V1 manual inventory, recipe suggestions, and recipe-session deduction
- Completion criteria: V1 endpoints and web client reach human review with updated traceability and validation

## Scope
- In scope: V1 API for inventory CRUD, recipe suggestions, and recipe acceptance with inventory deduction
- Out of scope: V2 photo recognition, charity/org flows, receipt scanning, and final production auth

## Interfaces and contracts
- Upstream dependencies: fill in when known
- Downstream consumers: mobile-first web client (`frontend/` when added)
- **Advisor tracks (project):** `security` + `api_contract` — see [docs/design/advisor-policy.md](../docs/design/advisor-policy.md)
- Key interfaces *(annotate each with `stable | beta | internal` — changing a `stable` interface requires `advisor_track: api_contract`)*:
  - `GET /api/health` — beta
  - `GET /api/inventory` — beta
  - `POST /api/inventory` — beta
  - `GET /api/inventory/{id}` — beta
  - `PUT /api/inventory/{id}` — beta
  - `DELETE /api/inventory/{id}` — beta
  - `GET /api/recipes/suggestions` — beta
  - `GET /api/recipes/{id}` — beta
  - `GET /api/recipe-sessions` — beta
  - `POST /api/recipe-sessions` — beta

## Prerequisites

- **.NET 9 SDK** (project targets `net9.0`; see repo root `global.json`)

**Linux / WSL** without `dotnet` on PATH:

```bash
make setup-dotnet   # installs SDK to ~/.dotnet and prints PATH instructions
```

Or add `export PATH="$HOME/.dotnet:$PATH"` to your shell profile.

**Windows:** install the SDK from [dotnet.microsoft.com](https://dotnet.microsoft.com/download/dotnet/9.0) or run `pwsh scripts/setup-dotnet.ps1` to verify it is on PATH.

## Setup

```bash
make frontend-install
dotnet restore backend/MyApp.sln
```

Or: `cd frontend && npm install`

On WSL/Linux, run `make setup-dotnet` once if `dotnet` is not installed.

## Run

**Linux / WSL:**

```bash
make backend-run
make frontend-run    # separate terminal
```

**Windows (PowerShell):**

```powershell
pwsh scripts/backend-stop.ps1   # optional — clears port 5158
dotnet run --project backend/TrueSight.Api/TrueSight.Api.csproj --launch-profile http
```

In another terminal:

```powershell
pwsh scripts/frontend-stop.ps1   # optional — clears port 5173
cd frontend && npm run dev
```

API listens on **http://localhost:5158** (matches Vite proxy in `frontend/vite.config.ts`).

If you see **address already in use**, a previous dev server is still running:

```bash
make backend-stop           # Linux / WSL — port 5158
make frontend-stop          # Linux / WSL — port 5173
```

```powershell
pwsh scripts/backend-stop.ps1    # Windows — port 5158
pwsh scripts/frontend-stop.ps1   # Windows — port 5173
```

## Verify

```bash
make backend-build
make frontend-build
```

Health check (Linux / WSL / macOS):

```bash
curl -s http://localhost:5158/api/health
```

Windows (PowerShell):

```powershell
Invoke-RestMethod http://localhost:5158/api/health
```

## Required environment variables
- `ConnectionStrings__TrueSight`: optional SQLite connection override. Defaults to `Data Source=truesight.db`.
- `VITE_API_BASE_URL`: optional frontend API base URL. Defaults to Vite proxy `/api` during local dev.

## Links
- Design docs index: docs/README.md
- Project brief: docs/product/project-brief.md
- Product roadmap: docs/product/roadmap.md
- AWP roadmap: .awp-workspace/1-design/ROADMAP.md
- Work queue: .awp-workspace/2-build/WORK_QUEUE.md
- Design docs:
  - docs/design/features/FEAT-INV-001-manual-inventory.md
  - docs/design/features/FEAT-REC-001-recipe-suggestions.md
  - docs/design/features/FEAT-SES-001-recipe-acceptance-deduction.md
- ADRs:
  - docs/design/decisions/ADR-20260523-01-delivery-model-pwa-web.md
  - docs/design/decisions/ADR-20260523-02-recipe-provider-adapter.md

## Operational contract *(fill in before production deployment)*

- **SLO target**: TBD before production.
- **Key health metric**: `GET /api/health` returns `200 OK`; V1 mutation error rate remains low.
- **Where to look when it breaks**: ASP.NET Core structured logs and browser devtools network panel.
- **Rollback procedure**: revert the last deployment or Git commit for the API/client pair.
- **Escalation path**: project owner during hackathon development.
