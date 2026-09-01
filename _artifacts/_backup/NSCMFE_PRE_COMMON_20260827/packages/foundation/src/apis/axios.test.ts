import { beforeEach, describe, expect, it, vi } from 'vitest';

import { apiClient, mockApiClient } from './axios';

describe('apiClient', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('uses expected base defaults for mock client', () => {
    expect(mockApiClient.service.defaults.baseURL).toBe('localhost:8080/api');
    expect(mockApiClient.service.defaults.withCredentials).toBe(false);
  });

  it('builds GET request options correctly', async () => {
    const requestSpy = vi.spyOn(apiClient.service, 'request').mockResolvedValue({
      data: { result: [] },
    } as never);

    await apiClient.get('/admin/message', { lang: 'KO' });

    expect(requestSpy).toHaveBeenCalledTimes(1);
    expect(requestSpy).toHaveBeenCalledWith(
      expect.objectContaining({
        method: 'GET',
        url: '/admin/message',
        params: { lang: 'KO' },
      })
    );
  });

  it('applies custom header via setHeader()', async () => {
    const requestSpy = vi.spyOn(apiClient.service, 'request').mockResolvedValue({
      data: { result: [] },
    } as never);

    await apiClient.setHeader({ 'X-Feature-Test': 'true' }).post('/admin/message', {
      payload: 1,
    });

    expect(requestSpy).toHaveBeenCalledTimes(1);
    expect(requestSpy).toHaveBeenCalledWith(
      expect.objectContaining({
        method: 'POST',
        url: '/admin/message',
        data: { payload: 1 },
        headers: expect.objectContaining({
          'X-Feature-Test': 'true',
        }),
      })
    );
  });
});
