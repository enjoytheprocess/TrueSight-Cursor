import { describe, expect, it } from 'vitest';
import { formatDate, formatQuantity, isExpiringSoon } from './formatting';
import { InventoryItem } from './types';

const baseItem: InventoryItem = {
  id: '1',
  name: 'Spinach',
  quantity: 1,
  unit: 'g',
  expiryDate: null,
  addedAt: '2026-05-01T00:00:00Z',
  updatedAt: '2026-05-01T00:00:00Z',
};

describe('isExpiringSoon', () => {
  it('returns false when expiry is missing', () => {
    expect(isExpiringSoon(baseItem, new Date('2026-05-24T12:00:00'))).toBe(false);
  });

  it('returns true when expiry is within three days', () => {
    const item = { ...baseItem, expiryDate: '2026-05-26' };
    expect(isExpiringSoon(item, new Date('2026-05-24T12:00:00'))).toBe(true);
  });

  it('returns false when expiry is more than three days away', () => {
    const item = { ...baseItem, expiryDate: '2026-06-01' };
    expect(isExpiringSoon(item, new Date('2026-05-24T12:00:00'))).toBe(false);
  });
});

describe('formatDate', () => {
  it('formats ISO date strings for display', () => {
    expect(formatDate('2026-06-01')).toMatch(/Jun/);
    expect(formatDate('2026-06-01')).toMatch(/1/);
  });
});

describe('formatQuantity', () => {
  it('limits fractional digits', () => {
    expect(formatQuantity(2.5)).toBe('2.5');
    expect(formatQuantity(2.555)).toBe('2.56');
  });
});
