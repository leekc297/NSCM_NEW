import { createPersistedStoreWithTab } from '@shared/stores';

import { DIVISION, MENU_ID, SHEETS } from './metal-link-price.constants';
import type { SearchCondition } from './metal-link-price.types';

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>; };
interface State { initialized: boolean; filters: FiltersBySheet; searchCondition: SearchCondition; openSearchArea: boolean; }
interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
}

// AS-IS InitControls L167~168: drpPeriodMonth = 당월 ~ +6개월
const yyyymm = (d: Date) => d.toISOString().slice(0, 7).replace('-', '');
const thisMonth = yyyymm(new Date());
const sixMonthsAhead = yyyymm(new Date(Date.now() + 180 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY, deptIds: [], endCustomers: [], scmSiteIds: [], plantSiteIds: [],
  projectCode: '', itemId: '',
  startYyyymm: thisMonth, endYyyymm: sixMonthsAhead,
  versionType: 'Current',
};

const initState: State = { initialized: false, filters: {}, searchCondition: initSearch, openSearchArea: true };

// AS-IS FindData (L361~) → SP P_DMF0074_GET_METAL_LINK_PRICE (12 IN + dual OUT)
//   Version=CURRENT vs HISTORY 분기 (다른 마스터 테이블)
export const useMetalLinkPriceStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId: c.divisionId, deptId: j(c.deptIds), endCustomer: j(c.endCustomers),
          scmSiteId: j(c.scmSiteIds), plantSiteId: j(c.plantSiteIds),
          projectCode: c.projectCode || '', itemId: c.itemId || '',
          fromYyyymmdd: c.startYyyymm + '01', toYyyymmdd: c.endYyyymm + '31',
          versionType: c.versionType,
        } as never,
      };
    }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'metal-link-price',
);
