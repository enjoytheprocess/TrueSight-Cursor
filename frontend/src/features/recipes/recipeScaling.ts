import { RecipeIngredientLine, RecipeSuggestion } from './types';

export function servingMultiplierFor(recipe: RecipeSuggestion, selectedServings: number) {
  return Math.max(1, Math.min(12, Math.round(selectedServings / recipe.servings)));
}

export function scaledRequiredQuantity(line: RecipeIngredientLine, servingMultiplier: number) {
  return line.requiredQuantity * servingMultiplier;
}

export function isIngredientShort(line: RecipeIngredientLine, servingMultiplier: number) {
  return line.inStockQuantity < scaledRequiredQuantity(line, servingMultiplier);
}

export function canCookAtServings(recipe: RecipeSuggestion, servingMultiplier: number) {
  return (
    recipe.ingredients.length > 0 &&
    recipe.ingredients.every((line) => !isIngredientShort(line, servingMultiplier))
  );
}
