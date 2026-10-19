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
      getState: () => ({ session: { div: '81', userId: 'TEST_USER', groupId: 'DM ADMIN' } }),
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

import { SHEETS } from './shipment-plan-semi.constants';
import { useShipmentPlanSemiStore } from './useShipmentPlanSemiStore';

describe('useShipmentPlanSemiStore', () => {
  beforeEach(() => {
    getMock.mockReset();
    postMock.mockReset();
    postMock.mockResolvedValue({ data: { result: [] } });
  });

  // F10(검색조건 초기화)은 저장된 조회조건만 초기화하고, 조회되어 있던 그리드는 유지한다
  //   (사용자 요청 2026-10-13). 그리드는 filters(= 조회 payload)와 applied* 스냅샷(날짜 헤더)에서 나오므로
  //   reset() 이 이 둘을 보존해야 한다. 그리드 초기화는 Division 변경(setDivision)이 담당한다.
  it('reset(F10) preserves grid filters and applied snapshot but resets searchCondition', () => {
    const { result } = renderHook(() => useShipmentPlanSemiStore(s => s));

    act(() => {
      result.current.setSearchCondition({
        divisionId: '81',
        operationGroupId: 'A',
        itemId: 'ITEM-1',
        planStartYyyymmdd: '20260105',
        chkSum: true,
      });
      result.current.setFilter();
    });

    // 전제: 조회 완료 — 그리드 payload 와 applied 스냅샷이 채워졌다.
    expect(result.current.filters[SHEETS.MAIN]).toBeDefined();
    expect(result.current.appliedDivisionId).toBe('81');
    expect(result.current.appliedPlanStartYyyymmdd).toBe('20260105');

    act(() => {
      result.current.reset();
    });

    // 그리드는 비우지 않는다 — filters·applied 스냅샷 유지.
    expect(result.current.filters[SHEETS.MAIN]).toBeDefined();
    expect(result.current.appliedDivisionId).toBe('81');
    expect(result.current.appliedPlanStartYyyymmdd).toBe('20260105');

    // 조회조건(폼)은 기본값으로 초기화된다.
    expect(result.current.searchCondition.divisionId).toBe('');
    expect(result.current.searchCondition.operationGroupId).toBe('');
    expect(result.current.searchCondition.itemId).toBe('');
    expect(result.current.searchCondition.chkSum).toBe(false);
  });

  // 그리드 초기화는 Division 변경이 담당(TO-BE 공통 요건) — reset 과 별개로 setDivision 은 filters 를 비운다.
  it('setDivision clears grid filters', () => {
    const { result } = renderHook(() => useShipmentPlanSemiStore(s => s));

    act(() => {
      result.current.setSearchCondition({ divisionId: '81' });
      result.current.setFilter();
    });
    expect(result.current.filters[SHEETS.MAIN]).toBeDefined();

    act(() => {
      result.current.setDivision('82');
    });
    expect(result.current.filters).toStrictEqual({});
  });
});
