import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './nn-master-mapping.constants';

interface SearchCondition {
  dataTypeCode: string;
  divisionId: string;
  deptId: string;
  endCustomer: string;
  scmSiteId: string;
  projectCode: string;
  itemId: string;
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

const initSearch: SearchCondition = {
  dataTypeCode: 'ALL',
  divisionId: '40',
  deptId: '',
  endCustomer: '',
  scmSiteId: '',
  projectCode: '',
  itemId: '',
};

const initState: State = { initialized: false, filters: {}, searchCondition: initSearch, openSearchArea: true };

export const useNnMasterMappingStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => { state.filters = { [SHEETS.MAIN]: state.searchCondition }; }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
  }),
  'nn-master-mapping'
);
