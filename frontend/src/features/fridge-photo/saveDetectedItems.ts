import { InventoryInput } from '../inventory/types';
import { DetectedItemDraft } from './types';

export async function saveDetectedItems(
  rows: DetectedItemDraft[],
  postItem: (input: InventoryInput) => Promise<unknown>,
): Promise<void> {
  const toSave = rows.filter((row) => row.included && row.quantity >= 1);

  for (const row of toSave) {
    await postItem({
      name: row.name,
      quantity: Math.round(row.quantity),
      unit: row.unit,
      expiryDate: row.expiryDate || null,
    });
  }
}

export function canSaveDetections(rows: DetectedItemDraft[]): boolean {
  const included = rows.filter((row) => row.included);
  if (included.length === 0) {
    return false;
  }

  return included.every((row) => row.quantity >= 1);
}
