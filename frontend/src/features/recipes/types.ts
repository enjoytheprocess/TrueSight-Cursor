export type RecipeSuggestion = {
  id: string;
  name: string;
  description: string;
  cuisineType: string;
  difficulty: string;
  estimatedMinutes: number;
  servings: number;
  ownedIngredientCount: number;
  missingIngredientCount: number;
  expiringSoonIngredientCount: number;
  score: number;
  usesIngredients: string[];
  missingIngredients: string[];
};

export type RecipeSession = {
  id: string;
  recipeId: string;
  recipeName: string;
  servingMultiplier: number;
  acceptedAt: string;
  lines: Array<{
    ingredientName: string;
    quantityDeducted: number;
    unit: string;
  }>;
};

