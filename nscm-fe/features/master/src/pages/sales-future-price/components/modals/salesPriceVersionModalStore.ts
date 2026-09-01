import dayjs from 'dayjs';

import { createPersistedStore } from '@shared/stores';

export interface SalesPriceVersionSearchParams {
  divisionId: string;
  periodFrom: string;
  periodTo: string;
  description: string;
}

const initSearchParams = (): SalesPriceVersionSearchParams => ({
  divisionId: '',
  periodFrom: dayjs().subtract(3, 'month').format('YYYYMMDD'),
  periodTo: dayjs().add(3, 'month').format('YYYYMMDD'),
  description: '',
});

interface SalesPriceVersionModalState {
  searchParams: SalesPriceVersionSearchParams;
}

interface SalesPriceVersionModalAction {
  setSearchParams: (patch: Partial<SalesPriceVersionSearchParams>) => void;
  resetSearchParams: (divisionId: string) => void;
}

export const useSalesPriceVersionModalStore = createPersistedStore<
  SalesPriceVersionModalState & SalesPriceVersionModalAction
>(
  set => ({
    searchParams: initSearchParams(),
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    },
    // 모달 open 시 AS-IS 기본값(오늘±3M)으로 복원
    resetSearchParams: divisionId => {
      set(state => {
        state.searchParams = { ...initSearchParams(), divisionId };
      });
    },
  }),
  'modal-sales-price-version'
);
