import { createPersistedStore } from '@shared/stores';

export interface VersionPopupSearchParams {
  sdt: string;
  edt: string;
  versionType: string;
  description: string;
}

const initSearchParams: VersionPopupSearchParams = {
  sdt: '',
  edt: '',
  versionType: '',
  description: '',
};

interface VersionPopupModalState {
  searchParams: VersionPopupSearchParams;
}

interface VersionPopupModalAction {
  setSearchParams: (patch: Partial<VersionPopupSearchParams>) => void;
  resetSearchParams: (next: VersionPopupSearchParams) => void;
}

export const useVersionPopupModalStore = createPersistedStore<
  VersionPopupModalState & VersionPopupModalAction
>(
  set => ({
    searchParams: initSearchParams,
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    },
    // 모달 open 시 AS-IS 기본값으로 복원
    resetSearchParams: next => {
      set(state => {
        state.searchParams = next;
      });
    },
  }),
  'modal-demand-manager-version-popup'
);
