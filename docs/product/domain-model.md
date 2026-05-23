# Domain Model

## Core Entities

### IngredientCatalog
Global reference list of ingredients (name, category, unit of measure)

### InventoryItem
A user's instance of an ingredient in their fridge
- quantity, unit, expiry date, date added

### Recipe
- name, description, cuisine type, difficulty level
- required ingredients with quantities
- estimated cooking time, serving size

### RecipeIngredient
Junction between Recipe and IngredientCatalog (quantity, unit, optional flag)

### UserProfile
- dietary restrictions
- cuisine preferences
- cooking ability (beginner / intermediate / advanced)
- available kitchen equipment

*(Planned domain shape — promote from [ideation](ideation.md) IDEA-003 / IDEA-004 before V1 build depends on it.)*

### RecipeSession
When a user accepts a recipe — triggers inventory deduction
- selected recipe, serving multiplier, timestamp

## Key Relationships
- UserProfile → many InventoryItems
- Recipe → many RecipeIngredients
- RecipeSession → deducts InventoryItems