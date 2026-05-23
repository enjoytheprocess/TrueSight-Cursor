# backend

Seeded by `make init`.

## Current phase
- Phase: design
- Primary objective: define the first implementation slice for TrueSight
- Completion criteria: linked task reaches `ready_for_build` with updated traceability and validation

## Scope
- In scope: the first feature slice assigned to this component
- Out of scope: later milestones and unrelated refactors

## Interfaces and contracts
- Upstream dependencies: fill in when known
- Downstream consumers: fill in when known
- Key interfaces *(annotate each with `stable | beta | internal` — changing a `stable` interface requires `advisor_track: api_contract`)*:
  - example: `POST /api/resource` — stable

## Setup
```bash
# install dependencies
```

## Run
```bash
# start component
```

## Verify
```bash
# run tests/checks
```

## Required environment variables
- `EXAMPLE_ENV`:

## Links
- Design docs index: docs/README.md
- Project brief: docs/product/project-brief.md
- Product roadmap: docs/product/roadmap.md
- AWP roadmap: .awp-workspace/1-design/ROADMAP.md
- Work queue: .awp-workspace/2-build/WORK_QUEUE.md
- Design docs:
- ADRs:

## Operational contract *(fill in before production deployment)*

- **SLO target**: (e.g., 99.9% availability, p99 latency < 500 ms)
- **Key health metric**: (the single metric that best signals this component is healthy)
- **Where to look when it breaks**: (log location, dashboard link, or alert name)
- **Rollback procedure**: (steps to revert to the previous version)
- **Escalation path**: (who to contact and how)
