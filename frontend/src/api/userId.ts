/** Persists a stable per-browser user id for TMP-001 interim identity (ADR-20260524-01). */
export const CLIENT_USER_ID_STORAGE_KEY = 'truesight-user-id';
export const DEMO_USER_ID = 'demo-user';

export function hasClientUserId(): boolean {
  if (typeof localStorage === 'undefined') {
    return false;
  }

  return Boolean(localStorage.getItem(CLIENT_USER_ID_STORAGE_KEY)?.trim());
}

export function getClientUserId(): string {
  if (typeof localStorage === 'undefined') {
    return DEMO_USER_ID;
  }

  const existing = localStorage.getItem(CLIENT_USER_ID_STORAGE_KEY);
  if (existing?.trim()) {
    return existing.trim();
  }

  return DEMO_USER_ID;
}

export function enterDemoUser(): void {
  localStorage.setItem(CLIENT_USER_ID_STORAGE_KEY, DEMO_USER_ID);
}
