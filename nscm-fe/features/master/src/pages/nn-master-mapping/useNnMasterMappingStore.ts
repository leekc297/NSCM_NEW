import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, META_SHEETS, SHEETS } from './nn-master-mapping.constants';

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
  // ⭐ UI 동적 속성관리 (master hook §4) — admin SYS0004 UI Category Setup 메타 동적 fetch
  staticColumns: { [SHEETS.MAIN]: RawFlexGridColumnConfig[] };
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  /** BE 메타 GET → staticColumns 자동 채움 (DMF0004 표준 패턴, 메모리 feedback_admin_meta_dynamic_fetch). */
  fetchStaticColumns: () => Promise<void>;
}

// AS-IS .cs L479-485 의 7개 search param + 'ALL' sentinel 사용
const initSearch: SearchCondition = {
  dataTypeCode: 'ALL',
  divisionId: '',
  deptId: 'ALL',
  endCustomer: 'ALL',
  scmSiteId: 'ALL',
  projectCode: '',
  itemId: '',
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: { [SHEETS.MAIN]: [] },
};

export const useNnMasterMappingStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => { state.searchCondition = { ...get().searchCondition, ...p }; }),
    setFilter: () => set(state => { state.filters = { [SHEETS.MAIN]: state.searchCondition }; }),
    setOpenSearchArea: open => set(state => { state.openSearchArea = open ?? !state.openSearchArea; }),
    /**
     * fetchStaticColumns — DMF0004 표준 (useSalesSiteStore fetchStaticColumns 패턴 동일).
     * Array.isArray 가드 — BE 응답 형식 예외 시 안전.
     */
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          // ⭐ META_SHEETS = SCM_MST_SHEET_COLUMNS 실제 SHEET_NAME ('NNMasterMapping', PascalCase).
          // SHEETS.MAIN ('main') 은 MNU_BTN_MPG_M.SHT_NM + callProc 용 — sheet 명 별도 표기.
          { sheetNm: META_SHEETS.MAIN }
        );
        const result = res.data?.result;
        set(state => {
          state.staticColumns = { [SHEETS.MAIN]: Array.isArray(result) ? result : [] };
        });
      } catch {
        // silent fail — staticColumns 빈 배열 유지 → grid 가 MAIN_COLUMNS fallback
      }
      if (get().initialized) return;
      set(state => { state.initialized = true; });
    },
  }),
  'nn-master-mapping-v2'   // storageName v2 — staticColumns 추가로 schema 변경
);
