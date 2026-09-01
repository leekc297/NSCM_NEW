import { createPersistedStore } from '@shared/stores';

export interface ReplaceByCutoffRange {
  yyyymmFrom: string;
  yyyymmTo: string;
}

const initRange: ReplaceByCutoffRange = { yyyymmFrom: '', yyyymmTo: '' };

interface ReplaceByCutoffModalState {
  range: ReplaceByCutoffRange;
}

interface ReplaceByCutoffModalAction {
  setRange: (next: ReplaceByCutoffRange) => void;
}

export const useReplaceByCutoffModalStore = createPersistedStore<
  ReplaceByCutoffModalState & ReplaceByCutoffModalAction
>(
  set => ({
    range: initRange,
    // 기간 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setRange: next => {
      set(state => {
        state.range = next;
      });
    },
  }),
  'modal-business-plan-replace-by-cutoff'
);
