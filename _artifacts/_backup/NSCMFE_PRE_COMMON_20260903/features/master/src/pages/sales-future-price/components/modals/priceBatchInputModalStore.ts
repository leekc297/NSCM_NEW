import { createPersistedStore } from '@shared/stores';

export interface PriceBatchAppliedCond {
  salesSite: string[];
  projectTokens: string[];
  itemId: string;
  periodFrom: string;
  periodTo: string;
}

interface PriceBatchInputModalState {
  appliedCond: PriceBatchAppliedCond | null;
}

interface PriceBatchInputModalAction {
  setAppliedCond: (next: PriceBatchAppliedCond | null) => void;
}

export const usePriceBatchInputModalStore = createPersistedStore<
  PriceBatchInputModalState & PriceBatchInputModalAction
>(
  set => ({
    appliedCond: null,
    // Search 버튼 클릭 시점의 스냅샷 — useTabProcQuery filters 참조 안정화 원천 (쿼리 키 전환 문제 방지)
    setAppliedCond: next => {
      set(state => {
        state.appliedCond = next;
      });
    },
  }),
  'modal-sales-future-price-batch-input'
);
