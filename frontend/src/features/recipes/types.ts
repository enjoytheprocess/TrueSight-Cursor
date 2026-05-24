export type RecipeIngredientLine = {
  name: string;
  requiredQuantity: number;
  unit: string;
  inStockQuantity: number;
  status: 'sufficient' | 'short' | 'missing';
};

export type RecipeSuggestion = {
  id: string;
  name: string;
  description: string;
  cuisineType: string;
  difficulty: string;
  estimatedMinutes: number;
  servings: number;
  canCook: boolean;
  ingredients: RecipeIngredientLine[];
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
