import { useAccessStore } from '@vben/stores';

type ApiEnvelope<T> = {
  code?: number;
  data?: T;
  message?: string;
  msg?: string;
  success?: boolean;
};

const env = import.meta.env as unknown as Record<string, string | undefined>;
const baseUrl = (env.VITE_HAOKE_API_URL || 'http://localhost:8080').replace(
  /\/$/,
  '',
);

function resolveToken() {
  const token = useAccessStore().accessToken;
  if (!token || token.split('.').length !== 3) {
    return '';
  }
  return token;
}

async function request<T>(path: string, init: RequestInit = {}): Promise<T> {
  const token = resolveToken();
  const headers = new Headers(init.headers);
  headers.set('Content-Type', 'application/json;charset=utf-8');
  if (token) {
    headers.set('Authorization', `Bearer ${token}`);
  }

  const response = await fetch(`${baseUrl}${path}`, {
    ...init,
    headers,
  });

  const payload = (await response.json().catch(() => ({}))) as ApiEnvelope<T>;
  const isBusinessError =
    payload.success === false ||
    (payload.code !== undefined && payload.code !== 200);
  if (!response.ok || isBusinessError) {
    throw new Error(
      payload.msg || payload.message || `请求失败：${response.status}`,
    );
  }

  return payload.data as T;
}

export function haokeDelete<T>(path: string) {
  return request<T>(path, { method: 'DELETE' });
}

export function haokeGet<T>(path: string) {
  return request<T>(path, { method: 'GET' });
}

export function haokePost<T>(path: string, data?: unknown) {
  return request<T>(path, {
    body: JSON.stringify(data ?? {}),
    method: 'POST',
  });
}

export function haokePut<T>(path: string, data?: unknown) {
  return request<T>(path, {
    body: JSON.stringify(data ?? {}),
    method: 'PUT',
  });
}
