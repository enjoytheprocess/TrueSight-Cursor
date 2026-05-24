# TrueSight

Full-stack application (ASP.NET Core backend, React frontend). See `cursor.md` for stack overview.

## AI workspace (AWP)

**Design documentation** lives in [`docs/`](docs/) (`@docs/` in Cursor). **AWP registers** (queue, readiness, traceability) live in [`.awp-workspace/`](.awp-workspace/). Code: [`backend/`](backend/).

```bash
make awp-render
make awp-docs-check
make awp-install-hooks
```

Agent entrypoints: [`AGENTS.md`](AGENTS.md), [`docs/README.md`](docs/README.md), [`.awp-workspace/AGENTS.md`](.awp-workspace/AGENTS.md), [`backend/AGENTS.md`](backend/AGENTS.md).

**Cursor:** [`.cursor/rules/awp.mdc`](.cursor/rules/awp.mdc), phase rules (`awp-design`, `awp-build`, `awp-verify`), [hooks](.cursor/hooks.json).

# Running App

dotnet run --project ./backend/TrueSight.Api/TrueSight.Api.csproj --launch-profile http

cd frontend
npm install
npm run dev

open:
http://localhost:5173/
http://localhost:5158/

stop:

Ran pkill -f "TrueSight.Api.dll"
Ran pkill -f "vite --host 0.0.0.0"
Ran curl -sS http://localhost:5158/api/health
Ran curl -sS http://localhost:5173/
