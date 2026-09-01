import { createPersistedStore } from '@shared/stores';

export interface ExchangeRateAppliedFilters {
  divisionId: string;
  year: string;
}

const initApplied: ExchangeRateAppliedFilters = { divisionId: '', year: '' };

interface ExchangeRateModalState {
  applied: ExchangeRateAppliedFilters;
}

interface ExchangeRateModalAction {
  setApplied: (next: ExchangeRateAppliedFilters) => void;
}

export const useExchangeRateModalStore = createPersistedStore<
  ExchangeRateModalState & ExchangeRateModalAction
>(
  set => ({
    applied: initApplied,
    // 검색 조건 확정(Search 클릭·모달 open 초기화)마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setApplied: next => {
      set(state => {
        state.applied = next;
      });
    },
  }),
  'modal-sales-reports-exchange-rate'
);
