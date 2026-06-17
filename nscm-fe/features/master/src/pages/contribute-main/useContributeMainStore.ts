import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, META_SHEETS, SHEETS } from './contribute-main.constants';
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
  // ⭐ UI 동적 속성관리 (master hook §4) — BASE 컬럼 visible/width/label admin 메타 동적 fetch
  staticColumns: { [SHEETS.MAIN]: RawFlexGridColumnConfig[] };
}

interface ContributeMainAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
  /** BE 메타 GET → staticColumns 자동 채움 (DMF0004 표준). */
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
  staticColumns: { [SHEETS.MAIN]: [] },
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
    /**
     * fetchStaticColumns — DMF0004 표준 (Array.isArray 가드).
     * BASE 컬럼 (DEPARTMENT_ID/DEPT_ID/END_CUST_REPORT/SOLDTO_CUST_REPORT/PRODUCT_GROUP/DM_BIZ_TYPE 등)
     * 의 admin 메타 동적 반영. 동적 M#/Y# 컬럼은 별도 (MAIN_TITLE SP 결과).
     */
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          // ⭐ META_SHEETS = SCM_MST_SHEET_COLUMNS 실제 SHEET_NAME ('ContributeMain', PascalCase).
          // SHEETS.MAIN ('main') 은 MNU_BTN_MPG_M.SHT_NM + callProc 용 — sheet 명 별도 표기.
          { sheetNm: META_SHEETS.MAIN }
        );
        const result = res.data?.result;
        set(state => {
          state.staticColumns = { [SHEETS.MAIN]: Array.isArray(result) ? result : [] };
        });
      } catch {
        // silent fail
      }
      if (get().initialized) return;
      set(state => { state.initialized = true; });
    },
  }),
  'contribute-main-v2'   // storageName v2 — staticColumns 추가
);
