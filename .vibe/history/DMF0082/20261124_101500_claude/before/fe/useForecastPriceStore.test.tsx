// @vitest-environment jsdom

import { act, renderHook, waitFor } from '@testing-library/react';
import { beforeEach, describe, expect, it, vi } from 'vitest';

const { postMock } = vi.hoisted(() => ({
  postMock: vi.fn(),
}));

vi.mock('@foundation/apis', () => ({
  apiClient: {
    post: postMock,
  },
}));

vi.mock('@shared/stores', async () => {
  const { createStore, useStore } = await import('zustand');
  const { immer } = await import('zustand/middleware/immer');

  return {
    useSessionStore: {
      getState: () => ({ session: { div: '40', userId: 'TEST_USER' } }),
    },
    createPersistedStoreWithTab: <T extends object>(stateCreator: unknown, storageName: string) => {
      const storeRegistry = new Map<string, unknown>();

      return <U,>(selector: (state: T) => U) => {
        if (typeof stateCreator !== 'function') {
          throw new TypeError('stateCreator must be a function');
        }

        const tabId = 'test-tab';
        const storeKey = `${storageName}-${tabId}`;

        const existingStore = storeRegistry.get(storeKey);
        if (existingStore) {
          return useStore(existingStore as never, selector);
        }

        const safeStateCreator = stateCreator as (
          set: Parameters<Parameters<typeof immer<T>>[0]>[0],
          get: Parameters<Parameters<typeof immer<T>>[0]>[1],
          api: Parameters<Parameters<typeof immer<T>>[0]>[2]
        ) => T;

        const storeApi = createStore<T>()(
          immer((set, get, api) => safeStateCreator(set, get, api))
        );
        storeRegistry.set(storeKey, storeApi);
        return useStore(storeApi as never, selector);
      };
    },
  };
});

import { MENU_ID, SHEETS } from './forecast-price.constants';
import { useForecastPriceStore } from './useForecastPriceStore';

describe('useForecastPriceStore', () => {
  beforeEach(() => {
    postMock.mockReset();
  });

  it('has expected initial state', () => {
    const { result } = renderHook(() => useForecastPriceStore(s => s));

    expect(result.current.searchParams.divisionId).toBe('40');
    expect(result.current.searchParams.versionType).toBe('Current');
    expect(result.current.searchParams.bucketType).toBe('W');
    expect(result.current.isOpenSearchArea).toBe(true);
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.dateColumns).toStrictEqual([]);
  });

  it('setSearchParams merges partial values', () => {
    const { result } = renderHook(() => useForecastPriceStore(s => s));

    act(() => {
      result.current.setSearchParams({ deptIds: ['TEAM-A'], itemIds: ['ITEM-1'] });
    });

    expect(result.current.searchParams.divisionId).toBe('40');
    expect(result.current.searchParams.deptIds).toStrictEqual(['TEAM-A']);
    expect(result.current.searchParams.itemIds).toStrictEqual(['ITEM-1']);
  });

  it('setOpenSearchArea toggles and supports explicit value', () => {
    const { result } = renderHook(() => useForecastPriceStore(s => s));

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
    const mockColumns = [{ fieldName: 'ITEM_ID', visible: true }];
    postMock.mockResolvedValue({ data: { result: mockColumns } });

    const { result } = renderHook(() => useForecastPriceStore(s => s));

    act(() => {
      result.current.fetchStaticColumns();
    });

    expect(postMock).toHaveBeenCalledWith(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: SHEETS.FCST_N_PRICE_40,
      divisionId: '40',
    });

    await waitFor(() => {
      expect(result.current.staticColumns).toStrictEqual(mockColumns);
    });
  });

  it('setStaticColumns, setDateColumns, and reset work', () => {
    const { result } = renderHook(() => useForecastPriceStore(s => s));

    const staticColumns = [{ fieldName: 'A' }] as never;
    const dateColumns = [{ binding: '202601' }] as never;

    act(() => {
      result.current.setStaticColumns(staticColumns);
      result.current.setDateColumns(dateColumns);
      result.current.setOpenSearchArea(false);
    });

    expect(result.current.staticColumns).toStrictEqual(staticColumns);
    expect(result.current.dateColumns).toStrictEqual(dateColumns);
    expect(result.current.isOpenSearchArea).toBe(false);

    act(() => {
      result.current.reset();
    });

    expect(result.current.searchParams.divisionId).toBe('40');
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.dateColumns).toStrictEqual([]);
    expect(result.current.isOpenSearchArea).toBe(true);
  });

  it('setFilters builds canonical PROC IN names and returns isSame=false on first call', () => {
    const { result } = renderHook(() => useForecastPriceStore(s => s));

    let isSame: boolean = true;
    act(() => {
      isSame = result.current.setFilters();
    });

    expect(isSame).toBe(false);
    expect(result.current.filters?.divisionId).toBe('40');
    expect(result.current.filters?.deptId).toBe('ALL');
    expect(result.current.filters?.versionType).toBe('Current');
    expect(result.current.filters?.qtyYn).toBe('N');
    expect(result.current.filters?.sesUserId).toBe('TEST_USER');
    expect(result.current.titleFilters?.divisionId).toBe('40');
    // [UICATEGORY 2026-08-07] Plant Site 배선 + Project/Owner/SenderCode (SP IN 13~16, 빈 배열 = 'ALL')
    expect(result.current.filters?.plantSiteId).toBe('ALL');
    expect(result.current.filters?.projectCode).toBe('ALL');
    expect(result.current.filters?.owner).toBe('ALL');
    expect(result.current.filters?.senderCode).toBe('ALL');
  });
});
