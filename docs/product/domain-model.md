# Domain Model

V1 entities are required for Phase 1 build. Shapes marked **planned (V2+)** or **ideation** are documented for alignment but are not implied in the V1 schema until promoted.

## Core Entities (V1)

### IngredientCatalog

Global reference list of ingredients (name, category, unit of measure).

### InventoryItem

A user's instance of an ingredient in their fridge.

- quantity, unit, expiry date, date added

### Recipe

- name, description, cuisine type, difficulty level
- required ingredients with quantities
- estimated cooking time, serving size

May be sourced from an external catalog via **RecipeProvider** (integration boundary — not a persisted domain entity).

### RecipeIngredient

Junction between Recipe and IngredientCatalog (quantity, unit, optional flag).

### RecipeSession

When a user accepts a recipe — triggers inventory deduction.

- selected recipe, serving multiplier, timestamp

## Integration boundary

### RecipeProvider (adapter, not persisted)

Abstraction for plug-and-play recipe data (Spoonacular, Edamam, custom). The API selects an implementation via configuration. No vendor-specific types in core entities. See [ADR-20260523-02-recipe-provider-adapter.md](../design/decisions/ADR-20260523-02-recipe-provider-adapter.md).

## Planned entities (V2+ / ideation — not V1 schema)

### UserProfile

- dietary restrictions
- cuisine preferences
- cooking ability (beginner / intermediate / advanced)
- available kitchen equipment

**Status:** Ideation-dependent — promote from [ideation](ideation.md) IDEA-003 / IDEA-004 before any V1 build depends on profile filtering.

### DetectedItem (V2 fridge recognition)

Transient detection result before user confirmation.

- suggested name, quantity estimate, confidence
- links to `InventoryItem` after user confirms

### ReceiptScan (ideation — IDEA-008)

Receipt photo upload and parsed line items (names, quantities, suggested expiry). Not on committed roadmap.

### DetectedLineItem

Child of ReceiptScan: item name, quantity, optional image reference, suggested expiry.

## Key Relationships

- UserProfile → many InventoryItems *(when profile ships)*
- Recipe → many RecipeIngredients
- RecipeSession → deducts InventoryItems
- ReceiptScan → many DetectedLineItems *(planned)*
