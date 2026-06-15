import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './sales-monitoring.constants';
import type { SearchCondition } from './sales-monitoring.types';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
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
  // AS-IS cboBucketType_Click L2167 — Insert 'I' 행 있을 시 Bucket 변경 차단 (MSG00227)
  //   현재 read-only 화면이라 Insert 'I' 행 없음 — 단순 helper (Insert 활성 시 활용)
  canChangeBucketType: () => boolean;
}

// 기본값 (AS-IS Form_Load 동작):
//   Division : 40 (Mobility & IT Battery — InitControls 분기 첫 진입)
//   Period   : 오늘 ~ 90일 후 (PR_GET_DAY_RANGE 동등 — 사용자 변경 가능)
//   Bucket   : WEEKLY (cboBucketType default)
//   InternalYN : N
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

export const useSalesMonitoringStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => {
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
    // SP P_DMF0048_GET_DM_PLN_SALES_MONITORING — 22 IN params
    //   multi-value 항목 ^ join, 비어있으면 'ALL'
    //   createdBy / userinfo / userDeptId / sesUserId / mnuId = BE 자동 채움
    //   nowYyyymmdd = today (AS-IS .cs L653 sNowDate = DateTime.Now)
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
    // AS-IS cboBucketType_Click — Insert 'I' 행 시 false (Bucket 변경 차단)
    //   현재 read-only 화면이라 항상 true
    canChangeBucketType: () => true,
  }),
  'sales-monitoring',
);
