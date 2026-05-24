import { describe, expect, it } from 'vitest';
import { canCookAtServings, isIngredientShort, scaledRequiredQuantity, servingMultiplierFor } from './recipeScaling';
import { RecipeSuggestion } from './types';

const baseRecipe: RecipeSuggestion = {
  id: 'test',
  name: 'Test',
  description: '',
  cuisineType: 'Everyday',
  difficulty: 'Easy',
  estimatedMinutes: 10,
  servings: 2,
  canCook: true,
  ingredients: [
    {
      name: 'eggs',
      requiredQuantity: 2,
      unit: 'count',
      inStockQuantity: 4,
      status: 'sufficient',
    },
    {
      name: 'chicken',
      requiredQuantity: 300,
      unit: 'g',
      inStockQuantity: 100,
      status: 'short',
    },
  ],
  missingIngredientCount: 1,
  ownedIngredientCount: 1,
  expiringSoonIngredientCount: 0,
  score: 1,
  usesIngredients: [],
  missingIngredients: [],
};

describe('recipeScaling', () => {
  it('computes serving multiplier from selected servings', () => {
    expect(servingMultiplierFor(baseRecipe, 2)).toBe(1);
    expect(servingMultiplierFor(baseRecipe, 4)).toBe(2);
  });

  it('scales required quantities', () => {
    expect(scaledRequiredQuantity(baseRecipe.ingredients[0], 2)).toBe(4);
  });

  it('detects short ingredients at scale', () => {
    expect(isIngredientShort(baseRecipe.ingredients[1], 1)).toBe(true);
    expect(canCookAtServings(baseRecipe, 1)).toBe(false);
    expect(canCookAtServings(baseRecipe, 2)).toBe(false);
  });
});
