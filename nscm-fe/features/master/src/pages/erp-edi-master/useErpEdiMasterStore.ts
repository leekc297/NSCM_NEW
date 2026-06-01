import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './erp-edi-master.constants';

interface SearchCondition {
  divisionId: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
  senderName: string;
  flag: string;
}

type FiltersBySheet = {
  [SHEETS.SUMMARY]?: ProcRequest<MENU_ID, SHEETS.SUMMARY>;
  [SHEETS.REPAIR]?: ProcRequest<MENU_ID, SHEETS.REPAIR>;
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

const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
const monthAgo = new Date(Date.now() - 30 * 24 * 3600 * 1000).toISOString().slice(0, 10).replace(/-/g, '');

const initSearch: SearchCondition = {
  divisionId: '40',
  fromYyyymmdd: monthAgo,
  toYyyymmdd: today,
  senderName: '',
  flag: 'ALL',
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
};

export const useErpEdiMasterStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      state.filters = {
        [SHEETS.SUMMARY]: {
          fromYyyymmdd: c.fromYyyymmdd,
          toYyyymmdd: c.toYyyymmdd,
          divisionId: c.divisionId,
        },
        [SHEETS.REPAIR]: {
          divisionId: c.divisionId,
          fromYyyymmdd: c.fromYyyymmdd,
          toYyyymmdd: c.toYyyymmdd,
          senderName: c.senderName,
          flag: c.flag,
        },
      };
    }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'erp-edi-master'
);
