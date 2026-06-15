import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './sales-plan.constants';
import type { SearchCondition } from './sales-plan.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
}

const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
const today = yyyymmdd(new Date());
const ninetyDaysAhead = yyyymmdd(new Date(Date.now() + 90 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  projectCode: '',
  itemId: '',
  itemTypes: [],
  bizTypes: [],
  owner: '',
  startYyyymmdd: today,
  endYyyymmdd: ninetyDaysAhead,
  bucketType: BUCKET_TYPE.WEEKLY,
  internalYn: 'N',
  showColor: false,
  showSum: false,
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
};

// AS-IS DMF0021_SalesPlan.cs FindData (L1279~) → SP P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX
//   메인 SP 2,122줄 + 15 IN params + 다단 헤더 5 group
//   colNm 자동 채움 키 (sesUserId / sesGroupId / mnuId)
export const useSalesPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => {
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
      const now = yyyymmdd(new Date());
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId:   c.divisionId,
          deptId:       j(c.deptIds),
          endCustomer:  j(c.endCustomers),
          scmSiteId:    j(c.scmSiteIds),
          projectCode:  c.projectCode || '',
          itemId:       c.itemId || '',
          itemType:     j(c.itemTypes),
          fromYyyymmdd: c.startYyyymmdd,
          nowYyyymmdd:  now,
          toYyyymmdd:   c.endYyyymmdd,
          plantSiteId:  j(c.plantSiteIds),
          biztype:      j(c.bizTypes),
          owner:        c.owner || '',
          internalYn:   c.internalYn,
          bucket:       c.bucketType,
        } as never,
      };
    }),
    setOpenSearchArea: open => set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
  }),
  'sales-plan',
);
