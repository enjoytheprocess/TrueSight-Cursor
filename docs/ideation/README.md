# Stage 0 — Ideation

Exploratory work **before** committing to design or the [product roadmap](../product/roadmap.md).

## When to use

- Problem framing or feature direction is still uncertain
- Multiple options are being explored
- An idea is worth capturing but not ready for design

Skip ideation when the feature is already clear enough to go straight to [design](../design/README.md).

## Artifacts

| Artifact | Location | Role |
|----------|----------|------|
| Ideation index (human) | [../product/ideation.md](../product/ideation.md) | Themed wishlist, discussion, promotion checklist |
| Ideation register (canonical) | [`.awp-workspace/0-ideation/IDEATION_BACKLOG.yaml`](../../.awp-workspace/0-ideation/IDEATION_BACKLOG.yaml) | Machine-readable state |
| Generated view | `.awp-workspace/0-ideation/IDEATION_BACKLOG.md` | Read-only; run `make awp-render` |

## Workflow

1. Capture the idea in `ideation.md` (new IDEA-xxx section) and `IDEATION_BACKLOG.yaml`.
2. Set `depends_on` (IDEA-*, FEAT-*, or CAP-* ids). See [Dependencies and sequencing](../product/ideation.md#dependencies-and-sequencing) in `ideation.md`.
3. Discuss; append notes under **Discussion** in `ideation.md` and the YAML `discussion` field.
4. Decide: `promoted` | `parked` | `dropped`.
5. On **promoted**: update [roadmap](../product/roadmap.md), `.awp-workspace/1-design/ROADMAP.yaml`, `DESIGN_STATES.yaml`, and create a feature spec under [../design/features/](../design/features/).

## Templates

- Markdown scaffold: [../templates/IDEA_ENTRY_TEMPLATE.md](../templates/IDEA_ENTRY_TEMPLATE.md)
- YAML entry: [../templates/IDEA_ENTRY_TEMPLATE.yaml](../templates/IDEA_ENTRY_TEMPLATE.yaml)
