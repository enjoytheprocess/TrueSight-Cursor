import { canSaveDetections } from '../fridge-photo/saveDetectedItems';
import { ShoppingListInput } from '../shopping-list/types';
import { DetectedItemDraft } from './types';

export { canSaveDetections };

export async function saveDetectedShoppingItems(
  rows: DetectedItemDraft[],
  postItem: (input: ShoppingListInput) => Promise<unknown>,
): Promise<void> {
  const toSave = rows.filter((row) => row.included && row.quantity >= 1);

  for (const row of toSave) {
    await postItem({
      name: row.name.trim(),
      quantity: Math.round(row.quantity),
      unit: row.unit,
      sourceRecipeId: null,
    });
  }
}
