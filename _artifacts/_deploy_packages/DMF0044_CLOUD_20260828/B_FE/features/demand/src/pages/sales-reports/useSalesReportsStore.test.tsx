// @vitest-environment jsdom

import { act, renderHook } from '@testing-library/react';
import { beforeEach, describe, expect, it, vi } from 'vitest';

const { getMock, postMock } = vi.hoisted(() => ({
  getMock: vi.fn(),
  postMock: vi.fn(),
}));

vi.mock('@foundation/apis', () => ({
  apiClient: {
    get: getMock,
    post: postMock,
  },
}));

vi.mock('@shared/stores', async () => {
  const { createStore, useStore } = await import('zustand');
  const { immer } = await import('zustand/middleware/immer');

  return {
    useSessionStore: {
      getState: () => ({ session: { div: '40', userId: 'TEST_USER', groupId: 'DM ADMIN' } }),
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

import { DATA_TYPE, REPORT_TYPE, SHEETS } from './sales-reports.constants';
import { resolveSearchedCondition, useSalesReportsStore } from './useSalesReportsStore';

describe('useSalesReportsStore', () => {
  beforeEach(() => {
    getMock.mockReset();
    postMock.mockReset();
  });

  it('has expected initial state (Data Type 기본 ALL = 편집 차단)', () => {
    const { result } = renderHook(() => useSalesReportsStore(s => s));

    expect(result.current.searchCondition.dataType).toBe(DATA_TYPE.ALL);
    expect(result.current.searchCondition.mdfType).toBe(REPORT_TYPE.SP_W);
    expect(result.current.searchCondition.versionNo).toBe('');
    expect(result.current.filters).toStrictEqual({});
  });

  it('setFilter builds MAIN payload from the form (PROC_M COL_NM)', () => {
    const { result } = renderHook(() => useSalesReportsStore(s => s));

    act(() => {
      result.current.setSearchCondition({
        divisionId: '82',
        mdfType: REPORT_TYPE.BP_M,
        yyyy: '2026',
        dataType: DATA_TYPE.ETC,
        versionNo: 'V1',
      });
      result.current.setFilter();
    });

    const main = result.current.filters[SHEETS.MAIN];
    expect(main?.divisionId).toBe('82');
    expect(main?.mdfType).toBe(REPORT_TYPE.BP_M);
    expect(main?.spVersionNo).toBe('V1');
    expect(main?.dataType).toBe(DATA_TYPE.ETC);
    expect(result.current.filters[SHEETS.MEASURE]?.dataType).toBe(DATA_TYPE.ETC);
  });

  it('직접 입력(key-in) Version 의 앞뒤 공백은 SP 전달 전에 제거된다', () => {
    const { result } = renderHook(() => useSalesReportsStore(s => s));

    act(() => {
      result.current.setSearchCondition({ versionNo: '  V1  ' });
      result.current.setFilter();
    });

    expect(result.current.filters[SHEETS.MAIN]?.spVersionNo).toBe('V1');
    expect(resolveSearchedCondition(result.current.filters[SHEETS.MAIN]).versionNo).toBe('V1');
  });

  it('미조회 상태의 조회 스냅샷 = ALL (편집 전면 잠금)', () => {
    const searched = resolveSearchedCondition(undefined);

    expect(searched.hasSearched).toBe(false);
    expect(searched.dataType).toBe(DATA_TYPE.ALL);
    expect(searched.versionNo).toBe('');
    expect(searched.divisionId).toBe('');
  });

  it('ALL 로 조회한 뒤 Data Type 폼만 바꿔도 조회 스냅샷은 ALL 로 남는다', () => {
    const { result } = renderHook(() => useSalesReportsStore(s => s));

    // 1) ALL 로 조회
    act(() => {
      result.current.setSearchCondition({ dataType: DATA_TYPE.ALL, versionNo: 'V1' });
      result.current.setFilter();
    });
    expect(resolveSearchedCondition(result.current.filters[SHEETS.MAIN]).dataType).toBe(
      DATA_TYPE.ALL
    );

    // 2) 재조회 없이 Data Type 콤보만 ETC 로 변경 — 게이트는 열리면 안 된다
    act(() => {
      result.current.setSearchCondition({ dataType: DATA_TYPE.ETC });
    });
    expect(result.current.searchCondition.dataType).toBe(DATA_TYPE.ETC); // 폼은 바뀌고
    expect(resolveSearchedCondition(result.current.filters[SHEETS.MAIN]).dataType).toBe(
      DATA_TYPE.ALL // 게이트 기준은 그대로
    );

    // 3) Search 를 다시 눌러야 비로소 ETC 가 게이트에 반영된다
    act(() => {
      result.current.setFilter();
    });
    expect(resolveSearchedCondition(result.current.filters[SHEETS.MAIN]).dataType).toBe(
      DATA_TYPE.ETC
    );
  });

  it('조회 후 Version/Report Type 폼만 바꿔도 저장 기준은 조회한 값', () => {
    const { result } = renderHook(() => useSalesReportsStore(s => s));

    act(() => {
      result.current.setSearchCondition({
        mdfType: REPORT_TYPE.SP_W,
        versionNo: 'V1',
        dataType: DATA_TYPE.ETC,
      });
      result.current.setFilter();
      result.current.setSearchCondition({ mdfType: REPORT_TYPE.BP_M, versionNo: 'V2' });
    });

    const searched = resolveSearchedCondition(result.current.filters[SHEETS.MAIN]);
    expect(searched.versionNo).toBe('V1');
    expect(searched.mdfType).toBe(REPORT_TYPE.SP_W);
  });

  it('clearFilters (division 변경/mount) → 스냅샷 소멸 = 편집 잠금 복귀', () => {
    const { result } = renderHook(() => useSalesReportsStore(s => s));

    act(() => {
      result.current.setSearchCondition({ dataType: DATA_TYPE.ETC, versionNo: 'V1' });
      result.current.setFilter();
      result.current.clearFilters();
    });

    expect(result.current.filters).toStrictEqual({});
    const searched = resolveSearchedCondition(result.current.filters[SHEETS.MAIN]);
    expect(searched.hasSearched).toBe(false);
    expect(searched.dataType).toBe(DATA_TYPE.ALL);
  });
});
