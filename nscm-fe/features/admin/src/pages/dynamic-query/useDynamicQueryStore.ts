import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './dynamic-query.constants';
import type { SearchCondition } from './dynamic-query.types';

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.RESULT]: RawFlexGridColumnConfig[];
  [SHEETS.COLUMNS]: RawFlexGridColumnConfig[];
  [SHEETS.PARAMETERS]: RawFlexGridColumnConfig[];
  [SHEETS.HISTORY]: RawFlexGridColumnConfig[];
};

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.RESULT]?: ProcRequest<MENU_ID, SHEETS.RESULT>;
  [SHEETS.COLUMNS]?: ProcRequest<MENU_ID, SHEETS.COLUMNS>;
  [SHEETS.PARAMETERS]?: ProcRequest<MENU_ID, SHEETS.PARAMETERS>;
  [SHEETS.HISTORY]?: ProcRequest<MENU_ID, SHEETS.HISTORY>;
};

interface DynamicQueryState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  selectedQueryId: string;
  staticColumns: StaticColumnsBySheet;
  // SQL Tab editable — 사용자가 SQLViewer 에서 수정한 SQL. 선택된 row 변경 시 mainRow.DQ_TEXT 로 동기화.
  editedSqlText: string;
  editedSqlSourceId: string; // 동기화 추적용 (다음 row 선택 시 reset 판단)
  // Parameters Tab — 사용자 입력값 (PARAMETER_ID → VALUE). Execute 시 sqlText 안 token 치환.
  // 선택된 query 가 바뀌면 DEFAULT_VALUE 로 자동 초기화 (parameterValuesSourceId 로 추적).
  parameterValues: Record<string, string>;
  parameterValuesSourceId: string;
  // Main grid CRUD tracking (Stage 5a) — AS-IS SCM0005 SaveData L764-919 정합.
  //   key = DQ_ID (기존) 또는 'TEMP_<n>' (신규 row).
  //   value.crudType = 'I' (Insert) / 'M' (Modify) / 'D' (Delete).
  //   handleSave 시 모든 pending 변경분을 JSON array 로 SAVE_QUERY_LIST SP 에 전달.
  mainPendingChanges: Record<string, { crudType: 'I' | 'M' | 'D'; row: Record<string, unknown> }>;
  mainTempInsertCounter: number;
  mainInsertedRows: Record<string, unknown>[];
  // Columns Tab CRUD (Stage 5b) — key = COLUMN_NAME (or TEMP_C_<n>).
  columnsPendingChanges: Record<string, { crudType: 'I' | 'M' | 'D'; row: Record<string, unknown> }>;
  columnsTempCounter: number;
  columnsInsertedRows: Record<string, unknown>[];
  // Parameters Tab CRUD (Stage 5c) — key = PARAMETER_ID (or TEMP_P_<n>).
  parametersPendingChanges: Record<string, { crudType: 'I' | 'M' | 'D'; row: Record<string, unknown> }>;
  parametersTempCounter: number;
  parametersInsertedRows: Record<string, unknown>[];
}

interface DynamicQueryAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setExecuteFilter: (sqlText: string) => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSelectedQueryId: (id: string) => void;
  setEditedSqlText: (sqlText: string, sourceId: string) => void;
  setParameterValue: (parameterId: string, value: string) => void;
  initParameterValues: (defaults: Record<string, string>, sourceId: string) => void;
  // Main grid CRUD (Stage 5a).
  trackMainInsert: (newRow: Record<string, unknown>) => void;
  trackMainModify: (dqId: string, row: Record<string, unknown>) => void;
  trackMainDelete: (dqId: string) => void;
  clearMainPending: () => void;
  // Columns Tab CRUD (Stage 5b).
  trackColumnsInsert: (dqId: number, newRow: Record<string, unknown>) => void;
  trackColumnsModify: (colName: string, row: Record<string, unknown>) => void;
  trackColumnsDelete: (colName: string) => void;
  clearColumnsPending: () => void;
  // Parameters Tab CRUD (Stage 5c).
  trackParametersInsert: (dqId: number, newRow: Record<string, unknown>) => void;
  trackParametersModify: (parameterId: string, row: Record<string, unknown>) => void;
  trackParametersDelete: (parameterId: string) => void;
  clearParametersPending: () => void;
  // 전체 pending 비우기 (SAVE 성공 후).
  clearAllPending: () => void;
  fetchSearchConditions: () => Promise<void>;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  queryName: '',
  category: 'ALL',
};

export const useDynamicQueryStore = createPersistedStoreWithTab<
  DynamicQueryState & DynamicQueryAction
