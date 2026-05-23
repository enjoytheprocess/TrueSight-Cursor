# Project Overview

This repository contains a full-stack application using:

- Backend: ASP.NET Core
- Architecture: Vertical Slice Architecture + CQRS
- Frontend: React + TypeScript
- Database: SQLite
- ORM: Entity Framework Core

Detailed implementation rules are located in `.cursor/rules`.

## Documentation & AWP

- **Design docs:** `docs/` — use `@docs/` for product, feature specs, and ADRs.
- **Registers:** `.awp-workspace/` — queue, readiness, traceability (YAML canonical).
- **Cursor:** `.cursor/rules/awp.mdc` + phase rules; hooks auto-run `make awp-render` after register edits.

```bash
make awp-render      # after editing .yaml registers
make awp-docs-check  # before handoff
```

Always follow repository conventions before generating code.