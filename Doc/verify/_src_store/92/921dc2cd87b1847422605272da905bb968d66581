import type { StoreApi } from 'zustand';
import { create } from 'zustand';
import { immer } from 'zustand/middleware/immer';

import type { BaseTabState } from './createStore';

interface MotherStoreState {
  registory: Map<string, StoreApi<BaseTabState>>;
}

interface MotherStoreActions {
  get: (key: string) => BaseTabState | null;
  register: (key: string, store: StoreApi<BaseTabState>) => void;
  unregister: (key: string) => void;
  resetSearchCondition: (key: string) => void;
}

type MotherStore = MotherStoreState & MotherStoreActions;

/**
 * 검색조건 초기화(F10) 시 reset() 이 되돌려도 유지해야 하는 상태.
 *
 * F10 은 "저장된 검색조건 초기화"다. 컬럼/메저 메타데이터는 "화면 정의"라 대상이 아니고,
 * 사용자가 모달에서 정한 컬럼 개인화도 검색조건이 아니므로 대상이 아니다.
 *
 * 필수: 페이지 스토어에 컬럼/메저 메타나 개인화 필드를 새로 만들면 이 목록에 이름을 추가해야 한다.
 * 아래 `stateKey in before` 판정은 이름이 정확히 일치할 때만 보존하므로, 목록에 없는 이름은
 * F10 에서 조용히 비워진다 — 그리드 컬럼이 사라지고 다음 Search 전까지 돌아오지 않는다
 * (fetchStaticColumns 는 마운트 effect 에서만 불린다).
 * staticColumn(단수) / staticMeasures / originalStaticColumns / userColumnLayout /
 * visibleMeasures 가 실제로 그 이유로 누락돼 있었다.
 */
const PRESERVED_ON_CONDITION_RESET = [
  // admin 메타 (화면 정의) — 서버에서 받아 오지만 재조회는 마운트 effect 에서만 한다
  'staticColumns',
  'staticColumn', // 단수형 (cust-psi-upload / customer-fcst-upload / metal-link-price / customer-model-mapping)
  'staticMeasures',
  'originalStaticColumns', // 컬럼 설정 모달의 "기본값" 원본
  // 사용자 컬럼 개인화 — 모달에서만 세팅되는 인메모리 값이라 한 번 비우면 되살릴 경로가 없다
  'userColumnLayout', // ColumnLayoutModal: 표시/순서/폭/색
  'visibleMeasures', // Measure Select 팝업: 표시 메저
  'initialized',
] as const;

export const useMotherStore = create<MotherStore>()(
  immer((set, get) => ({
    registory: new Map(),

    get: (key: string) => {
      const { registory } = get();
      const store = registory.get(key);
      if (store) return store.getState();
      return null;
    },
    getStore: (key: string) => get().registory.get(key),

    /**
     * F10(검색조건 초기화) 전용 부분 초기화.
     *
     * 페이지 스토어의 reset() 은 스토어 전체를 초기값으로 되돌리므로 staticColumns 까지 비운다.
     * 그런데 각 페이지의 fetchStaticColumns 는 `if (!initialized)` 가드가 붙은 마운트 effect
     * (deps: [tabId])에서만 호출돼서, 한 번 비워지면 재조회 없이 빈 채로 남는다.
     * → 그리드 컬럼이 사라지고 저장 시 검증 스펙도 없어진다.
     *
     * 그래서 reset() 직후 컬럼 관련 상태만 되돌려 놓는다.
     */
    resetSearchCondition: (key: string) => {
      const store = get().registory.get(key);
      if (!store) return;

      const before = store.getState() as BaseTabState & Record<string, unknown>;

      const preserved: Record<string, unknown> = {};
      for (const stateKey of PRESERVED_ON_CONDITION_RESET) {
        if (stateKey in before) preserved[stateKey] = before[stateKey];
      }

      before.reset();

      if (Object.keys(preserved).length > 0) store.setState(preserved as Partial<BaseTabState>);
    },

    register: (key: string, store: StoreApi<BaseTabState>) => {
      const { registory } = get();
      registory.set(key, store);
    },

    unregister: (key: string) => {
      set(state => {
        state.registory.delete(key);
      });
      sessionStorage.removeItem(key);
    },
  }))
);