>(
  (set, get) => ({
    initialized: false,
    filters: {},
    searchCondition: { ...initSearch },
    openSearchArea: true,
    selectedQueryId: '',
    staticColumns: {
      [SHEETS.MAIN]: [],
      [SHEETS.RESULT]: [],
      [SHEETS.COLUMNS]: [],
      [SHEETS.PARAMETERS]: [],
      [SHEETS.HISTORY]: [],
    },
    editedSqlText: '',
    editedSqlSourceId: '',
    parameterValues: {},
    parameterValuesSourceId: '',
    mainPendingChanges: {},
    mainTempInsertCounter: 0,
    mainInsertedRows: [],
    columnsPendingChanges: {},
    columnsTempCounter: 0,
    columnsInsertedRows: [],
    parametersPendingChanges: {},
    parametersTempCounter: 0,
    parametersInsertedRows: [],

    reset: () => {
      set(state => {
        state.filters = {};
        state.searchCondition = { ...initSearch };
        state.selectedQueryId = '';
        state.editedSqlText = '';
        state.editedSqlSourceId = '';
        state.parameterValues = {};
        state.parameterValuesSourceId = '';
        state.mainPendingChanges = {};
        state.mainTempInsertCounter = 0;
        state.mainInsertedRows = [];
        state.columnsPendingChanges = {};
        state.columnsTempCounter = 0;
        state.columnsInsertedRows = [];
        state.parametersPendingChanges = {};
        state.parametersTempCounter = 0;
        state.parametersInsertedRows = [];
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
        state.filters[SHEETS.MAIN] = searchCondition as unknown as ProcRequest<
          MENU_ID,
          SHEETS.MAIN
        >;
      });
    },
    setExecuteFilter: sqlText => {
      // AS-IS SCM0005_DynamicQueryList.cs Execute 클릭 → rtxtSQL.Text 의 sFinalSql 을 SP 입력으로 사용.
      // SP `PKG_SYS0013.P_SYS0013_GET_DYNAMIC_QUERYS(P_SQL_TEXT IN)` 가 동적 SELECT cursor 반환.
      set(state => {
        state.filters[SHEETS.RESULT] = { sqlText } as unknown as ProcRequest<
          MENU_ID,
          SHEETS.RESULT
        >;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setSelectedQueryId: id => {
      set(state => {
        state.selectedQueryId = id;
        // 신규 INSERT row (TEMP_*) 는 child fetch trigger 안 함 — DQ_ID 부재로 SP fail (ORA-01722).
        if (id && !id.startsWith('TEMP_')) {
          state.filters[SHEETS.COLUMNS] = { dqId: id } as ProcRequest<MENU_ID, SHEETS.COLUMNS>;
          state.filters[SHEETS.PARAMETERS] = { dqId: id } as ProcRequest<MENU_ID, SHEETS.PARAMETERS>;
          state.filters[SHEETS.HISTORY] = { dqId: id } as ProcRequest<MENU_ID, SHEETS.HISTORY>;
        } else {
          delete state.filters[SHEETS.COLUMNS];
          delete state.filters[SHEETS.PARAMETERS];
          delete state.filters[SHEETS.HISTORY];
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
    trackMainInsert: newRow => {
      set(state => {
        const tempId = `TEMP_${state.mainTempInsertCounter + 1}`;
        state.mainTempInsertCounter += 1;
        // CRUD_TYPE='I' 마킹 — DataGrid wrapper 의 isEditableCell 이 'IM'/'IO' 컬럼 활성 분기.
        const rowWithId = { ...newRow, DQ_ID: tempId, CRUD_TYPE: 'I' };
        state.mainInsertedRows = [...state.mainInsertedRows, rowWithId];
        state.mainPendingChanges[tempId] = { crudType: 'I', row: rowWithId };
      });
    },
    trackMainModify: (dqId, row) => {
      set(state => {
        const existing = state.mainPendingChanges[dqId];
        // 신규 row (I) 수정은 그대로 I 유지. 기존 row 만 M 으로 기록.
        const crudType = existing?.crudType === 'I' ? 'I' : 'M';
        state.mainPendingChanges[dqId] = { crudType, row };
      });
    },
    trackMainDelete: dqId => {
      set(state => {
        const existing = state.mainPendingChanges[dqId];
        if (existing?.crudType === 'I') {
          // 신규 추가 row 삭제 — pending 자체 제거 + insertedRows 에서 제외
          delete state.mainPendingChanges[dqId];
          state.mainInsertedRows = state.mainInsertedRows.filter(r => r.DQ_ID !== dqId);
        } else {
          // 기존 row 삭제 — D 로 마킹
          state.mainPendingChanges[dqId] = {
            crudType: 'D',
            row: existing?.row ?? { DQ_ID: dqId },
          };
        }
      });
    },
    clearMainPending: () => {
      set(state => {
        state.mainPendingChanges = {};
        state.mainTempInsertCounter = 0;
        state.mainInsertedRows = [];
      });
    },
    // ---- Columns Tab CRUD (Stage 5b) ----
    trackColumnsInsert: (dqId, newRow) => {
      set(state => {
        const tempKey = `TEMP_C_${state.columnsTempCounter + 1}`;
        state.columnsTempCounter += 1;
        const rowWithId = { ...newRow, DQ_ID: dqId, COLUMN_NAME: tempKey, CRUD_TYPE: 'I' };
        state.columnsInsertedRows = [...state.columnsInsertedRows, rowWithId];
        state.columnsPendingChanges[tempKey] = { crudType: 'I', row: rowWithId };
      });
    },
    trackColumnsModify: (colName, row) => {
      set(state => {
        const existing = state.columnsPendingChanges[colName];
        const crudType = existing?.crudType === 'I' ? 'I' : 'M';
        state.columnsPendingChanges[colName] = { crudType, row };
      });
    },
    trackColumnsDelete: colName => {
      set(state => {
        const existing = state.columnsPendingChanges[colName];
        if (existing?.crudType === 'I') {
          delete state.columnsPendingChanges[colName];
          state.columnsInsertedRows = state.columnsInsertedRows.filter(
            r => r.COLUMN_NAME !== colName
          );
        } else {
          state.columnsPendingChanges[colName] = {
            crudType: 'D',
            row: existing?.row ?? { COLUMN_NAME: colName },
          };
        }
      });
    },
    clearColumnsPending: () => {
      set(state => {
        state.columnsPendingChanges = {};
        state.columnsTempCounter = 0;
        state.columnsInsertedRows = [];
      });
    },
    // ---- Parameters Tab CRUD (Stage 5c) ----
    trackParametersInsert: (dqId, newRow) => {
      set(state => {
        const tempKey = `TEMP_P_${state.parametersTempCounter + 1}`;
        state.parametersTempCounter += 1;
        const rowWithId = { ...newRow, DQ_ID: dqId, PARAMETER_ID: tempKey, CRUD_TYPE: 'I' };
        state.parametersInsertedRows = [...state.parametersInsertedRows, rowWithId];
        state.parametersPendingChanges[tempKey] = { crudType: 'I', row: rowWithId };
      });
    },
    trackParametersModify: (parameterId, row) => {
      set(state => {
        const existing = state.parametersPendingChanges[parameterId];
        const crudType = existing?.crudType === 'I' ? 'I' : 'M';
        state.parametersPendingChanges[parameterId] = { crudType, row };
      });
    },
    trackParametersDelete: parameterId => {
      set(state => {
        const existing = state.parametersPendingChanges[parameterId];
        if (existing?.crudType === 'I') {
          delete state.parametersPendingChanges[parameterId];
          state.parametersInsertedRows = state.parametersInsertedRows.filter(
            r => r.PARAMETER_ID !== parameterId
          );
        } else {
          state.parametersPendingChanges[parameterId] = {
            crudType: 'D',
            row: existing?.row ?? { PARAMETER_ID: parameterId },
          };
        }
      });
    },
    clearParametersPending: () => {
      set(state => {
        state.parametersPendingChanges = {};
        state.parametersTempCounter = 0;
        state.parametersInsertedRows = [];
      });
    },
    clearAllPending: () => {
      set(state => {
        state.mainPendingChanges = {};
        state.mainTempInsertCounter = 0;
        state.mainInsertedRows = [];
        state.columnsPendingChanges = {};
        state.columnsTempCounter = 0;
        state.columnsInsertedRows = [];
        state.parametersPendingChanges = {};
        state.parametersTempCounter = 0;
        state.parametersInsertedRows = [];
      });
    },
    fetchStaticColumns: async () => {
      const [main, columns, parameters, history] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MAIN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.COLUMNS,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.PARAMETERS,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.HISTORY,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
          [SHEETS.RESULT]: [],
          [SHEETS.COLUMNS]: columns.data.result,
          [SHEETS.PARAMETERS]: parameters.data.result,
          [SHEETS.HISTORY]: history.data.result,
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
        // silently fail
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'dynamic-query'
);
