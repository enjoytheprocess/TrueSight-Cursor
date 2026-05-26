# Interface Contracts

**Trigger**: Add this module when two or more people are building in parallel against shared boundaries — API shapes, auth methods, data models, event formats — that were not fully specified in the design merge. Without it, each person's agent makes independent assumptions that only surface as integration failures at the merge ceremony.

Do not create this file speculatively. If your team is small, working sequentially, or designs are detailed enough to leave no interface ambiguity, you do not need it.

## Files

| File | Role |
|------|------|
| `1-design/CONTRACTS.yaml` | Active interface contracts agreed at a design merge |
| `templates/init/1-design/INIT_CONTRACTS_TEMPLATE.yaml` | Template — copy and rename to instantiate |

## How to instantiate

At your first design merge session, copy the template:

```bash
cp templates/init/1-design/INIT_CONTRACTS_TEMPLATE.yaml 1-design/CONTRACTS.yaml
```

Then populate it during the merge meeting before anyone branches for Build.

## What belongs here

A contract entry captures the minimum an agent needs to build against a shared boundary without making assumptions:

- Which component or person **produces** the interface
- Which components or people **consume** it
- The agreed **shape** (endpoint path, field names, types, auth format)
- **Status**: `draft` (discussed but not final), `agreed` (settled), `disputed` (conflict not yet resolved)

Keep entries minimal. A one-line `shape` field is better than a full schema — the goal is to prevent silent divergence, not to replace proper API docs.

## Agent read path

When working in a split workspace, agents should read `1-design/CONTRACTS.yaml` before starting any Build task that touches a shared boundary. If a contract entry is `draft` or missing for an interface your task depends on, record a deferred finding in `3-verify/GAPS_AND_DEVIATIONS.yaml` rather than assuming. See `docs/guides/distributed-teams.md` for the deferred finding convention.

## Lifecycle

- Created at the first design merge where interface ambiguity exists
- Updated at subsequent design merges as contracts are settled or revised
- Entries move to `agreed` once both producer and consumer have built against them and verified
- The file is not archived — it stays live as long as the interfaces exist
