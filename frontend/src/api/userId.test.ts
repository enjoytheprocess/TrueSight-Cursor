import { afterEach, beforeEach, describe, expect, it } from 'vitest';
import {
  CLIENT_USER_ID_STORAGE_KEY,
  DEMO_USER_ID,
  enterDemoUser,
  getClientUserId,
  hasClientUserId,
} from './userId';

describe('userId', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  afterEach(() => {
    localStorage.clear();
  });

  it('hasClientUserId is false when storage is empty', () => {
    expect(hasClientUserId()).toBe(false);
  });

  it('enterDemoUser stores demo-user', () => {
    enterDemoUser();

    expect(hasClientUserId()).toBe(true);
    expect(localStorage.getItem(CLIENT_USER_ID_STORAGE_KEY)).toBe(DEMO_USER_ID);
    expect(getClientUserId()).toBe(DEMO_USER_ID);
  });

  it('getClientUserId reuses a stored id', () => {
    localStorage.setItem(CLIENT_USER_ID_STORAGE_KEY, 'existing-user-id');

    expect(getClientUserId()).toBe('existing-user-id');
  });
});
