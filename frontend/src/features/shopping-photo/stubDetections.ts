import { DetectedItemDraft, DetectionConfidence } from './types';

function defaultIncluded(confidence: DetectionConfidence): boolean {
  return confidence === 'high' || confidence === 'medium';
}

type StubRow = {
  name: string;
  quantity: number;
  unit: string;
  confidence: DetectionConfidence;
};

/** Stub lines inspired by the bundled product-packaging sample photo (Ferrero hazelnut chocolate). */
const STUB_ROWS: StubRow[] = [
  { name: 'Ferrero hazelnut chocolates', quantity: 1, unit: 'count', confidence: 'high' },
  { name: 'Hazelnut chocolate treats', quantity: 1, unit: 'count', confidence: 'medium' },
  { name: 'Cocoa snack pack', quantity: 1, unit: 'count', confidence: 'low' },
];

export function createShoppingStubDetections(): DetectedItemDraft[] {
  return STUB_ROWS.map((row, index) => ({
    id: `shopping-stub-${index}`,
    name: row.name,
    quantity: row.quantity,
    unit: row.unit,
    expiryDate: null,
    confidence: row.confidence,
    included: defaultIncluded(row.confidence),
  }));
}

export const PRESET_SHOPPING_PHOTO_SRC = '/mockups/shopping-preset.png';
