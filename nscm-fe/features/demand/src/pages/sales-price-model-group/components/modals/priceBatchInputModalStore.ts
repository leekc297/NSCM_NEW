import { createPersistedStore } from '@shared/stores';

// Search 를 누른 시점의 조회조건. 조회 · 화면 주 칸 · 저장 주가 모두 이 값을 쓴다
//   — 조회 뒤 조건만 바꾸고 저장하면 화면에 없는 주까지 저장되는 것을 막는다(원천 DMF0020 팝업과 같음).
export interface PriceBatchAppliedCond {
  scmSiteIds: string[];
  projectCodes: string[];
  mdlGrs: string[];
  fromYyyymmdd: string;
  toYyyymmdd: string;
}

interface State {
  appliedCond: PriceBatchAppliedCond | null;
}

interface Action {
  setAppliedCond: (next: PriceBatchAppliedCond | null) => void;
  reset: () => void;
}

export const usePriceBatchInputModalStore = createPersistedStore<State & Action>(
  set => ({
    appliedCond: null,
    setAppliedCond: next =>
      set(state => {
        state.appliedCond = next;
      }),
    reset: () =>
      set(state => {
        state.appliedCond = null;
      }),
  }),
  'modal-sales-price-model-group-price-batch'
);
