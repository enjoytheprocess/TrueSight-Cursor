# TrueSight (hackathon backup)

**Archived copy** of the root README as submitted for the Cursor Calgary hackathon (pre–post-hackathon rewrite). The current README is [`README.md`](README.md).

---

Full-stack application (ASP.NET Core backend, React frontend). See [`cursor.md`](cursor.md) for stack overview.

## The Problem

It starts with something small and daily: you get home after a long day, open the fridge, stare at it for two minutes, and still end up ordering takeout — not because the fridge is empty, but because your brain is. You have eggs, half a pepper, some leftover rice, and things you bought with good intentions three days ago. But turning that into an actual meal, right now, when you're tired? That's where the idea dies.

Then Thursday comes. You open the fridge again and find that pepper has turned. The rice is gone. The eggs made it — barely. You throw things away, feel quietly guilty about it, and do the whole thing again next week.

Wasted food is one of those things that bothers you every single time and yet keeps happening — not because you don't care, but because there was never a system to stop it. Globally, roughly a third of all food produced never gets eaten. Most of it starts exactly like this: in someone's fridge, with the best of intentions.

## The Mission

Food should not be thrown away. Not when people are hungry. Not when the ingredients were already paid for, already brought home, already full of potential. FridgeChef exists to close that gap — between what sits in your fridge and what ends up on your table or in someone else's hands.

## The Solution

FridgeChef is a smart kitchen companion that transforms your existing inventory into meal possibilities. Log what you have — or simply photograph your fridge — and instantly receive personalized recipe suggestions tailored to your family's dietary needs, cuisine preferences, and cooking ability. A family that always cooks the same five dishes can suddenly discover they already have everything needed for a Mediterranean spread or a Japanese stir-fry — they just never knew it.

But FridgeChef goes further than recipes. When ingredients are approaching their expiry and won't make it into a meal in time, the app doesn't just flag them — it acts. It connects you with local food banks, automates the donation request, and turns what would have been a guilty trip to the bin into a contribution to someone who needs it. No food gets thrown. It either feeds your family or feeds someone else's.

## Origin Story

The idea for FridgeChef came from one founder's experience working with nonprofits, where food bank users sometimes received unfamiliar ingredients and were unsure how to cook with them. It showed us that the challenge is not always having food available — it is knowing how to turn that food into a meal.

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
| [Graphviz](https://graphviz.org/) (`dot`) | Optional AWP diagram render (`make awp-render` / `make diagram` in `.awp-workspace/workspace-build/`) |
| [Git](https://git-scm.com/) | Version control; optional pre-commit hook via `make awp-install-hooks` |
| [PowerShell](https://learn.microsoft.com/powershell/) | Windows helper scripts under `scripts/` |
| [GitHub Actions](https://github.com/features/actions) | CI: `dotnet` build/test, `npm ci` / build / test, vulnerability and audit checks (`.github/workflows/ci.yml`) |
| [Cursor](https://cursor.com/) | IDE; phase rules and hooks under `.cursor/` |

Architecture notes: vertical slice + CQRS on the backend; mobile-first React SPA (PWA-capable). Details in [`backend/README.md`](backend/README.md) and [`frontend/README.md`](frontend/README.md).

## AI workspace (AWP)

**Design documentation** lives in [`docs/`](docs/) (`@docs/` in Cursor). **AWP registers** (queue, readiness, traceability) live in [`.awp-workspace/workspace-build/`](.awp-workspace/workspace-build/). Code: [`backend/`](backend/) and [`frontend/`](frontend/).

### AWP Build template (source)

Planning workflow is adapted from **[AWP Build](https://gitlab.com/agent-workspace-protocols/workspace-build)** (Agent Workspace Protocols on GitLab):

| | |
|---|---|
| **Original template** | [gitlab.com/agent-workspace-protocols/workspace-build](https://gitlab.com/agent-workspace-protocols/workspace-build) |
| **Template package name** | `workspace-template` (see [`.awp-workspace/workspace-build/template-release.yaml`](.awp-workspace/workspace-build/template-release.yaml)) |
| **Adopted release** | `2026.05.22` |
| **Installed in this repo** | [`.awp-workspace/workspace-build/`](.awp-workspace/workspace-build/) (direct-use, monorepo layout) |

Related upstream templates (`workspace-deployment`, `workspace-sustain`) live in the same GitLab group; only **Build** is vendored here as `.awp-workspace/workspace-build/`. Sideload and upgrade flow: [`.awp-workspace/workspace-build/docs/guides/template-sideloading.md`](.awp-workspace/workspace-build/docs/guides/template-sideloading.md).

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

# After editing .yaml under .awp-workspace/workspace-build/
make awp-render            # needs make (winget install GnuWin32.Make) or use WSL
make awp-docs-check

# Git pre-commit hook
pwsh scripts/install-hooks.ps1
```

For the full AWP workflow on Windows, **WSL2 is the smoothest path** — all `make` targets work as documented. Native Windows works well for app development; register automation needs `make`, `bash` (Git for Windows), and `yq`.

Agent entrypoints: [`AGENTS.md`](AGENTS.md), [`docs/README.md`](docs/README.md), [`.awp-workspace/workspace-build/AGENTS.md`](.awp-workspace/workspace-build/AGENTS.md), [`backend/AGENTS.md`](backend/AGENTS.md).

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
