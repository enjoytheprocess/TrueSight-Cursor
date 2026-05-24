# Use cases and scenarios

Motivating situations for TrueSight (FridgeWise). **Committed behavior** is in [roadmap.md](roadmap.md) and feature specs; this page captures **why** users care.

## Primary scenarios

### 1. At the market — “Do I already have this?”

**Situation:** The user is shopping and wonders whether they need milk, eggs, or spinach at home.

**Need:** A trustworthy inventory they can check on their phone (and desktop) before buying duplicates.

**Product response (V1+):** Manual inventory list with quantity and expiry; later, kept up to date via recipe deduction and (V2) photo-assisted updates.

**Future extension (ideation):** Missing-ingredient hints when browsing recipes; store recommendations ([IDEA-005](ideation.md#idea-005-store-recommendations-distance-price)).

---

### 2. Food waste — “Use it before it spoils”

**Situation:** Perishables expire unnoticed; throwing food away feels wasteful and costly.

**Need:** Visibility into what is in the fridge and what is expiring soon, plus recipes that **prefer ingredients that expire first**.

**Product response:**

- V1: Expiry on inventory items; recipe ranking favors soon-to-expire stock (see [FEAT-REC-001](../design/features/FEAT-REC-001-recipe-suggestions.md)).
- Ideation: Proactive expiry warnings ([IDEA-006](ideation.md#idea-006-expiry-proximity-warnings)).

**Charity angle:** Same perishability problem at scale for shared or donation kitchens — captured as persona only ([IDEA-007](ideation.md#idea-007-charity--food-bank-persona)), not MVP scope.

---

### 3. Tired — “Lower the barrier to cooking”

**Situation:** End of day, low energy; deciding what to cook feels like another chore.

**Need:** Short, realistic suggestions from **what is already on hand**, not another meal-planning project.

**Product response (V1):** Recipe suggestions matched to current inventory; accept → inventory deducted so the list stays honest.

**Future (ideation):** Filter by cooking skill and available equipment ([IDEA-004](ideation.md#idea-004-cooking-skill-level--kitchen-equipment)); shorter-time recipes weighted in ranking.

---

## End-to-end journeys (committed)

| Phase | Journey | Steps |
|-------|---------|--------|
| V1 | Cook from what you have | Add/view inventory → see suggestions → accept recipe → deduct |
| V2 | Faster inventory capture | Fridge photo → review detections → confirm → same recipe flow as V1 |

See [project-brief.md](project-brief.md) for delivery model (mobile-first web, PWA-capable).

## Plug-and-play integrations

External recipe and vision APIs are **swappable adapters** behind the API — not hard-coded into UI or domain entities. See [project-brief — Integrations](project-brief.md#integrations-plug-and-play) and recipe/vision ADRs under `docs/design/decisions/`.
