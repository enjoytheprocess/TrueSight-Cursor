# Repository Modes

`make init` installs fixed root `README.md` and `AGENTS.md` templates for the selected mode.
That keeps the live entrypoint instructions mode-specific instead of relying on later AI rewrites.

## Single-component mode
Use when all product logic ships as one deployable unit.

Suggested layout:
```text
components/
└── app/
    ├── src/
    ├── tests/
    ├── README.md
    └── AGENTS.md
```

Guidance:
- Keep one primary queue in `2-build/WORK_QUEUE.md`.
- Keep capability groupings in `1-design/ROADMAP.md`.
- Use `Mode = sequential` for most tasks.
- Only use parallel locks for large refactors or urgent throughput.
- In `3-verify/TRACEABILITY_MATRIX.md`, prefer repo-relative local code/test paths.
- Root entrypoint templates:
  - `templates/init/WORKSPACE_README_TEMPLATE.md`
  - `templates/init/WORKSPACE_AGENTS_TEMPLATE.md`

## Multi-component mode
Use when the product has independent deployables (e.g., API + web + worker).

Suggested layout:
```text
components/
├── api/
├── web/
└── worker/
```

Guidance:
- Tag each task with a concrete component name.
- Sequence cross-component work through shared capabilities in `1-design/ROADMAP.md`.
- Prefer component-scoped locks (e.g., `components/api/**`).
- Reserve shared locks for cross-cutting files and contracts.
- Use component doc contract templates for each component:
  - `templates/component/COMPONENT_README_TEMPLATE.md`
  - `templates/component/COMPONENT_AGENTS_TEMPLATE.md`
- In `3-verify/TRACEABILITY_MATRIX.md`, prefer repo-relative local paths for each component or shared contract path.
- Root entrypoint templates:
  - `templates/init/WORKSPACE_README_TEMPLATE.md`
  - `templates/init/WORKSPACE_AGENTS_TEMPLATE.md`

## Multi-repo mode (federated)
Use when each component lives in its own repository and this repo acts as the shared AI planning hub.

Suggested layout:
```text
.
├── 0-ideation/
├── 1-design/
├── 2-build/
├── 3-verify/
├── 4-sync/
├── docs/
├── components/
│   └── COMPONENT_REPOS.md
├── scripts/
├── workspace.manifest.yaml
└── Makefile
```

`components/COMPONENT_REPOS.md` example:
```text
| Component | Repository URL | Default Branch | Local Path (optional) |
| --- | --- | --- | --- |
| api | git@example.com/org/api.git | main | ../api |
| web | git@example.com/org/web.git | main | ../web |
```

Manifest-driven workflow (optional but recommended):
- `make manifest-lint`
- `make sync`
- `make status`
- `make verify`

Guidance:
- Keep architecture and cross-component decisions in this template repo.
- Execute component-specific implementation in each component repo.
- Track cross-repo dependencies in `2-build/WORK_QUEUE.md` and `2-build/TASK_DEPENDENCIES.md` (if dependency tracking is in use).
- Keep ideation/design governance centralized in `1-design/DESIGN_STATES.md` and `1-design/ROADMAP.md`; use `0-ideation/IDEATION_BACKLOG.yaml` when ideation is in use.
- In `3-verify/TRACEABILITY_MATRIX.md`, prefer explicit external references such as `repo:<component>@<ref>:<path>` unless the component is also checked out locally.
- Root entrypoint templates:
  - `templates/WORKSPACE_README_FEDERATED_TEMPLATE.md`
  - `templates/WORKSPACE_AGENTS_FEDERATED_TEMPLATE.md`

Accepted traceability reference styles for federated work:
- repo-relative local checkout path inside this repo, such as `components/api/src`, when the component is synced here
- sibling checkout path such as `../api/src`, when the component is checked out next to this repo
- explicit external reference such as `repo:api@<ref>:src`
- pinned URL to a specific ref, such as `https://host/org/api/blob/<ref>/src/index.ts`
