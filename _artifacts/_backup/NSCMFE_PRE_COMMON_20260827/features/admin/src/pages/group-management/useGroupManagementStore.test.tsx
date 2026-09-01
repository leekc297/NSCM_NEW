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

import { MENU_ID, SHEETS } from './group-management.constants';
import { useGroupManagementStore } from './useGroupManagementStore';

let tabSeq = 0;

const createWrapper = () => {
  tabSeq += 1;
  const tabId = `test-tab-${tabSeq}`;

  return ({ children }: { children: ReactNode }) => (
    <TabIdContext.Provider value={tabId}>{children}</TabIdContext.Provider>
  );
};

describe('useGroupManagementStore', () => {
  beforeEach(() => {
    postMock.mockReset();
    sessionStorage.clear();
  });

  it('has expected initial state', () => {
    const { result } = renderHook(() => useGroupManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    expect(result.current.loading).toBe(false);
    expect(result.current.filters).toBeUndefined();
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.isOpenSearchArea).toBe(true);
  });

  it('setFilters copies current searchParams into filters', () => {
    const { result } = renderHook(() => useGroupManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    act(() => {
      result.current.setFilters({ group: 'GRP-02', useYn: 'N' });
    });

    expect(result.current.filters).toStrictEqual({
      group: 'GRP-02',
      useYn: 'N',
    });
  });

  it('setOpenSearchArea toggles and supports explicit value', () => {
    const { result } = renderHook(() => useGroupManagementStore(s => s), {
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
    const mockColumns = [{ key: 'GROUP', header: 'Group' }];
    postMock.mockResolvedValue({ data: { result: mockColumns } });

    const { result } = renderHook(() => useGroupManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    act(() => {
      result.current.fetchStaticColumns();
    });

    expect(postMock).toHaveBeenCalledWith(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: SHEETS.GROUP_MGMT,
    });

    await waitFor(() => {
      expect(result.current.staticColumns).toStrictEqual(mockColumns);
    });
  });

  it('reset restores initial state', () => {
    const { result } = renderHook(() => useGroupManagementStore(s => s), {
      wrapper: createWrapper(),
    });

    act(() => {
      result.current.setFilters({ group: 'GRP-99', useYn: 'N' });
      result.current.setOpenSearchArea(false);
      result.current.reset();
    });

    expect(result.current.filters).toStrictEqual(undefined);
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.isOpenSearchArea).toBe(true);
  });
});
