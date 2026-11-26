import { createPersistedStoreWithTab } from '@shared/stores';

import type { DashboardSearchParams } from './demand-as-dashboard.filters';

interface DashboardState {
  searchParams: DashboardSearchParams;
}

interface DashboardAction {
  setSearchParams: (partial: Partial<DashboardSearchParams>) => void;
  reset: () => void;
}

const initDashboardState: DashboardState = {
  // Div=81 고정이라 searchParams 에는 담지 않는다(filters 빌더가 FIXED_DIVISION 주입).
  //   bizType·oem 기본값은 콤보 '전체'(ALL) 옵션 value 와 맞춘다(옵션은 콤보 SP 로드).
  //   baseMonth 는 COMBO.BASE_DATE 콤보가 비동기 로드되므로 초기 공란 — 화면이 최신 주차(옵션 0번)로 시드한다.
  searchParams: {
    baseMonth: '',
    bizType: 'ALL',
    oem: 'ALL',
  },
};

export const useDemandAsDashboardStore = createPersistedStoreWithTab<
  DashboardState & DashboardAction
>(
  set => ({
    ...initDashboardState,
    setSearchParams: partial => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...partial };
      });
    },
    reset: () => set(initDashboardState),
  }),
  'demand-as-dashboard'
);
