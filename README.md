# TrueSight

Full-stack application (ASP.NET Core backend, React frontend). See `cursor.md` for stack overview.

## AI workspace (AWP)

Planning registers and workflow live in [`.awp-workspace/`](.awp-workspace/). The backend service component is [`backend/`](backend/).

```bash
# From repo root (requires make, or run targets under .awp-workspace/)
make awp-init          # re-seed workspace (use FORCE=1 in .awp-workspace if needed)
make awp-render
make awp-docs-check
```

Agent entrypoints: [`AGENTS.md`](AGENTS.md), [`.awp-workspace/AGENTS.md`](.awp-workspace/AGENTS.md), [`backend/AGENTS.md`](backend/AGENTS.md).
