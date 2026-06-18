import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { MENU_ID } from './contribute-main.constants';
import { MENU_ID as MENU_ID_CONST, SHEETS } from './contribute-main.constants';
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
  // ⭐ ui-dynamic-property-management.md §4 / ui-category-setup-column-meta.md
  //   admin SYS0004 UI Category Setup 의 SCM_MST_SHEET_COLUMNS 기준 동적 fetch.
  //   BASE 6 컬럼 (부문/팀/...) 의 visible/width/label/align 등 즉시 반영.
  staticColumns: {
    [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  };
}

interface ContributeMainAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
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
  staticColumns: {
    [SHEETS.MAIN]: [],
  },
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
    setRatePopupOpen: open =>
      set(state => {
        state.ratePopupOpen = open;
      }),
    setVersionPopupOpen: open =>
      set(state => {
        state.versionPopupOpen = open;
      }),
    // ⭐ ui-category-setup-column-meta.md §3 / DMF0004 (useSalesSiteStore.ts:91-114) 표준 패턴.
    //   POST /admin/menu/{MENU_ID}/column → SCM_MST_SHEET_COLUMNS row list.
    //   BE 가 RawFlexGridColumnConfig (binding/header/width/visible 등) 으로 가공 반환.
    fetchStaticColumns: async () => {
      const main = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID_CONST}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result ?? [],
        };
      });
      if (!get().initialized) {
        set(state => {
          state.initialized = true;
        });
      }
    },
  }),
  'contribute-main'
);
