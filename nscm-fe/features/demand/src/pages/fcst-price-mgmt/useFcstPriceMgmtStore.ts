import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './fcst-price-mgmt.constants';
import type { EditAuth, SearchCondition } from './fcst-price-mgmt.types';

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>; };
interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  editAuth: EditAuth;             // 권한 4 분기
  insertedRows: unknown[];
  openSearchArea: boolean;
}
interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setEditAuth: (auth: Partial<EditAuth>) => void;
  setOpenSearchArea: (open?: boolean) => void;
}

const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
const today = yyyymmdd(new Date());
const ninetyDaysAhead = yyyymmdd(new Date(Date.now() + 90 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY, deptIds: [], endCustomers: [], scmSiteIds: [], plantSiteIds: [],
  projectCode: '', itemId: '', bizTypes: [],
  startYyyymmdd: today, endYyyymmdd: ninetyDaysAhead,
  bucketType: BUCKET_TYPE.MONTHLY, versionType: 'Current',
  qtyYn: 'Y',
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  editAuth: { scmFcst: false, mktFcst: false, loc: false, vmiInReq: false },
  insertedRows: [],
  openSearchArea: true,
};

export const useFcstPriceMgmtStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId: c.divisionId, teamId: j(c.deptIds), customer: j(c.endCustomers),
          bizType: j(c.bizTypes), fromYyyymmdd: c.startYyyymmdd, toYyyymmdd: c.endYyyymmdd,
          scmSiteId: j(c.scmSiteIds), itemId: c.itemId || '',
          versionType: c.versionType, qtyYn: c.qtyYn,
        } as never,
      };
    }),
    setEditAuth: auth => set(state => { state.editAuth = { ...state.editAuth, ...auth }; }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'fcst-price-mgmt',
);
