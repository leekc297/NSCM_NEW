// @vitest-environment jsdom

import { act, renderHook, waitFor } from '@testing-library/react';
import type { ReactNode } from 'react';
import { beforeEach, describe, expect, it, vi } from 'vitest';

import { TabIdContext } from '@shared/stores/createStore';

const { postMock } = vi.hoisted(() => ({
  postMock: vi.fn(),
}));

vi.mock('@foundation/apis', () => ({
  apiClient: {
    post: postMock,
  },
}));

import { MENU_ID, SHEETS } from './message-management.constants';
import { useMessageManagementStore } from './useMessageManagementStore';

let tabSeq = 0;

const createWrapper = () => {
  tabSeq += 1;
  const tabId = `test-tab-${tabSeq}`;

  return ({ children }: { children: ReactNode }) => (
    <TabIdContext.Provider value={tabId}>{children}</TabIdContext.Provider>
  );
};

describe('useMessageManagementStore', () => {
  beforeEach(() => {
    postMock.mockReset();
    sessionStorage.clear();
  });

  it('has expected initial state', () => {
    const { result } = renderHook(() => useMessageManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    expect(result.current.initialized).toBe(false);
    expect(result.current.filters).toBeUndefined();
    expect(result.current.searchParams).toStrictEqual({
      messageType: 'ALL',
      message: '',
      useYn: 'Y',
    });
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.isOpenSearchArea).toBe(true);
  });

  it('setSearchParams merges partial values', () => {
    const { result } = renderHook(() => useMessageManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    act(() => {
      result.current.setSearchParams({ message: 'hello' });
    });

    expect(result.current.searchParams).toStrictEqual({
      messageType: 'ALL',
      message: 'hello',
      useYn: 'Y',
    });
  });

  it('setFilters copies current searchParams into filters', () => {
    const { result } = renderHook(() => useMessageManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    act(() => {
      result.current.setSearchParams({ messageType: 'WARN', message: 'foo', useYn: 'N' });
      result.current.setFilters();
    });

    expect(result.current.filters).toStrictEqual({
      messageType: 'WARN',
      message: 'foo',
      useYn: 'N',
    });
  });

  it('setOpenSearchArea toggles and supports explicit value', () => {
    const { result } = renderHook(() => useMessageManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    expect(result.current.isOpenSearchArea).toBe(true);

    act(() => {
      result.current.setOpenSearchArea();
    });
    expect(result.current.isOpenSearchArea).toBe(false);

    act(() => {
      result.current.setOpenSearchArea(true);
    });
    expect(result.current.isOpenSearchArea).toBe(true);
  });

  it('fetchStaticColumns calls API and stores returned columns', async () => {
    const mockColumns = [{ key: 'MESSAGE_ID', header: 'Message ID' }];
    postMock.mockResolvedValue({ data: { result: mockColumns } });

    const { result } = renderHook(() => useMessageManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    act(() => {
      result.current.fetchStaticColumns();
    });

    expect(postMock).toHaveBeenCalledWith(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: SHEETS.MSG_MGMT,
    });

    await waitFor(() => {
      expect(result.current.staticColumns).toStrictEqual(mockColumns);
    });
  });
});
