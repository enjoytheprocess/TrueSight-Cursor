export type ShoppingListInput = {
  name: string;
  quantity: number;
  unit: string;
  sourceRecipeId?: string | null;
};

export type ShoppingListItem = {
  id: string;
  name: string;
  quantity: number;
  unit: string;
  sourceRecipeId: string | null;
  createdAt: string;
};
