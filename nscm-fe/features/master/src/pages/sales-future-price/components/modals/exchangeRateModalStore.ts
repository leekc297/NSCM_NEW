import { createPersistedStore } from '@shared/stores';

export interface ExchangeRateQueryPeriod {
  start: string;
  end: string;
}

const initQueryPeriod: ExchangeRateQueryPeriod = { start: '', end: '' };

interface ExchangeRateModalState {
  queryPeriod: ExchangeRateQueryPeriod;
}

interface ExchangeRateModalAction {
  setQueryPeriod: (next: ExchangeRateQueryPeriod) => void;
}

export const useExchangeRateModalStore = createPersistedStore<
  ExchangeRateModalState & ExchangeRateModalAction
>(
  set => ({
    queryPeriod: initQueryPeriod,
    // Search 확정마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setQueryPeriod: next => {
      set(state => {
        state.queryPeriod = next;
      });
    },
  }),
  'modal-sales-future-price-exchange-rate'
);
