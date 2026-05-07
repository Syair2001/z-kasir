// lib/auth.ts
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

export interface AuthTokens {
  access: string;
  refresh: string;
}

export const login = async (username: string, password: string) => {
  const res = await fetch(`${API_URL}/api/token/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  });

  if (!res.ok) throw new Error('Login gagal');

  const data: AuthTokens = await res.json();
  localStorage.setItem('access_token', data.access);
  localStorage.setItem('refresh_token', data.refresh);
  return data;
};

export const refreshToken = async () => {
  const refresh = localStorage.getItem('refresh_token');
  if (!refresh) throw new Error('No refresh token');

  const res = await fetch(`${API_URL}/api/token/refresh/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refresh }),
  });

  if (!res.ok) throw new Error('Refresh token failed');

  const data: { access: string } = await res.json();
  localStorage.setItem('access_token', data.access);
  return data.access;
};

export const logout = () => {
  localStorage.removeItem('access_token');
  localStorage.removeItem('refresh_token');
  window.location.href = '/login';
};

export const getAccessToken = () => localStorage.getItem('access_token');

export const fetchWithAuth = async (url: string, options: RequestInit = {}) => {
  let token = getAccessToken();

  const config: RequestInit = {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...options.headers,
    },
  };

  let response = await fetch(url, config);

  // Token expired → coba refresh
  if (response.status === 401) {
    try {
      token = await refreshToken();
      config.headers = {
        ...config.headers,
        Authorization: `Bearer ${token}`,
      };
      response = await fetch(url, config);
    } catch {
      logout();
      throw new Error('Session expired');
    }
  }

  return response;
};