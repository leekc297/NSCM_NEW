import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './contribute-main.constants';
import type { SearchCondition } from './types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.MAIN_TITLE]?: ProcRequest<MENU_ID, SHEETS.MAIN_TITLE>;
  [SHEETS.VERSION]?: ProcRequest<MENU_ID, SHEETS.VERSION>;
  [SHEETS.SALES_LIST]?: ProcRequest<MENU_ID, SHEETS.SALES_LIST>;
};

interface ContributeMainState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  ratePopupOpen: boolean;
  versionPopupOpen: boolean;
}

interface ContributeMainAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
}

const currentYear = new Date().getFullYear();

const initSearch: SearchCondition = {
  yyyy: String(currentYear),
  verSeq: '',
  his: 'N',
  dis: 'ALL',
  chkYear: false,
};

const initState: ContributeMainState = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  ratePopupOpen: false,
  versionPopupOpen: false,
};

export const useContributeMainStore = createPersistedStoreWithTab<
  ContributeMainState & ContributeMainAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: params => {
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...params };
      });
    },
    setFilter: () => {
      set(state => {
        const cond = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            yyyy: cond.yyyy,
            verSeq: cond.verSeq,
            dis: cond.dis,
            his: cond.his,
            userGroup: '',
          },
          [SHEETS.MAIN_TITLE]: {
            divisionId: '40',
            yyyy: cond.yyyy,
          },
        };
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setRatePopupOpen: open => set(state => { state.ratePopupOpen = open; }),
    setVersionPopupOpen: open => set(state => { state.versionPopupOpen = open; }),
  }),
  'contribute-main'
);
