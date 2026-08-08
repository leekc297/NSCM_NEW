// @vitest-environment jsdom

import { act, renderHook, waitFor } from '@testing-library/react';
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

import { BUCKET_TYPE, MENU_ID, SHEETS } from './sales-plan.constants';
import { resolveNowYyyymmdd, useSalesPlanStore } from './useSalesPlanStore';

describe('useSalesPlanStore', () => {
  beforeEach(() => {
    getMock.mockReset();
    postMock.mockReset();
  });

  it('has expected initial state', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    expect(result.current.searchCondition.divisionId).toBe('40');
    // 기본 Bucket = Monthly (AS-IS DefineProperty L543)
    expect(result.current.searchCondition.bucketType).toBe(BUCKET_TYPE.MONTHLY);
    expect(result.current.searchCondition.sumYn).toBe(false);
    expect(result.current.searchCondition.colorYn).toBe(false);
    expect(result.current.searchCondition.internalYn).toBe(false);
    // 기본 Period = 당월 1일 ~ +6개월 말일
    expect(result.current.searchCondition.startYyyymmdd.endsWith('01')).toBe(true);
    expect(result.current.openSearchArea).toBe(true);
    expect(result.current.staticColumns).toStrictEqual([]);
    expect(result.current.staticMeasures).toStrictEqual([]);
    expect(result.current.visibleMeasures).toBeNull();
    expect(result.current.calendarInfo).toBeNull();
    expect(result.current.editAuth).toBeNull();
  });

  it('resolves query now date with ASIS Monday and period boundaries', () => {
    const today = new Date(2026, 6, 21);

    expect(resolveNowYyyymmdd('20260701', '20260731', today)).toBe('20260720');
    expect(resolveNowYyyymmdd('20260801', '20260831', today)).toBe('20260801');
    expect(resolveNowYyyymmdd('20260701', '20260710', today)).toBe('20260711');
  });

  it('setSearchCondition merges partial values', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    act(() => {
      result.current.setSearchCondition({ deptIds: ['TEAM-A'], itemIds: ['ITEM-1'] });
    });

    expect(result.current.searchCondition.divisionId).toBe('40');
    expect(result.current.searchCondition.deptIds).toStrictEqual(['TEAM-A']);
    expect(result.current.searchCondition.itemIds).toStrictEqual(['ITEM-1']);
  });

  it('setFilter builds 17-key MAIN payload (PROC_M COL_NM) + spreadTitle payload', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    act(() => {
      result.current.setSearchCondition({
        divisionId: '82',
        deptIds: ['D1', 'D2'],
        projectCodes: ['PJT1'],
        bucketType: BUCKET_TYPE.WEEKLY,
        internalYn: true,
      });
      result.current.setUserDeptId('JV01');
      result.current.setFilter();
    });

    const main = result.current.filters[SHEETS.MAIN];
    expect(main?.divisionId).toBe('82');
    expect(main?.deptId).toBe('D1,D2'); // 콤마 delim (AS-IS CheckedList 1:1)
    expect(main?.endCustomer).toBe('ALL'); // 빈 멀티선택 = 'ALL' sentinel
    expect(main?.projectCode).toBe('PJT1'); // 텍스트 raw
    expect(main?.owner).toBe(''); // 텍스트 빈값 = ''
    expect(main?.internalYn).toBe('Y'); // Include Internal Txn 선택값 전달
    // ⭐ userGroup 원천 = authGroup (CMBO 'SalesPlanUserAuthGroup' 정본) → 미설정 시 session.userId 폴백.
    //   `session.groupId` 는 **유령 필드**라 참조하지 않는다 (2026-08-04 확정 / useSalesPlanStore.ts:42, 221-227).
    //   구 기대값 'DM ADMIN' 은 groupId 참조 시절 산물 — jsdom 파손 기간 동안 미실행으로 방치돼 있었다.
    expect(main?.userGroup).toBe('TEST_USER'); // authGroup 미설정 → sesUserId 폴백
    expect(main?.bucket).toBe('WEEKLY'); // full-word
    expect(main?.userDeptId).toBe('JV01');
    expect(main?.nowYyyymmdd).toMatch(/^\d{8}$/);
    // sesUserId 는 BE 자동주입 — request 미포함
    expect(Object.keys(main ?? {})).not.toContain('sesUserId');

    const title = result.current.filters[SHEETS.SPREAD_TITLE];
    expect(title?.divisionId).toBe('82');
    expect(title?.bucket).toBe('WEEKLY');
  });

  it('userGroup 은 authGroup 이 있으면 그 값을 쓴다 (session.groupId 유령 필드 미참조)', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    act(() => {
      result.current.setAuthGroup('DM ADMIN'); // CMBO 'SalesPlanUserAuthGroup' 산출값
      result.current.setFilter();
    });

    expect(result.current.filters[SHEETS.MAIN]?.userGroup).toBe('DM ADMIN');
  });

  it('clearFilters empties filters (stale payload 재사용 차단)', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    act(() => {
      result.current.setFilter();
      result.current.clearFilters();
    });

    expect(result.current.filters).toStrictEqual({});
  });

  it('applyDayRange applies o_rc2 DAY_RANGE once', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    act(() => {
      result.current.applyDayRange('20260701:20270131');
    });
    expect(result.current.searchCondition.startYyyymmdd).toBe('20260701');
    expect(result.current.searchCondition.endYyyymmdd).toBe('20270131');

    act(() => {
      result.current.applyDayRange('20260801:20270228'); // 2회차 무시 (1회 적용 가드)
    });
    expect(result.current.searchCondition.startYyyymmdd).toBe('20260701');

    act(() => {
      result.current.applyDayRange('invalid'); // 형식 불일치 무시
    });
    expect(result.current.searchCondition.endYyyymmdd).toBe('20270131');
  });

  it('fetchStaticColumns restores saved conditions with SalesPlan value types', async () => {
    const mockColumns = [{ colNm: 'DIVISION_ID', visible: true }];
    postMock.mockResolvedValue({ data: { result: mockColumns } });
    getMock.mockResolvedValue({
      data: {
        result: [
          { paramNm: 'divisionId', paramCtn: '81' },
          { paramNm: 'deptIds', paramCtn: 'D1,D2' },
          { paramNm: 'bucketType', paramCtn: 'W' },
          { paramNm: 'colorYn', paramCtn: 'true' },
          { paramNm: 'sumYn', paramCtn: 'false' },
          { paramNm: 'startYyyymmdd', paramCtn: '20260701' },
          { paramNm: 'endYyyymmdd', paramCtn: '20261231' },
        ],
      },
    });

    const { result } = renderHook(() => useSalesPlanStore(s => s));

    // ⚠ 스토어는 `it` 블록 간 공유된다(mock storeRegistry) — 앞선 setFilter 테스트가 divisionId='82' 를
    //   남긴다. 초기값 '40' 에 의존하면 **실행 순서에 종속**되므로 전제를 명시적으로 세운다.
    act(() => {
      result.current.setSearchCondition({ divisionId: '40' });
    });

    await act(async () => {
      await result.current.fetchStaticColumns();
    });

    expect(postMock).toHaveBeenCalledWith(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: SHEETS.MAIN,
      divisionId: '40',
    });
    expect(getMock).toHaveBeenCalledWith(`/admin/menu/${MENU_ID}/search-conditions`);

    await waitFor(() => {
      expect(result.current.staticColumns).toStrictEqual(mockColumns);
      expect(result.current.searchCondition.divisionId).toBe('81');
      expect(result.current.searchCondition.deptIds).toStrictEqual(['D1', 'D2']);
      expect(result.current.searchCondition.bucketType).toBe(BUCKET_TYPE.WEEKLY);
      expect(result.current.searchCondition.colorYn).toBe(true);
      expect(result.current.searchCondition.sumYn).toBe(false);
      expect(result.current.searchCondition.startYyyymmdd).toBe('20260701');
      expect(result.current.searchCondition.endYyyymmdd).toBe('20261231');
      expect(result.current.dayRangeApplied).toBe(true);
      expect(result.current.initialized).toBe(true);
    });
  });

  it('applyColumnVisibility / applyVisibleMeasures / setCalendarInfo work', () => {
    const { result } = renderHook(() => useSalesPlanStore(s => s));

    act(() => {
      result.current.applyVisibleMeasures(['SalesAmt_LOC']);
      result.current.setCalendarInfo(
        { THIS_YYYYMM: '202607' } as never,
        { EDIT_AUTH_SALESAMT_LOC: 'Y', EDIT_AUTH_RTF_SYS_RP: 'N' } as never
      );
    });

    expect(result.current.visibleMeasures).toStrictEqual(['SalesAmt_LOC']);
    expect(result.current.calendarInfo?.THIS_YYYYMM).toBe('202607');
    expect(result.current.editAuth?.EDIT_AUTH_SALESAMT_LOC).toBe('Y');

    act(() => {
      result.current.reset();
    });
    expect(result.current.visibleMeasures).toBeNull();
    expect(result.current.calendarInfo).toBeNull();
  });
});
