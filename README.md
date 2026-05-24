# TrueSight

Full-stack application (ASP.NET Core backend, React frontend). See [`cursor.md`](cursor.md) for stack overview.

## Libraries and tools

### Application stack

| Layer | Libraries / runtime |
|-------|---------------------|
| **Backend** | ASP.NET Core 9, Entity Framework Core (SQLite), MediatR, FluentValidation, ASP.NET Core Identity |
| **Backend tests** | xUnit, `Microsoft.AspNetCore.Mvc.Testing` |
| **Frontend** | React 18, TypeScript, Vite, React Router, TanStack Query, Lucide React |
| **Frontend tests** | Vitest, Testing Library (React, Jest DOM, user-event), jsdom |
| **Database** | SQLite (file `truesight.db` in development) |

### Development and automation

| Tool | Role |
|------|------|
| [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0) | Build and run the API (`global.json` pins SDK 9.0.100+) |
| [Node.js](https://nodejs.org/) 20+ | Frontend install, dev server, build, and tests |
| [Make](https://www.gnu.org/software/make/) | Root and AWP targets (`backend-*`, `frontend-*`, `awp-*`) |
| [yq](https://github.com/mikefarah/yq) v4 | Render and validate AWP register YAML |
| [Graphviz](https://graphviz.org/) (`dot`) | Optional AWP diagram render (`make awp-render` / `make diagram` in `.awp-workspace/`) |
| [Git](https://git-scm.com/) | Version control; optional pre-commit hook via `make awp-install-hooks` |
| [PowerShell](https://learn.microsoft.com/powershell/) | Windows helper scripts under `scripts/` |
| [GitHub Actions](https://github.com/features/actions) | CI: `dotnet` build/test, `npm ci` / build / test, vulnerability and audit checks (`.github/workflows/ci.yml`) |
| [Cursor](https://cursor.com/) | IDE; phase rules and hooks under `.cursor/` |

Architecture notes: vertical slice + CQRS on the backend; mobile-first React SPA (PWA-capable). Details in [`backend/README.md`](backend/README.md) and [`frontend/README.md`](frontend/README.md).

## AI workspace (AWP)

**Design documentation** lives in [`docs/`](docs/) (`@docs/` in Cursor). **AWP registers** (queue, readiness, traceability) live in [`.awp-workspace/`](.awp-workspace/). Code: [`backend/`](backend/) and [`frontend/`](frontend/).

### AWP Build template (source)

Planning workflow is adapted from **[AWP Build](https://gitlab.com/agent-workspace-protocols/workspace-build)** (Agent Workspace Protocols on GitLab):

| | |
|---|---|
| **Original template** | [gitlab.com/agent-workspace-protocols/workspace-build](https://gitlab.com/agent-workspace-protocols/workspace-build) |
| **Template package name** | `workspace-template` (see [`.awp-workspace/template-release.yaml`](.awp-workspace/template-release.yaml)) |
| **Adopted release** | `2026.05.22` |
| **Installed in this repo** | [`.awp-workspace/`](.awp-workspace/) (direct-use, monorepo layout) |

Related upstream templates (`workspace-deployment`, `workspace-sustain`) live in the same GitLab group; only **Build** is vendored here as `.awp-workspace/`. Sideload and upgrade flow: [`.awp-workspace/docs/guides/template-sideloading.md`](.awp-workspace/docs/guides/template-sideloading.md).

**Linux / WSL / macOS:**

```bash
make awp-render
make awp-docs-check
make awp-install-hooks
make awp-install-tools   # yq + graphviz (once)
```

**Windows (PowerShell):**

```powershell
# One-time: install yq (required for register render/checks)
pwsh scripts/install-tools.ps1

# After editing .yaml under .awp-workspace/
make awp-render            # needs make (winget install GnuWin32.Make) or use WSL
make awp-docs-check

# Git pre-commit hook
pwsh scripts/install-hooks.ps1
```

For the full AWP workflow on Windows, **WSL2 is the smoothest path** — all `make` targets work as documented. Native Windows works well for app development; register automation needs `make`, `bash` (Git for Windows), and `yq`.

Agent entrypoints: [`AGENTS.md`](AGENTS.md), [`docs/README.md`](docs/README.md), [`.awp-workspace/AGENTS.md`](.awp-workspace/AGENTS.md), [`backend/AGENTS.md`](backend/AGENTS.md).

**Cursor:** [`.cursor/rules/awp.mdc`](.cursor/rules/awp.mdc), phase rules (`awp-design`, `awp-build`, `awp-verify`), [hooks](.cursor/hooks.json).

## Running the app

Requires **.NET 9 SDK** and **Node.js** (for the frontend).

### Linux / WSL / macOS

```bash
make setup-dotnet      # first time if `dotnet` is not found (installs to ~/.dotnet)
make frontend-install  # once per machine (or after package.json changes)
make backend-run       # API at http://localhost:5158
make frontend-run      # web UI at http://localhost:5173 (separate terminal)
```

### Windows (PowerShell)

```powershell
pwsh scripts/setup-dotnet.ps1    # checks SDK; links to installer if missing
pwsh scripts/backend-stop.ps1    # free port 5158 if a previous run is still up
dotnet run --project backend/TrueSight.Api/TrueSight.Api.csproj --launch-profile http
```

In another terminal:

```powershell
pwsh scripts/frontend-stop.ps1   # free port 5173 if needed
cd frontend; npm install; npm run dev
```

Or use `make backend-run`, `make frontend-run`, and `make frontend-stop` if you have `make` (WSL or [GnuWin32 Make](https://gnuwin32.sourceforge.net/packages/make.htm)).

Web UI: http://localhost:5173 (proxies `/api` to the backend at http://localhost:5158).

## Platform notes

| Task | Linux / WSL | Native Windows |
|------|-------------|----------------|
| Run API | `make backend-run` | `dotnet run …` |
| Run frontend | `make frontend-run` | `cd frontend && npm run dev` |
| Stop API on port 5158 | `make backend-stop` | `pwsh scripts/backend-stop.ps1` |
| Stop frontend on port 5173 | `make frontend-stop` | `pwsh scripts/frontend-stop.ps1` |
| Install frontend deps | `make frontend-install` | `cd frontend && npm install` |
| Build frontend | `make frontend-build` | `cd frontend && npm run build` |
| Install .NET SDK | `make setup-dotnet` | [Official installer](https://dotnet.microsoft.com/download/dotnet/9.0) or `winget install Microsoft.DotNet.SDK.9` |
| AWP register render/check | `make awp-render`, `make awp-docs-check` | WSL recommended; or `make` + `pwsh scripts/install-tools.ps1` |
| Git pre-commit hook | `make awp-install-hooks` | `pwsh scripts/install-hooks.ps1` |

See [`backend/README.md`](backend/README.md) for API details and verification commands.
