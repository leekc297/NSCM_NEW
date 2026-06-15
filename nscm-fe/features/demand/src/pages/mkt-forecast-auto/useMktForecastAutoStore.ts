import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './mkt-forecast-auto.constants';
import type { SearchCondition } from './mkt-forecast-auto.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.PSI]?: ProcRequest<MENU_ID, SHEETS.PSI>;
  [SHEETS.CAR_FCST]?: ProcRequest<MENU_ID, SHEETS.CAR_FCST>;
};
interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  activeSheet: 'main' | 'psi' | 'carFcst';
  openSearchArea: boolean;
}
interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setActiveSheet: (sheet: 'main' | 'psi' | 'carFcst') => void;
  setOpenSearchArea: (open?: boolean) => void;
}

const yyyymm = (d: Date) => d.toISOString().slice(0, 7).replace('-', '');
const thisMonth = yyyymm(new Date());
const sixMonthsAhead = yyyymm(new Date(Date.now() + 180 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY, deptIds: [], endCustomers: [], scmSiteIds: [], plantSiteIds: [],
  projectCode: '', itemId: '', bizTypes: [], itemTypes: [], owner: '',
  startYyyymm: thisMonth, endYyyymm: sixMonthsAhead,
  bucketType: BUCKET_TYPE.MONTHLY, showSum: false, showColor: false,
};

const initState: State = { initialized: false, filters: {}, searchCondition: initSearch, activeSheet: 'main', openSearchArea: true };

export const useMktForecastAutoStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    // AS-IS FindData → 3 Sheet 동시 조회 또는 active sheet 별 조회
    setFilter: () => set(state => {
      const c = state.searchCondition;
      state.filters = {
        [SHEETS.MAIN]: {
          evTpCd: '', custCoCd: '', carMdlId: '',
          fromYyyymm: c.startYyyymm, toYyyymm: c.endYyyymm,
          marketshare: '', bizPerCar: '',
        } as never,
        [SHEETS.PSI]: {
          divisionId: c.divisionId, endCustomer: c.endCustomers[0] ?? '', projectCode: c.projectCode,
        } as never,
      };
    }),
    setActiveSheet: sheet => set(state => { state.activeSheet = sheet; }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'mkt-forecast-auto',
);
