export const API_CONFIG = {
  BASE_URL: import.meta.env.DEV
    ? import.meta.env.VITE_PROXY_BASE_URL
    : import.meta.env.VITE_API_BASE_URL || '',
  TIMEOUT: Number(import.meta.env.VITE_API_TIMEOUT || '300000'),
  WITH_CREDENTIALS: true,
  DEFAULT_HEADERS: {
    'Content-Type': 'application/json',
  } as Record<string, string>,
  CACHE_UPDATE_MODE: true,
} as const;

export enum HTTP_STATUS {
  OK = 200,
}
