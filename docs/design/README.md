# Stage 1 — Design

Design intent, maturity tracking, and delivery sequencing. **Durable prose** lives under `docs/`; **register state** lives in [`.awp-workspace/workspace-build/1-design/`](../../.awp-workspace/workspace-build/1-design/).

## Core documents (docs/)

| Document | Path |
|----------|------|
| **Design priority queue** | [design-priority-queue.md](design-priority-queue.md) — promoted ideas, P1–P4 |
| Project brief | [../product/project-brief.md](../product/project-brief.md) |
| Feature specs | [features/](features/) |
| UI principles | [ui-principles.md](ui-principles.md) |
| Build agent loop | [build-agent-loop.md](build-agent-loop.md) — one task, commit, dependency re-scan |
| Advisor policy | [advisor-policy.md](advisor-policy.md) — `security` + `api_contract` tracks |
| ADRs | [decisions/](decisions/) |
| Templates | [../templates/](../templates/) |

## Core registers (AWP — edit `.yaml`)

| Register | File |
|----------|------|
| Feature identities | `FEATURE_REGISTRY.yaml` |
| Design maturity | `DESIGN_STATES.yaml` |
| Build admission (IRG) | `TASK_READINESS.yaml` |
| Capability sequencing | `ROADMAP.yaml` |

Generated `.md` table views: run `make awp-render` from repo root.

## Optional

- `QUALITY_REQUIREMENTS.yaml` — cross-cutting NFRs when enabled
- Specialist reviews: [SECURITY_REVIEWS.md](../../.awp-workspace/workspace-build/3-verify/SECURITY_REVIEWS.md), [API_CONTRACT_REVIEWS.md](../../.awp-workspace/workspace-build/3-verify/API_CONTRACT_REVIEWS.md) — see [advisor-policy.md](advisor-policy.md)

## Workflow

1. Address open items in `.awp-workspace/workspace-build/4-sync/DESIGN_INPUTS.yaml`.
2. Update specs in `docs/design/features/` and product docs as needed.
3. Add or update rows in `FEATURE_REGISTRY`, `DESIGN_STATES`, `TASK_READINESS`, `ROADMAP`.
4. Admit build tasks only when readiness gates pass (see `.awp-workspace/workspace-build/docs/optional/consistency-gates.md`).

## ADRs

Create ADRs in [decisions/](decisions/) from [../templates/ADR_TEMPLATE.md](../templates/ADR_TEMPLATE.md). Link via `decision_links` in registers (repo-relative path under `docs/design/decisions/`).
