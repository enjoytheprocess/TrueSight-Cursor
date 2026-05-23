# Feature Slice Template

Create the durable design spec at `docs/design/features/FEAT-[name].md` using `docs/templates/FEATURE_SPEC_TEMPLATE.md`, then admit via `.cursor/snippets/awp-admit-task.md`.

## Feature: [Name]
**Module:** Inventory | Recipes | Recognition | Profile | Sessions

### User Story
As a [user], I want to [action] so that [benefit].

### Entities Involved
- [ ] List affected domain entities

### API Endpoints
- `GET /api/[resource]`
- `POST /api/[resource]`

### Inventory Impact
- Does this feature read inventory? Y/N
- Does this feature write/deduct inventory? Y/N

### Tests Required
- [ ] Unit: business logic
- [ ] Integration: API + DB
- [ ] UI: happy path + empty state