import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './sales-future-price.constants';
import type { SearchCondition } from './sales-future-price.types';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  activeTab: 'main' | 'pivot';   // Tab1 메인 그리드 / Tab2 PivotGrid
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: 'main' | 'pivot') => void;
}

// 기본값 (AS-IS Form_Load 동작):
//   Division : 40 (Mobility & IT Battery)
//   Period   : 오늘 ~ 90일 후 (PR_GET_DAY_RANGE)
//   Bucket   : W (Weekly)
//   Version  : CURRENT
const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
const today = yyyymmdd(new Date());
const ninetyDaysAhead = yyyymmdd(new Date(Date.now() + 90 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  itemIds: [],
  nickName: '',
  projectCodes: [],
  startYyyymmdd: today,
  endYyyymmdd: ninetyDaysAhead,
  bizTypes: [],
  owners: [],
  bucketType: BUCKET_TYPE.WEEKLY,
  searchOverRange: false,
  excludeNoPrice: false,
  versionId: 'CURRENT',
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  activeTab: 'main',
};

export const useSalesFuturePriceStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => {
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      state.filters = {
        [SHEETS.MAIN]: {
          startYyyymmdd: c.startYyyymmdd,
          endYyyymmdd: c.endYyyymmdd,
        },
      };
    }),
    setOpenSearchArea: open => set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
    setActiveTab: tab => set(state => { state.activeTab = tab; }),
  }),
  'sales-future-price',
);
