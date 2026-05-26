# AWP workspace (multi-template)

Planning templates vendored under this directory. Product code and human design docs stay at the repo root (`docs/`, `backend/`, `frontend/`).

| Path | Template | Role |
|------|----------|------|
| [`workspace-build/`](workspace-build/) | [AWP Build](https://gitlab.com/agent-workspace-protocols/workspace-build) | Active registers, workflow docs, `make` targets for TrueSight |

## Commands

From the repo root (preferred):

```bash
make awp-render
make awp-docs-check
make awp-workflow-status
```

Equivalent from the active template directory:

```bash
make -C .awp-workspace/workspace-build render
```

Agent contract: [`workspace-build/AGENTS.md`](workspace-build/AGENTS.md).
