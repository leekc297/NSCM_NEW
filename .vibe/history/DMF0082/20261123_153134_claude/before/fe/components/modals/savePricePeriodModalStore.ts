import { createPersistedStore } from '@shared/stores';

export interface SavePricePeriodSearchParams {
  divisionId: string;
  endCustomers: string[];
  salesSites: string[];
  projectCode: string;
  itemId: string;
  periodFrom: string;
  periodTo: string;
}

const initSearchParams: SavePricePeriodSearchParams = {
  divisionId: '',
  endCustomers: [],
  salesSites: [],
  projectCode: '',
  itemId: '',
  periodFrom: '',
  periodTo: '',
};

interface SavePricePeriodModalState {
  searchParams: SavePricePeriodSearchParams;
  searched: boolean;
}

interface SavePricePeriodModalAction {
  setSearchParams: (patch: Partial<SavePricePeriodSearchParams>) => void;
  resetSearchParams: (next: SavePricePeriodSearchParams) => void;
  setSearched: (next: boolean) => void;
}

export const useSavePricePeriodModalStore = createPersistedStore<
  SavePricePeriodModalState & SavePricePeriodModalAction
>(
  set => ({
    searchParams: initSearchParams,
    searched: false,
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    },
    // 모달 open 시 AS-IS Form_Load 기본값으로 복원
    resetSearchParams: next => {
      set(state => {
        state.searchParams = next;
      });
    },
    setSearched: next => {
      set(state => {
        state.searched = next;
      });
    },
  }),
  'modal-forecast-price-save-price-period'
);
