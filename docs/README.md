# Design documentation (TrueSight)

Human- and agent-accessible **design docs** live under `docs/`. Use `@docs/` in Cursor to reference them.

AWP **execution registers** (queue, readiness, traceability) live in [`.awp-workspace/`](../.awp-workspace/) — edit `.yaml` there; do not duplicate task state in this folder.

## Layout

| Path | Purpose |
|------|---------|
| [`product/`](product/) | [Project brief](product/project-brief.md), roadmap, ideation, domain model, stories |
| [`ideation/`](ideation/) | Stage 0 guide (workflow before design commitment) |
| [`design/`](design/) | Stage 1 guide, [features/](design/features/), [decisions/](design/decisions/) |
| [`templates/`](templates/) | Scaffolds (brief, idea, feature spec, ADR) |
| [`.awp-workspace/`](../.awp-workspace/) | **Registers only** (YAML) — stages 0–4 execution state |

## Workflow

1. **Design** — Update docs here first (specs, ADRs, product docs), then mirror outcomes into `.awp-workspace/1-design/` registers.
2. **Build** — Implement from an admitted `WORK_QUEUE` task; `spec_link` must point to a file under `docs/`.
3. **Verify / Sync** — Gaps may require new or updated docs under `docs/design/` before the next design cycle.

## Quick links

- [Project brief](product/project-brief.md)
- [Product index](product/README.md)
- [Stage 0 — Ideation](ideation/README.md) · [Ideation backlog](product/ideation.md)
- [Stage 1 — Design](design/README.md)
- [AWP registers](../.awp-workspace/) (YAML; `.md` views generated)
- [Work queue](../.awp-workspace/2-build/WORK_QUEUE.md)
