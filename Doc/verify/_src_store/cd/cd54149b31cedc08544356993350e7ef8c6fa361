import { createPersistedStore } from '@shared/stores';

export interface ExchangeRateApplied {
  divisionId: string;
  periodFrom: string;
  periodTo: string;
}

const initApplied: ExchangeRateApplied = { divisionId: '', periodFrom: '', periodTo: '' };

interface ExchangeRateModalState {
  applied: ExchangeRateApplied;
}

interface ExchangeRateModalAction {
  setApplied: (patch: Partial<ExchangeRateApplied>) => void;
}

export const useExchangeRateModalStore = createPersistedStore<
  ExchangeRateModalState & ExchangeRateModalAction
>(
  set => ({
    applied: initApplied,
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setApplied: patch => {
      set(state => {
        state.applied = { ...state.applied, ...patch };
      });
    },
  }),
  'modal-business-plan-exchange-rate'
);
