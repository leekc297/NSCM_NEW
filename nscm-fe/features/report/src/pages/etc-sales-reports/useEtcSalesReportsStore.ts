import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './etc-sales-reports.constants';
import type { SearchCondition } from './etc-sales-reports.types';

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>; };
interface State { initialized: boolean; filters: FiltersBySheet; searchCondition: SearchCondition; openSearchArea: boolean; }
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
  divisionId: DIVISION.MOBILITY, deptIds: [], endCustomers: [], scmSiteIds: [],
  projectCode: '', itemId: '', bizTypes: [],
  startYyyymmdd: today, endYyyymmdd: ninetyDaysAhead,
  bucketType: BUCKET_TYPE.MONTHLY, versionType: 'Current',
};

const initState: State = { initialized: false, filters: {}, searchCondition: initSearch, openSearchArea: true };

export const useEtcSalesReportsStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId: c.divisionId, tDepartmentId: j(c.deptIds), endCustomer: j(c.endCustomers),
          scmSiteId: j(c.scmSiteIds), projectCode: c.projectCode || '', itemId: c.itemId || '',
          bizType: j(c.bizTypes), fromYyyymmdd: c.startYyyymmdd, toYyyymmdd: c.endYyyymmdd,
          bucket: c.bucketType, versionType: c.versionType,
        } as never,
      };
    }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'etc-sales-reports',
);
