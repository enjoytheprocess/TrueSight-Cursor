import { describe, expect, it, vi } from 'vitest';
import { canSaveDetections, saveDetectedItems } from './saveDetectedItems';
import { DetectedItemDraft } from './types';

function row(partial: Partial<DetectedItemDraft> & Pick<DetectedItemDraft, 'id' | 'name'>): DetectedItemDraft {
  return {
    quantity: 1,
    unit: 'count',
    expiryDate: null,
    confidence: 'high',
    included: true,
    ...partial,
  };
}

describe('saveDetectedItems', () => {
  it('posts only included rows with quantity at least 1', async () => {
    const post = vi.fn().mockResolvedValue({});
    const rows: DetectedItemDraft[] = [
      row({ id: '1', name: 'Eggs', included: true, quantity: 6 }),
      row({ id: '2', name: 'Lettuce', included: false, quantity: 1 }),
      row({ id: '3', name: 'Milk', included: true, quantity: 0 }),
    ];

    await saveDetectedItems(rows, post);

    expect(post).toHaveBeenCalledTimes(1);
    expect(post).toHaveBeenCalledWith({
      name: 'Eggs',
      quantity: 6,
      unit: 'count',
      expiryDate: null,
    });
  });

  it('fails all-or-nothing when a post throws', async () => {
    const post = vi
      .fn()
      .mockResolvedValueOnce({})
      .mockRejectedValueOnce(new Error('Server error'));

    await expect(
      saveDetectedItems(
        [
          row({ id: '1', name: 'Eggs' }),
          row({ id: '2', name: 'Milk' }),
        ],
        post,
      ),
    ).rejects.toThrow('Server error');

    expect(post).toHaveBeenCalledTimes(2);
  });
});

describe('canSaveDetections', () => {
  it('returns false when nothing is included', () => {
    expect(canSaveDetections([row({ id: '1', name: 'Eggs', included: false })])).toBe(false);
  });

  it('returns false when an included row has quantity below 1', () => {
    expect(canSaveDetections([row({ id: '1', name: 'Eggs', included: true, quantity: 0 })])).toBe(false);
  });

  it('returns true when at least one included row has quantity at least 1', () => {
    expect(canSaveDetections([row({ id: '1', name: 'Eggs', included: true, quantity: 2 })])).toBe(true);
  });
});
