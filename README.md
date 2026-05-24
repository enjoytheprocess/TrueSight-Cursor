# TrueSight

Full-stack application (ASP.NET Core backend, React frontend). See `cursor.md` for stack overview.

## AI workspace (AWP)

**Design documentation** lives in [`docs/`](docs/) (`@docs/` in Cursor). **AWP registers** (queue, readiness, traceability) live in [`.awp-workspace/`](.awp-workspace/). Code: [`backend/`](backend/).

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
make setup-dotnet   # first time if `dotnet` is not found (installs to ~/.dotnet)
make backend-run    # API at http://localhost:5158
```

### Windows (PowerShell)

```powershell
pwsh scripts/setup-dotnet.ps1   # checks SDK; links to installer if missing
pwsh scripts/backend-stop.ps1   # free port 5158 if a previous run is still up
dotnet run --project backend/TrueSight.Api/TrueSight.Api.csproj --launch-profile http
```

Or use `make backend-run` / `make backend-stop` if you have `make` (WSL or [GnuWin32 Make](https://gnuwin32.sourceforge.net/packages/make.htm)).

### Frontend (all platforms)

In another terminal:

```bash
cd frontend && npm install && npm run dev
```

Web UI: http://localhost:5173 (proxies `/api` to the backend at http://localhost:5158).

## Platform notes

| Task | Linux / WSL | Native Windows |
|------|-------------|----------------|
| Run API + frontend | `make backend-run` + `npm run dev` | `dotnet run …` + `npm run dev` |
| Stop API on port 5158 | `make backend-stop` | `pwsh scripts/backend-stop.ps1` |
| Install .NET SDK | `make setup-dotnet` | [Official installer](https://dotnet.microsoft.com/download/dotnet/9.0) or `winget install Microsoft.DotNet.SDK.9` |
| AWP register render/check | `make awp-render`, `make awp-docs-check` | WSL recommended; or `make` + `pwsh scripts/install-tools.ps1` |
| Git pre-commit hook | `make awp-install-hooks` | `pwsh scripts/install-hooks.ps1` |

See [`backend/README.md`](backend/README.md) for API details and verification commands.
