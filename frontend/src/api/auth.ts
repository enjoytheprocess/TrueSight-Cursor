import { api } from './client';

export type AuthUser = {
  userId: string;
  email: string;
};

export function register(email: string, password: string) {
  return api.post<AuthUser>('/api/auth/register', { email, password });
}

export function login(email: string, password: string) {
  return api.post<AuthUser>('/api/auth/login', { email, password });
}

export function logout() {
  return api.post<void>('/api/auth/logout', {});
}

export function getCurrentUser() {
  return api.get<AuthUser>('/api/auth/me');
}
