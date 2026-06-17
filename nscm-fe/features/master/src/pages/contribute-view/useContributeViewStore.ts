import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { type MENU_ID, META_MENU_ID, META_SHEETS, SHEETS } from './contribute-view.constants';
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
  // ⭐ UI 동적 속성관리 (master hook §4) — BASE 컬럼 visible/width/label admin 메타 동적 fetch
  staticColumns: { [SHEETS.MAIN]: RawFlexGridColumnConfig[] };
}

interface ContributeViewAction {
  reset: () => void;
  setSearchCondition: (params: Partial<ViewSearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setColumnSetPopupOpen: (open: boolean) => void;
  /** BE 메타 GET → staticColumns 자동 채움 (DMF0004 표준 패턴). */
  fetchStaticColumns: () => Promise<void>;
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
  staticColumns: { [SHEETS.MAIN]: [] },
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
    /**
     * fetchStaticColumns — DMF0004 표준 (Array.isArray 가드).
     * BASE 컬럼 (YYYYMM~DM_BIZ_TYPE 9개) 의 admin 메타 동적 반영.
     * 동적 컬럼 (region × commission/markup) 은 MAIN_TITLE SP 결과로 별도 생성 (admin 관리 X).
     */
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          // ⭐ DMF0043_01 main grid 의 SHEET_COLUMNS 메타는 DMF0043 의 ContributeSalesList sheet 에 등록됨.
          // 사용자 진단 (2026-06-17): DMF0043_01 main 자체 row 0, DMF0043 ContributeSalesList 10 row.
          `/admin/menu/${META_MENU_ID}/column`,
          { sheetNm: META_SHEETS.MAIN }
        );
        const result = res.data?.result;
        set(state => {
          state.staticColumns = { [SHEETS.MAIN]: Array.isArray(result) ? result : [] };
        });
      } catch {
        // silent fail — staticColumns 빈 배열 유지
      }
      if (get().initialized) return;
      set(state => { state.initialized = true; });
    },
  }),
  'contribute-view-v2'   // storageName v2 — staticColumns 추가
);
