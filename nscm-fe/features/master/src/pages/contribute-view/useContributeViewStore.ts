import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID } from './contribute-view.constants';
import { SHEETS } from './contribute-view.constants';
import type { ViewSearchCondition } from './types';

type StaticColumnsBySheet = {
  [key in SHEETS]?: RawFlexGridColumnConfig[];
};

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.MAIN_TITLE]?: ProcRequest<MENU_ID, SHEETS.MAIN_TITLE>;
  [SHEETS.VERSION]?: ProcRequest<MENU_ID, SHEETS.VERSION>;
};

interface ContributeViewState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: ViewSearchCondition;
  staticColumns: StaticColumnsBySheet;
  openSearchArea: boolean;
  versionPopupOpen: boolean; // AS-IS btnSPVer_Click (.cs L453)
  ratePopupOpen: boolean; // AS-IS btnCutOff_Click (.cs L444)
  columnSetPopupOpen: boolean; // AS-IS btnColumn_Click (.cs L473)
  // ColumnSettingModal OK 결과 — BASE 컬럼 중 visible (USER_FLAG='Y') 만 표시.
  // 빈배열 = 전체 표시 (popup 사용 전 default). persist 으로 새로고침 후에도 보존.
  visibleBaseColumns: string[];
}

interface ContributeViewAction {
  reset: () => void;
  setSearchParams: (params: Partial<ViewSearchCondition>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setColumnSetPopupOpen: (open: boolean) => void;
  setVisibleBaseColumns: (cols: string[]) => void;
}

const currentYear = new Date().getFullYear();

const initSearchParams: ViewSearchCondition = {
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
  searchParams: initSearchParams,
  staticColumns: {
    [SHEETS.MAIN]: [],
  },
  openSearchArea: true,
  versionPopupOpen: false,
  ratePopupOpen: false,
  columnSetPopupOpen: false,
  visibleBaseColumns: [],
};

export const useContributeViewStore = createPersistedStoreWithTab<
  ContributeViewState & ContributeViewAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: params => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
    },
    // AS-IS FindData (.cs L283) 의 SP 파라미터 전체 매핑
    setFilters: () => {
      set(state => {
        const c = state.searchParams;
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
    // admin SHEET_COLUMNS (UI Category Setup) 동적 fetch — VISIBLE/WIDTH/ALIGN 즉시 반영.
    // BE endpoint: POST /admin/menu/{programId}/column with body { sheetNm }.
    // SHEET_COLUMNS 의 PROGRAM_ID='DMF0043_01' 자체 row 9 (LRG=NULL → wrapper TWO_DEPTH 정합).
    fetchStaticColumns: async () => {
      const main = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: 'ContributeSalesList' }
      );
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
        };
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setVersionPopupOpen: open =>
      set(state => {
        state.versionPopupOpen = open;
      }),
    setRatePopupOpen: open =>
      set(state => {
        state.ratePopupOpen = open;
      }),
    setColumnSetPopupOpen: open =>
      set(state => {
        state.columnSetPopupOpen = open;
      }),
    setVisibleBaseColumns: cols =>
      set(state => {
        state.visibleBaseColumns = cols;
      }),
  }),
  'contribute-view'
);
