import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './scp-bom-elec.constants';
import type { SearchCondition } from './scp-bom-elec.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 13행, design 03 §1).
  staticColumns: RawFlexGridColumnConfig[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  // Division 변경 = Grid 초기화 의무(design 01 R6c — AS-IS InitSpread 재현). searchParams 갱신 + filters clear.
  changeDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: '', // 콤보 로드 후 '81' 존재 시 선택·미존재 시 마지막 항목 (design 01 R6b — Form effect)
  parentId: '',
  childId: '',
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: [],
};

// 멀티라인 텍스트 → SP 콤마 다중 파라미터 (design 02 §2.3 — AS-IS UsrMultiLineEditor 내장 등가):
//   개행 분리 후 전량 공백 줄만 스킵, 줄 내 공백은 미트림(토큰 trim 추가는 임의 개선 — 금지). 공백=미전달(NULL=전체).
//   단일 라인에 직접 콤마 입력도 그대로 통과(SP UF_FX_STRING_SPLIT 가 콤마 분리).
const normalizeMulti = (v: string): string =>
  v
    .split(/\r?\n/)
    .filter(line => line.trim().length > 0)
    .join(',');

export const useScpBomElecStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    changeDivision: divisionId =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, divisionId };
        state.filters = {}; // Grid 비움 + CRUD reset (design 01 R6c)
      }),
    // GET SP 파라미터 매핑 (PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC — all_arguments 실측):
    //   1 P_DIVISION_ID (단일·필수)
    //   2 P_PARENT_ID   (콤마 다중, 공백=전체)
    //   3 P_CHILD_ID    (콤마 다중, 공백=전체)
    //   4 P_DEBUG_MODE  ('F' 고정 — 시그니처 DEFAULT 없음, 생략 불가)
    //   SCM_ADM_PROC_M 등록 완료(05_register.sql (h), 15행 실측). 아래 키 = PROC_M COL_NM 과 1:1 일치.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            parentId: normalizeMulti(c.parentId), // 2
            childId: normalizeMulti(c.childId), // 3
            debugMode: 'F', // 4
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
  'scp-bom-elec-store'
);
