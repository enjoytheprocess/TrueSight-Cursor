# Vertical slices

How the TrueSight API is organized for **feature-local changes** without cross-feature coupling. Execution rules also live in [`.cursor/rules/architecture.mdc`](../../.cursor/rules/architecture.mdc).

## Why vertical slices

- **Non-functional requirement:** Clean architecture with slices so new capabilities (inventory, recipes, recognition) can be added without rewiring the whole codebase.
- Each slice owns its HTTP surface, application logic, and persistence touchpoints for that capability.
- Shared infrastructure (EF Core, auth, external adapters) stays in cross-cutting projects; **business rules stay inside the slice**.

## Slice map (committed product)

| Slice | Phase | AWP feature | Responsibility |
|-------|-------|-------------|----------------|
| **Inventory** | V1 | `FEAT-INV-001` | Manual CRUD for `InventoryItem`, catalog linkage, expiry on items |
| **Recipes** | V1 | `FEAT-REC-001` | Suggestions from stock via `RecipeProvider` adapter; ranking (see feature spec) |
| **Sessions** | V1 | `FEAT-SES-001` | `RecipeSession` — accept recipe → deduct inventory |
| **Recognition** | V2 | `FEAT-REC-002` | Fridge photo upload, vision adapter, confirm → inventory |
| **Profile** | V1.2 (design) | `FEAT-PRF-001` | Settings UI, `UserProfile`, inventory use-first, recipe filter/rank (`IDEA-002`–`004`, `IDEA-012`) |

**Build order:** Inventory → Recipes → Sessions → Recognition (Profile when promoted).

## Folder convention (API)

One folder per **action** under `Features/{Slice}/{Action}/`:

```
Features/Inventory/CreateInventoryItem/
    Command.cs
    Validator.cs
    Handler.cs
    Endpoint.cs
    Response.cs
```

- **Commands** mutate state; **queries** are read-only (CQRS via MediatR).
- **One endpoint file per action** (minimal APIs).
- Slices do not reference each other’s handlers directly — coordinate via application services or domain events only when unavoidable (prefer explicit orchestration in Sessions for deduction).

## Integration boundaries (not slices)

These are **adapters**, not feature folders:

| Boundary | Used by | Purpose |
|----------|---------|---------|
| `RecipeProvider` | Recipes | Spoonacular, Edamam, or stub — config-driven |
| `VisionService` | Recognition (V2) | Normalized `DetectedItem` from vendor vision APIs |

See [overview.md](overview.md) and ADRs under [`docs/design/decisions/`](../design/decisions/).

## Adding a new slice

1. Add feature spec under `docs/design/features/FEAT-*.md`.
2. Register in `.awp-workspace/workspace-build/1-design/FEATURE_REGISTRY.yaml`, `DESIGN_STATES.yaml`, `ROADMAP.yaml` if committed.
3. Create `Features/{Slice}/` with commands/queries/endpoints only for that capability.
4. Extend [domain model](../product/domain-model.md) if new persisted entities are required.

## Related docs

- [Architecture overview](overview.md) — system diagram and V1/V2 flows
- [Project brief](../product/project-brief.md) — delivery and constraints
- Feature specs: [FEAT-INV-001](../design/features/FEAT-INV-001-manual-inventory.md), [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md), [FEAT-SES-001](../design/features/FEAT-SES-001-recipe-acceptance-deduction.md), [FEAT-REC-002](../design/features/FEAT-REC-002-fridge-photo-recognition.md)
