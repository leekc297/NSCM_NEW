// SYS0013 store — 검색/UI 상태 전용 (2026-07-09 재개발).
// CRUD 추적은 표준 EditTracker + GridAction (CRUD_TYPE row 마킹) — store 에 pending 기계 없음.
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS, SHEET_INDEX } from './dynamic-query.constants';
import type { SearchCondition } from './dynamic-query.types';

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.COLUMNS]: RawFlexGridColumnConfig[];
  [SHEETS.PARAMETERS]: RawFlexGridColumnConfig[];
};

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.RESULT]?: ProcRequest<MENU_ID, SHEETS.RESULT>;
  [SHEETS.COLUMNS]?: ProcRequest<MENU_ID, SHEETS.COLUMNS>;
  [SHEETS.PARAMETERS]?: ProcRequest<MENU_ID, SHEETS.PARAMETERS>;
};

interface DynamicQueryState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // Register / View(Designer) 탭 — 행 더블클릭 시 Designer 자동 전환 (AS-IS spdMain_CellDoubleClick).
  activePage: SHEET_INDEX;
  selectedQueryId: string;
  staticColumns: StaticColumnsBySheet;
  // SQL 뷰어 편집값 — Execute 시 우선 사용. 선택 쿼리 변경 시 baseSql 로 sync (sourceId 추적).
  editedSqlText: string;
  editedSqlSourceId: string;
  // Condition 그리드 VALUE 런타임 입력값 (PARAMETER_ID → 값). Execute 시 토큰 치환.
  parameterValues: Record<string, string>;
  parameterValuesSourceId: string;
  // Role 다중선택 — roleOriginal 대비 diff 를 SAVE_USER_GROUP 로 저장.
  roleSelection: string[];
  roleOriginal: string[];
  roleSourceId: string;
}

interface DynamicQueryAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setExecuteFilter: (sqlText: string) => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActivePage: (page: SHEET_INDEX) => void;
  setSelectedQueryId: (id: string) => void;
  setEditedSqlText: (sqlText: string, sourceId: string) => void;
  setParameterValue: (parameterId: string, value: string) => void;
  initParameterValues: (defaults: Record<string, string>, sourceId: string) => void;
  setRoleSelection: (roles: string[]) => void;
  initRoles: (roles: string[], sourceId: string) => void;
  fetchSearchConditions: () => Promise<void>;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  reportName: '',
  description: '',
  role: 'ALL',
};

export const useDynamicQueryStore = createPersistedStoreWithTab<
  DynamicQueryState & DynamicQueryAction
>(
  (set, get) => ({
    initialized: false,
    filters: {},
    searchCondition: { ...initSearch },
    openSearchArea: true,
    activePage: SHEET_INDEX.REGISTER,
    selectedQueryId: '',
    staticColumns: {
      [SHEETS.MAIN]: [],
      [SHEETS.COLUMNS]: [],
      [SHEETS.PARAMETERS]: [],
    },
    editedSqlText: '',
    editedSqlSourceId: '',
    parameterValues: {},
    parameterValuesSourceId: '',
    roleSelection: [],
    roleOriginal: [],
    roleSourceId: '',

    reset: () => {
      set(state => {
        state.filters = {};
        state.searchCondition = { ...initSearch };
        state.activePage = SHEET_INDEX.REGISTER;
        state.selectedQueryId = '';
        state.editedSqlText = '';
        state.editedSqlSourceId = '';
        state.parameterValues = {};
        state.parameterValuesSourceId = '';
        state.roleSelection = [];
        state.roleOriginal = [];
        state.roleSourceId = '';
      });
    },
    setSearchCondition: params => {
      set(state => {
        state.searchCondition = { ...state.searchCondition, ...params };
      });
    },
    setFilter: () => {
      const { searchCondition } = get();
      set(state => {
        state.filters[SHEETS.MAIN] = { ...searchCondition };
      });
    },
    setExecuteFilter: sqlText => {
      // SP `PKG_SYS0013.P_SYS0013_GET_DYNAMIC_QUERYS(P_SQL_TEXT)` — 동적 SELECT cursor 반환.
      set(state => {
        state.filters[SHEETS.RESULT] = { sqlText };
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setActivePage: page => {
      set(state => {
        state.activePage = page;
      });
    },
    setSelectedQueryId: id => {
      set(state => {
        state.selectedQueryId = id;
        // 신규(I) 행은 DQ_ID 공백 — child fetch 미트리거 (DQ_ID 부재 시 SP ORA-01722 방지).
        if (id) {
          state.filters[SHEETS.COLUMNS] = { dqId: id };
          state.filters[SHEETS.PARAMETERS] = { dqId: id };
        } else {
          delete state.filters[SHEETS.COLUMNS];
          delete state.filters[SHEETS.PARAMETERS];
        }
      });
    },
    setEditedSqlText: (sqlText, sourceId) => {
      set(state => {
        state.editedSqlText = sqlText;
        state.editedSqlSourceId = sourceId;
      });
    },
    setParameterValue: (parameterId, value) => {
      set(state => {
        state.parameterValues[parameterId] = value;
      });
    },
    initParameterValues: (defaults, sourceId) => {
      set(state => {
        state.parameterValues = { ...defaults };
        state.parameterValuesSourceId = sourceId;
      });
    },
    setRoleSelection: roles => {
      set(state => {
        state.roleSelection = roles;
      });
    },
    initRoles: (roles, sourceId) => {
      // 쿼리 선택/변경 시 현재 역할로 초기화 — 미저장 변경 자연 reset.
      set(state => {
        state.roleSelection = roles;
        state.roleOriginal = roles;
        state.roleSourceId = sourceId;
      });
    },
    // ui-dynamic-property-management §4 — admin SYS0004 메타 동적 fetch (mount + Search refetch).
    // result 시트는 동적 컬럼(SCM_ADM_DQ_COLUMN 기반 런타임 생성)이라 메타 미사용.
    fetchStaticColumns: async () => {
      const [main, columns, parameters] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MAIN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.COLUMNS,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.PARAMETERS,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
          [SHEETS.COLUMNS]: columns.data.result,
          [SHEETS.PARAMETERS]: parameters.data.result,
        };
      });
    },
    fetchSearchConditions: async () => {
      if (get().initialized) return;
      try {
        const param = await apiClient.get<{ paramNm: keyof SearchCondition; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        if (param.data.result?.length > 0) {
          const restored = param.data.result.reduce((acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          }, {} as Partial<SearchCondition>);
          set(state => {
            state.searchCondition = { ...state.searchCondition, ...restored };
          });
        }
      } catch {
        // 개인화 조건 미존재 — 기본값 유지
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'dynamic-query'
);
