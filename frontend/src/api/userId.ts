/** Persists a stable per-browser user id for TMP-001 interim identity (ADR-20260524-01). */
export const CLIENT_USER_ID_STORAGE_KEY = 'truesight-user-id';

export function getClientUserId(): string {
  if (typeof localStorage === 'undefined') {
    return 'demo-user';
  }

  const existing = localStorage.getItem(CLIENT_USER_ID_STORAGE_KEY);
  if (existing?.trim()) {
    return existing.trim();
  }

  const id = crypto.randomUUID();
  localStorage.setItem(CLIENT_USER_ID_STORAGE_KEY, id);
  return id;
}
