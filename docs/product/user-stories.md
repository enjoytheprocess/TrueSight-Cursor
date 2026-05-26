# User stories

Stories tied to the [committed roadmap](roadmap.md). Exploratory stories live under [Ideation](ideation.md).

## Cross-cutting (all phases)

### Platform

- As a user, I can use the app comfortably on my phone and on a desktop browser with the same core flows

## Phase 1 — Core (V1)

### Identity

- As a user, I can sign up and sign in so my inventory is private to me *(deferred — real auth)*
- As a visitor, I can tap **Enter Demo** on the login screen to try the app as the demo user without signing up *(interim — [FEAT-AUTH-001](../design/features/FEAT-AUTH-001-demo-login-screen.md), TMP-001)*

### Inventory

- As a user, I can add an ingredient with quantity and expiry date
- As a user, I can view my current inventory list
- As a user, I can edit or remove inventory items

### Recipes

- As a user, I see recipes I can make with what I currently have
- As a user, accepting a recipe automatically deducts used ingredients

## Phase 2 — Smart input (V2)

### Inventory

- As a user, I can photograph my fridge and have ingredients detected automatically
- As a user, I can review, edit, or discard detected items before they are saved to my inventory

## V1.2 profile (design — [FEAT-PRF-001](../design/features/FEAT-PRF-001-user-profile-and-settings.md))

Not build-admitted; on roadmap as design-only until promoted.

- As a user, I open **Settings** from the main header to manage diet, allergies, cuisines, skill, equipment, and use-up preferences
- As a user, I set **dietary restrictions and allergens** so unsafe recipes never appear in suggestions
- As a user, I mark **In Stock** items as **use first** so recipes using them rank higher
- As a user, I can turn off automatic **prioritize expiring** ranking while keeping expiry highlights on inventory rows

## Ideation (not committed)

Tracked in [ideation.md](ideation.md) (active IDEA-001, 005–009, 013–017; archived 002–004, 011–012). Examples:

- As a food-bank volunteer, I can track shared fridge inventory for beneficiaries *(IDEA-007)*
- As a user, I receive a warning when items are close to expiry *(IDEA-006)*
- As a user, I can filter recipes by cuisine type and dietary restrictions *(IDEA-002, IDEA-003)*
- As a user, I can adjust serving size and see scaled ingredient amounts *(IDEA-001)*
- As a user, I can set dietary restrictions, cooking skill level, and kitchen equipment *(IDEA-003, IDEA-004)*
- As a user, I can photograph a receipt and get a suggested inventory list *(IDEA-008)*

- As a user, I can switch between **In Stock** and **Shopping List**, move purchased items into stock, and use a recipe pager *(IDEA-011 — P4 parked; deferred behind V2 photo design)*

Promote to this file under V1/V2 only after the idea is on the roadmap.
