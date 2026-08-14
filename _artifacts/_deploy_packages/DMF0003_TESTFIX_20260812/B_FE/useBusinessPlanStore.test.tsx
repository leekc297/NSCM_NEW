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

import { BUCKET_TYPE, MENU_ID, SHEETS } from './business-plan.constants';
import { useBusinessPlanStore } from './useBusinessPlanStore';

describe('useBusinessPlanStore', () => {
  beforeEach(() => {
    postMock.mockReset();
  });

  it('has expected initial state', () => {
    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    expect(result.current.searchCondition.divisionId).toBe('40');
    // 기본 Bucket = Monthly (AS-IS BUCKET2_TYPE_CODE — M/Q/Y 축)
    expect(result.current.searchCondition.bucketType).toBe(BUCKET_TYPE.MONTHLY);
    expect(result.current.searchCondition.sumYn).toBe(false);
    // 기본 Period = 당월 1일 ~ +7개월 말일 (AS-IS p_month=7)
    expect(result.current.searchCondition.startYyyymmdd.endsWith('01')).toBe(true);
    expect(result.current.openSearchArea).toBe(true);
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.staticMeasures).toStrictEqual([]);
    expect(result.current.visibleMeasures).toBeNull();
    expect(result.current.cutoffWindow).toBeNull();
  });

  it('setSearchCondition merges partial values', () => {
    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    act(() => {
      result.current.setSearchCondition({ deptIds: ['TEAM-A'], itemIds: ['ITEM-1'] });
    });

    expect(result.current.searchCondition.divisionId).toBe('40');
    expect(result.current.searchCondition.deptIds).toStrictEqual(['TEAM-A']);
    expect(result.current.searchCondition.itemIds).toStrictEqual(['ITEM-1']);
  });

  it('setFilter builds 16-key MAIN payload (PROC_M COL_NM) + spreadTitle payload', () => {
    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    act(() => {
      result.current.setSearchCondition({
        divisionId: '82',
        deptIds: ['D1', 'D2'],
        projectCodes: ['PJT1'],
        bucketType: BUCKET_TYPE.QUARTERLY,
      });
      result.current.setFilter();
    });

    const main = result.current.filters[SHEETS.MAIN];
    expect(main?.divisionId).toBe('82');
    expect(main?.deptId).toBe('D1,D2'); // 콤마 delim (AS-IS CheckedList 1:1)
    expect(main?.endCustomer).toBe('ALL'); // 빈 멀티선택 = 'ALL' sentinel
    expect(main?.projectCode).toBe('PJT1'); // 텍스트 raw
    expect(main?.owner).toBe(''); // 텍스트 빈값 = ''
    expect(main?.qtyYn).toBe('N'); // cboQty dead — 'N' 고정 (파리티)
    expect(main?.userGroup).toBe('TEST_USER'); // 그룹 미도착 = sesUserId fallback
    // ⭐ 금주 월요일 (AS-IS GetThisWeekMonday — p_now_yyyymmdd)
    expect(main?.nowYyyymmdd).toMatch(/^\d{8}$/);
    // sesUserId 는 BE 자동주입 — request 미포함
    expect(Object.keys(main ?? {})).not.toContain('sesUserId');
    // bucket 파라미터 없음 — DMF0042 조회 SP 는 P_BUCKET 미보유 (버킷은 FE 표시 축)
    expect(Object.keys(main ?? {})).not.toContain('bucket');

    const title = result.current.filters[SHEETS.SPREAD_TITLE];
    expect(title?.divisionId).toBe('82');
    expect(title?.mnuId).toBe(MENU_ID);
  });

  it('clearFilters empties filters (stale payload 재사용 차단)', () => {
    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    act(() => {
      result.current.setFilter();
      result.current.clearFilters();
    });

    expect(result.current.filters).toStrictEqual({});
  });

  it('applyDayRange applies o_rc2 DAY_RANGE once', () => {
    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    act(() => {
      result.current.applyDayRange('20260701:20270228');
    });
    expect(result.current.searchCondition.startYyyymmdd).toBe('20260701');
    expect(result.current.searchCondition.endYyyymmdd).toBe('20270228');

    act(() => {
      result.current.applyDayRange('20260801:20270331'); // 2회차 무시 (1회 적용 가드)
    });
    expect(result.current.searchCondition.startYyyymmdd).toBe('20260701');

    act(() => {
      result.current.applyDayRange('invalid'); // 형식 불일치 무시
    });
    expect(result.current.searchCondition.endYyyymmdd).toBe('20270228');
  });

  it('fetchStaticColumns calls admin column API with sheet/division', async () => {
    const mockColumns = [{ colNm: 'DIVISION_ID', visible: true }];
    postMock.mockResolvedValue({ data: { result: mockColumns } });

    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    await act(async () => {
      // ⭐ [2026-08-12] zustand 싱글턴 잔존 차단 — 앞 테스트의 divisionId('82') 리셋.
      result.current.setSearchCondition({ divisionId: '40' });
      await result.current.fetchStaticColumns();
    });

    expect(postMock).toHaveBeenCalledWith(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: SHEETS.MAIN, // 'Biz Plan'
      divisionId: '40',
    });

    await waitFor(() => {
      expect(result.current.staticColumns).toStrictEqual(mockColumns);
    });
  });

  it('applyColumnVisibility / applyVisibleMeasures / setCutoffWindow work', () => {
    const { result } = renderHook(() => useBusinessPlanStore(s => s));

    act(() => {
      result.current.applyVisibleMeasures(['Business_Plan']);
      result.current.setCutoffWindow({
        VALID_YN: 'Y',
        START_YYYYMM: '202601',
        END_YYYYMM: '202612',
      } as never);
    });

    expect(result.current.visibleMeasures).toStrictEqual(['Business_Plan']);
    expect(result.current.cutoffWindow?.VALID_YN).toBe('Y');

    act(() => {
      result.current.reset();
    });
    expect(result.current.visibleMeasures).toBeNull();
    expect(result.current.cutoffWindow).toBeNull();
  });
});
