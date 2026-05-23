# Product ideation

Exploratory ideas **not** committed on the [roadmap](roadmap.md). Workflow: [../ideation/README.md](../ideation/README.md).

Register (canonical YAML): [`.awp-workspace/0-ideation/IDEATION_BACKLOG.yaml`](../../.awp-workspace/0-ideation/IDEATION_BACKLOG.yaml).

**Status:** `open` → discuss → `promoted` (enters design/roadmap) | `parked` | `dropped`

---

## Index

| ID | Title | Theme | Status |
|----|-------|-------|--------|
| IDEA-001 | Serving size selector | Recipes & UX | open |
| IDEA-002 | Cuisine preferences & discovery mode | Recipes & UX | open |
| IDEA-003 | Dietary restrictions & allergy filtering | Profile | open |
| IDEA-004 | Cooking skill level & kitchen equipment | Profile | open |
| IDEA-005 | Store recommendations (distance, price) | Commerce | open |
| IDEA-006 | Expiry proximity warnings | Inventory | open |

---

## Recipes & UX

### IDEA-001: Serving size selector

**Status:** open  
**Summary:** Let users choose how many people they are cooking for and scale ingredient amounts on recipes accordingly.

**Discussion**

- Overlaps partially with V1 recipe display — clarify minimum V1 behavior vs this enhancement.
- Affects `RecipeSession` serving multiplier in the domain model.

**Outcome:** —

---

### IDEA-002: Cuisine preferences & discovery mode

**Status:** open  
**Summary:** Filter and browse recipes by cuisine type; optional “discovery” browsing beyond strict inventory match.

**Discussion**

- V1 may ship a minimal filter; full discovery mode stays ideation until scoped.

**Outcome:** —

---

## Profile & personalization

### IDEA-003: Dietary restrictions & allergy filtering

**Status:** open  
**Summary:** Vegan, gluten-free, allergies, etc. filter all recipe suggestions globally.

**Discussion**

- `UserProfile` exists in the domain model; not in V1 roadmap — promote when profile slice is scheduled.

**Outcome:** —

---

### IDEA-004: Cooking skill level & kitchen equipment

**Status:** open  
**Summary:** Match recipes to beginner/intermediate/advanced skill and available equipment (oven, air fryer, …).

**Discussion**

- Pairs with IDEA-003 as a “profile” epic if promoted together.

**Outcome:** —

---

## Inventory

### IDEA-006: Expiry proximity warnings

**Status:** open  
**Summary:** Notify users when items are close to expiry so they can use them before waste.

**Discussion**

- Could be a small V1 add-on or post-V1; not listed on committed roadmap yet.

**Outcome:** —

---

## Commerce & external

### IDEA-005: Store recommendations (distance, price)

**Status:** open  
**Summary:** Suggest where to buy missing ingredients using distance and price comparison.

**Discussion**

- External integrations, privacy, and data sourcing need a spike before promotion.

**Outcome:** —

---

## Promotion checklist

When moving an idea to **promoted**:

1. Add capability or feature to [roadmap.md](roadmap.md) and `.awp-workspace/1-design/ROADMAP.yaml`
2. Add user stories to [user-stories.md](user-stories.md) under the right phase
3. Create `docs/design/features/FEAT-*.md` and register rows (see `.cursor/snippets/awp-admit-task.md`)
4. Move YAML entry to `.awp-workspace/0-ideation/archive/IDEATION_BACKLOG.yaml` with `decision: promoted`
