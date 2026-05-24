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

Requires **.NET 9 SDK** and **Node.js** (for the frontend).

```bash
make setup-dotnet   # first time on WSL/Linux if `dotnet` is not found
make backend-run    # API at http://localhost:5158
```

In another terminal: `cd frontend && npm run dev` (http://localhost:5173, proxies `/api` to the backend).