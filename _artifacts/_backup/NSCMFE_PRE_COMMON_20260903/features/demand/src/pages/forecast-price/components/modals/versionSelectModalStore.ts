import { createPersistedStore } from '@shared/stores';

export interface VersionSelectSearchParams {
  divisionId: string;
  periodFrom: string;
  periodTo: string;
  description: string;
  chkDay: boolean;
  chkWeek: boolean;
}

const initSearchParams: VersionSelectSearchParams = {
  divisionId: '',
  periodFrom: '',
  periodTo: '',
  description: '',
  chkDay: false,
  chkWeek: true,
};

interface VersionSelectModalState {
  searchParams: VersionSelectSearchParams;
}

interface VersionSelectModalAction {
  setSearchParams: (patch: Partial<VersionSelectSearchParams>) => void;
}

export const useVersionSelectModalStore = createPersistedStore<
  VersionSelectModalState & VersionSelectModalAction
>(
  set => ({
    searchParams: initSearchParams,
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    },
  }),
  'modal-forecast-price-version-select'
);
