import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './sales-future-price.constants';

interface SearchCondition {
  startYyyymmdd: string;
  endYyyymmdd: string;
  divisionId: string;
}

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN> };

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
const monthAhead = new Date(Date.now() + 90 * 24 * 3600 * 1000).toISOString().slice(0, 10).replace(/-/g, '');

const initSearch: SearchCondition = {
  startYyyymmdd: today,
  endYyyymmdd: monthAhead,
  divisionId: '40',
};

const initState: State = { initialized: false, filters: {}, searchCondition: initSearch, openSearchArea: true };

export const useSalesFuturePriceStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      state.filters = { [SHEETS.MAIN]: { startYyyymmdd: c.startYyyymmdd, endYyyymmdd: c.endYyyymmdd } };
    }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'sales-future-price'
);
