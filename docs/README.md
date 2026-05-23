# Design documentation (TrueSight)

Human- and agent-accessible **design docs** live under `docs/`. Use `@docs/` in Cursor to reference them.

AWP **execution registers** (queue, readiness, traceability) live in [`.awp-workspace/`](../.awp-workspace/) — edit `.yaml` there; do not duplicate task state in this folder.

## Layout

| Path | Purpose |
|------|---------|
| [`product/`](product/) | Product vision, domain model, user stories, roadmap |
| [`design/features/`](design/features/) | Per-feature design specs (linked from `WORK_QUEUE.spec_link`) |
| [`design/decisions/`](design/decisions/) | ADRs — link from `decision_links` in registers |
| [`templates/`](templates/) | Copy-paste scaffolds for specs and ADRs |

## Workflow

1. **Design** — Update docs here first (specs, ADRs, product docs), then mirror outcomes into `.awp-workspace/1-design/` registers.
2. **Build** — Implement from an admitted `WORK_QUEUE` task; `spec_link` must point to a file under `docs/`.
3. **Verify / Sync** — Gaps may require new or updated docs under `docs/design/` before the next design cycle.

## Quick links

- [Product roadmap](product/roadmap.md)
- [Domain model](product/domain-model.md)
- [User stories](product/user-stories.md)
- [AWP project brief](../.awp-workspace/1-design/PROJECT_BRIEF.md)
- [Work queue](../.awp-workspace/2-build/WORK_QUEUE.md)
