# ADR-20260523-02: Recipe data via provider adapter

**Date:** 2026-05-23  
**Status:** Accepted  
**Classification:** High-Level Design

## Context

- Recipe data can come from third-party APIs (e.g. Spoonacular, Edamam) or a custom catalog.
- Vendor schemas and pricing change; the core domain should stay stable.
- The product needs “plug and play” switching without rewriting inventory or session logic.

## Decision

Introduce a **RecipeProvider** abstraction in the API layer. Configuration (environment or options) selects the implementation: Spoonacular, Edamam, or custom/static. The domain model uses normalized `Recipe` / `RecipeIngredient` shapes (or DTOs) produced by the adapter, not vendor-specific types.

## Consequences

### Positive

- Swap or combine providers without changing inventory or deduction flows.
- Easier testing with a fake or fixture provider.

### Negative

- Mapping and rate-limit handling are provider-specific.
- Multiple providers may need harmonization for consistent UX (images, units, nutrition).

## AWP follow-up

- Reference in feature spec [FEAT-REC-001](../features/FEAT-REC-001-recipe-suggestions.md).
- Add `decision_links` on recipe-related design states when features are admitted to build.

## References

- [Domain model — RecipeProvider](../../product/domain-model.md)
- [Architecture overview](../../architecture/overview.md)
