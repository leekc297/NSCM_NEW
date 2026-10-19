import dayjs from 'dayjs';

import { createPersistedStore } from '@shared/stores';

export interface MetalLinkVersionSearchParams {
  divisionId: string;
  periodFrom: string;
  periodTo: string;
  description: string;
}

const initSearchParams = (): MetalLinkVersionSearchParams => ({
  divisionId: '',
  periodFrom: dayjs().subtract(3, 'month').format('YYYYMMDD'),
  periodTo: dayjs().add(3, 'month').format('YYYYMMDD'),
  description: '',
});

interface MetalLinkVersionModalState {
  searchParams: MetalLinkVersionSearchParams;
}

interface MetalLinkVersionModalAction {
  setSearchParams: (patch: Partial<MetalLinkVersionSearchParams>) => void;
  resetSearchParams: (divisionId: string) => void;
}

export const useMetalLinkVersionModalStore = createPersistedStore<
  MetalLinkVersionModalState & MetalLinkVersionModalAction
>(
  set => ({
    searchParams: initSearchParams(),
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    },
    // 모달 open 시 AS-IS 기본값(오늘±3M)으로 복원 (Form_Load 1:1)
    resetSearchParams: divisionId => {
      set(state => {
        state.searchParams = { ...initSearchParams(), divisionId };
      });
    },
  }),
  'modal-metal-link-version'
);
