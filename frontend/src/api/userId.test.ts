import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { CLIENT_USER_ID_STORAGE_KEY, getClientUserId } from './userId';

describe('getClientUserId', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.stubGlobal('crypto', { randomUUID: () => '11111111-2222-4333-8444-555555555555' });
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('creates and stores a new id when none exists', () => {
    expect(getClientUserId()).toBe('11111111-2222-4333-8444-555555555555');
    expect(localStorage.getItem(CLIENT_USER_ID_STORAGE_KEY)).toBe('11111111-2222-4333-8444-555555555555');
  });

  it('reuses the stored id on subsequent calls', () => {
    localStorage.setItem(CLIENT_USER_ID_STORAGE_KEY, 'existing-user-id');

    expect(getClientUserId()).toBe('existing-user-id');
  });
});
