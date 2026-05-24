import { DetectedItemDraft, DetectionConfidence } from './types';

function addDaysFromToday(days: number): string {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return date.toISOString().slice(0, 10);
}

function defaultIncluded(confidence: DetectionConfidence): boolean {
  return confidence === 'high' || confidence === 'medium';
}

type StubRow = {
  name: string;
  quantity: number;
  unit: string;
  expiryDays: number;
  confidence: DetectionConfidence;
};

const STUB_ROWS: StubRow[] = [
  { name: 'Eggs', quantity: 12, unit: 'count', expiryDays: 14, confidence: 'high' },
  { name: 'Cheddar cheese', quantity: 1, unit: 'count', expiryDays: 21, confidence: 'high' },
  { name: 'Butter', quantity: 1, unit: 'count', expiryDays: 30, confidence: 'medium' },
  { name: 'Ground beef', quantity: 1, unit: 'count', expiryDays: 3, confidence: 'medium' },
  { name: 'Salmon fillet', quantity: 1, unit: 'count', expiryDays: 2, confidence: 'medium' },
  { name: 'Green beans', quantity: 1, unit: 'count', expiryDays: 5, confidence: 'low' },
];

export function createStubDetections(): DetectedItemDraft[] {
  return STUB_ROWS.map((row, index) => ({
    id: `stub-${index}`,
    name: row.name,
    quantity: row.quantity,
    unit: row.unit,
    expiryDate: addDaysFromToday(row.expiryDays),
    confidence: row.confidence,
    included: defaultIncluded(row.confidence),
  }));
}

export const PRESET_FRIDGE_PHOTO_SRC = '/mockups/fridge-preset.jpg';
