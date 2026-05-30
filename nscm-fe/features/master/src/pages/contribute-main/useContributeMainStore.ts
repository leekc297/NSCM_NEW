/**
 * DMF0043 Contribute_Main — Zustand 스토어
 * 패턴: DMF0020 SalesFuturePrice 의 createPersistedStoreWithTab 참조
 */
import { create } from 'zustand';

import type { ContributeMainSearchParams } from './contribute-main.types';

interface ContributeMainState {
  searchParams: ContributeMainSearchParams;
  setSearchParams: (params: Partial<ContributeMainSearchParams>) => void;
  filters: ContributeMainSearchParams | undefined;
  setFilters: () => void;
  isOpenSearchArea: boolean;
  setOpenSearchArea: (open: boolean) => void;
  // ContributeRate 모달
  isOpenContributeRate: boolean;
  setOpenContributeRate: (open: boolean) => void;
}

/**
 * AS-IS .cs:114 — usrYear 는 GetVersionData() (DM_MST_CONTRIBUTE_VER 조회) 결과로 채워짐.
 * yearId = VER_SEQ. 초기값은 빈 string; ContributeMainForm 의 useEffect 에서 SP 로딩 직후
 * 첫 항목 (가장 최신 YYYY) 자동 선택.
 */
const initialSearchParams: ContributeMainSearchParams = {
  yearId: '',
  isYearByYear: false,
  isMismatch: false,
  isHistory: false,
};

export const useContributeMainStore = create<ContributeMainState>(set => ({
  searchParams: initialSearchParams,
  setSearchParams: params =>
    set(state => ({ searchParams: { ...state.searchParams, ...params } })),
  filters: undefined,
  setFilters: () => set(state => ({ filters: { ...state.searchParams } })),
  isOpenSearchArea: true,
  setOpenSearchArea: open => set({ isOpenSearchArea: open }),
  isOpenContributeRate: false,
  setOpenContributeRate: open => set({ isOpenContributeRate: open }),
}));
