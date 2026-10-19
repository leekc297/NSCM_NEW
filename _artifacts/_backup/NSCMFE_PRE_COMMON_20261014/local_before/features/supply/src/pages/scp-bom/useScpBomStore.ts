import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, DEFAULT_DIVISION, MENU_ID, SHEETS } from './scp-bom.constants';
import type { SearchCondition } from './scp-bom.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 27행, design 03 §1).
  staticColumns: RawFlexGridColumnConfig[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: DEFAULT_DIVISION, // '81' 고정 (design 01 R7)
  plantSiteIds: [],
  modelId: '',
  parentId: '',
  childId: '',
  alterBom: false, // 기본 미체크 = 'ALL' (design 02 §4)
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: [],
};

const trim = (v: string): string => (v && v.trim() ? v.trim() : '');
// 다중 Plant Site → SP 파라미터. 전체선택/미선택(빈 배열) = 빈 문자열(NULL=전체), 부분선택 = 콤마 결합
//   (design 02 §2.3 — 'ALL' 문자열 전달 금지).
const plantSiteParam = (ids: string[]): string => (ids.length === 0 ? '' : ids.join(','));

export const useScpBomStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // GET SP 파라미터 매핑 (PROC_M COL_NM 실측, design 03 §4.1 — PKG_SCP0053.P_SCP0053_GET_SCP_BOM):
    //   1 divisionId  ('81' 고정)
    //   2 plantSiteId (콤마 다중, 빈=전체)
    //   3 modelId / 4 parentId / 5 childId (각 단일값)
    //   6 alterBom    ('ALTER' | 'ALL')
    //   7 debugMode   (미전달 — DEFAULT 'F')
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            plantSiteId: plantSiteParam(c.plantSiteIds), // 2
            modelId: trim(c.modelId), // 3
            parentId: trim(c.parentId), // 4
            childId: trim(c.childId), // 5
            alterBom: c.alterBom ? 'ALTER' : 'ALL', // 6
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 컬럼 없음).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
              state.staticColumns = next;
            }
          });
        }
      } catch {
        // 미등록/실패 (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'scp-bom-store'
);
