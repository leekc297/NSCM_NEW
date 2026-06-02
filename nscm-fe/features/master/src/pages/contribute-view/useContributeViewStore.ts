import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './contribute-view.constants';
import type { ViewSearchCondition } from './types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.MAIN_TITLE]?: ProcRequest<MENU_ID, SHEETS.MAIN_TITLE>;
  [SHEETS.VERSION]?: ProcRequest<MENU_ID, SHEETS.VERSION>;
};

interface ContributeViewState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: ViewSearchCondition;
  openSearchArea: boolean;
  versionPopupOpen: boolean;     // AS-IS btnSPVer_Click (.cs L453)
  ratePopupOpen: boolean;        // AS-IS btnCutOff_Click (.cs L444)
  columnSetPopupOpen: boolean;   // AS-IS btnColumn_Click (.cs L473)
}

interface ContributeViewAction {
  reset: () => void;
  setSearchCondition: (params: Partial<ViewSearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setColumnSetPopupOpen: (open: boolean) => void;
}

const currentYear = new Date().getFullYear();

const initSearch: ViewSearchCondition = {
  yyyy: String(currentYear),
  verSeq: '',
  versionNo: '',
  divisionId: '40',
  endCustReport: '',
  productGroup: 'ALL',
  bizType: 'ALL',
  millionYn: 'N',
  compatibilityYn: 'N',
};

const initState: ContributeViewState = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  versionPopupOpen: false,
  ratePopupOpen: false,
  columnSetPopupOpen: false,
};

export const useContributeViewStore = createPersistedStoreWithTab<
  ContributeViewState & ContributeViewAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: params => {
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...params };
      });
    },
    // AS-IS FindData (.cs L283) 의 SP 파라미터 전체 매핑
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            verSeq: c.verSeq,
            versionNo: c.versionNo,
            endCustReport: c.endCustReport,
            productGroup: c.productGroup,
            bizType: c.bizType,
            millionYn: c.millionYn,
            compatibilityYn: c.compatibilityYn,
          },
          // AS-IS InitSpread (.cs L146): p_division_id = '40'
          [SHEETS.MAIN_TITLE]: { divisionId: c.divisionId },
        };
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setVersionPopupOpen: open => set(state => { state.versionPopupOpen = open; }),
    setRatePopupOpen: open => set(state => { state.ratePopupOpen = open; }),
    setColumnSetPopupOpen: open => set(state => { state.columnSetPopupOpen = open; }),
  }),
  'contribute-view'
);
