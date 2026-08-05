import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEET_INDEX, SHEETS } from './dynamic-query.constants';
import type {
  Columns,
  Parameters,
  ColumsAndParameters,
  DynamicQueryMeta,
  SearchCondition,
} from './dynamic-query.types';

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.RESULT]: RawFlexGridColumnConfig[];
  [SHEETS.COLUMNS]: RawFlexGridColumnConfig[];
  [SHEETS.PARAMETERS]: RawFlexGridColumnConfig[];
  [SHEETS.POPUP_COLUMNS]?: RawFlexGridColumnConfig[];
  [SHEETS.POPUP_PARAMETERS]?: RawFlexGridColumnConfig[];
};

// Result 그리드 동적 컬럼: 이름 + Columns 탭 VALUE_TYPE (.NET 타입 문자열).
//   AS-IS SCM0005 는 DataSet 타입으로 컬럼 자동 생성 → Int 계열은 숫자 렌더.
//   TO-BE 는 사용자 요구(2026-07-27)로 Int 계열도 텍스트처럼 표시 (콤마/우측정렬 제거).
export type ResultGridColumn = {
  name: string;
  valueType: string; // 'System.Int32' | 'System.Int64' | 'System.String' | ...
};

// Int 계열 .NET 타입 → 텍스트 렌더 대상 판정.
export const isIntegerValueType = (valueType?: string): boolean =>
  valueType === 'System.Int16' || valueType === 'System.Int32' || valueType === 'System.Int64';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.RESULT]?: ProcRequest<MENU_ID, SHEETS.RESULT>;
  [SHEETS.COLUMNS]?: ProcRequest<MENU_ID, SHEETS.COLUMNS>;
  [SHEETS.PARAMETERS]?: ProcRequest<MENU_ID, SHEETS.PARAMETERS>;
  [SHEETS.POPUP_COLUMNS]?: ProcRequest<MENU_ID, SHEETS.POPUP_COLUMNS>;
  [SHEETS.POPUP_PARAMETERS]?: ProcRequest<MENU_ID, SHEETS.POPUP_PARAMETERS>;
};

interface DynamicQueryState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  activePage: SHEET_INDEX;
  staticColumns: StaticColumnsBySheet;
  dynamicQueryMeta?: DynamicQueryMeta;
  sqlText?: string;
  resultGridColumns: ResultGridColumn[];
  tempDqIdIndex: number;
  saveColumnsAndParametersList: ColumsAndParameters[];
}

interface DynamicQueryAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchSearchConditions: () => Promise<void>;
  setActivePage: (page: SHEET_INDEX) => void;
  setViewColumnsFilters: (filter?: ProcRequest<MENU_ID, SHEETS.COLUMNS>) => void;
  setViewParametersFilters: (filter?: ProcRequest<MENU_ID, SHEETS.PARAMETERS>) => void;
  setDynamicQueryMeta: (meta: DynamicQueryMeta) => void;
  setSqlText: (sqlText: string) => void;
  setResultGridColumns: (columns: ResultGridColumn[]) => void;
  setExecuteFilter: (sqlText: string) => void;
  getTempDqId: () => string;
  setSaveColumnsAndParametersList: (saveParams: ColumsAndParameters) => void;
  clearSaveColumnsAndParametersList: () => void;
  getSaveColumnsAndParametersList: (
    crudType: string,
    dqId: number | string
  ) => {
    reqApiCall: boolean;
    columns: Columns[];
    parameters: Parameters[];
  };
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
    filters: {
      [SHEETS.MAIN]: undefined,
      [SHEETS.RESULT]: undefined,
      [SHEETS.COLUMNS]: undefined,
      [SHEETS.PARAMETERS]: undefined,
      [SHEETS.POPUP_COLUMNS]: undefined,
      [SHEETS.POPUP_PARAMETERS]: undefined,
    },
    searchCondition: { ...initSearch },
    openSearchArea: true,
    activePage: SHEET_INDEX.REGISTER,
    staticColumns: {
      [SHEETS.MAIN]: [],
      [SHEETS.RESULT]: [],
      [SHEETS.COLUMNS]: [],
      [SHEETS.PARAMETERS]: [],
      [SHEETS.POPUP_COLUMNS]: [],
      [SHEETS.POPUP_PARAMETERS]: [],
    },
    dynamicQueryMeta: undefined,
    sqlText: undefined,
    resultGridColumns: [],
    tempDqIdIndex: 0,
    saveColumnsAndParametersList: [],
    reset: () => {
      set(state => {
        state.filters = {};
        state.searchCondition = { ...initSearch };
        state.activePage = SHEET_INDEX.REGISTER;
      });
    },
    setSearchCondition: params => {
      set(state => {
        state.searchCondition = { ...state.searchCondition, ...params };
      });
    },
    setFilter: () => {
      set(state => {
        state.filters[SHEETS.MAIN] = { ...state.searchCondition };
        // Register 탭으로 초기화
        state.activePage = SHEET_INDEX.REGISTER;
        // viewTab 정보 초기화 (각 그리드에서 state.dynamicQueryMeta를 useEffect로 참조하여 초기화처리)
        state.dynamicQueryMeta = undefined;
        // 굳이 초기화 해줄 필요는 없을 것 같지만 일단 초기화.
        state.tempDqIdIndex = 0;
        // 새로 조회 함으로써 신규 및 수정 중이던 데이터 초기화
        state.saveColumnsAndParametersList = [];
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    fetchStaticColumns: async () => {
      const [main, columns, parameters, popupColumns, popupParameters] = await Promise.all([
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
          sheetNm: SHEETS.POPUP_COLUMNS,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.POPUP_PARAMETERS,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
          [SHEETS.RESULT]: [],
          [SHEETS.COLUMNS]: columns.data.result,
          [SHEETS.PARAMETERS]: parameters.data.result,
          [SHEETS.POPUP_COLUMNS]: popupColumns.data.result,
          [SHEETS.POPUP_PARAMETERS]: popupParameters.data.result,
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
    setActivePage: page => {
      set(state => {
        state.activePage = page;
      });
    },
    setViewColumnsFilters: (filter?: ProcRequest<MENU_ID, SHEETS.COLUMNS>) => {
      set(state => {
        state.filters[SHEETS.COLUMNS] = filter ? { ...filter } : undefined;
      });
    },
    setViewParametersFilters: (filter?: ProcRequest<MENU_ID, SHEETS.PARAMETERS>) => {
      set(state => {
        state.filters[SHEETS.PARAMETERS] = filter ? { ...filter } : undefined;
      });
    },
    setDynamicQueryMeta: (meta: DynamicQueryMeta) => {
      set(state => {
        state.dynamicQueryMeta = meta;
      });
    },
    setSqlText: (sqlText: string) => {
      set(state => {
        state.sqlText = sqlText;
      });
    },
    setResultGridColumns: (columns: ResultGridColumn[]) => {
      set(state => {
        state.resultGridColumns = columns;
      });
    },
    setExecuteFilter: sqlText => {
      set(state => {
        state.filters[SHEETS.RESULT] = { sqlText };
      });
    },
    getTempDqId: () => {
      set(state => {
        state.tempDqIdIndex += 1;
      });
      return `I_${get().tempDqIdIndex}`;
    },
    // 신규 or 수정 팝업에서 입력을 완료하고 OK 버튼을 눌렀을 때
    setSaveColumnsAndParametersList: (saveParams: ColumsAndParameters) => {
      const list = get().saveColumnsAndParametersList;
      const index = list.findIndex(item => item.DQ_ID === saveParams.DQ_ID);

      if (index >= 0) {
        set(state => {
          state.saveColumnsAndParametersList[index].CRUD_TYPE = saveParams.CRUD_TYPE;
          state.saveColumnsAndParametersList[index].columns = saveParams.columns;
          state.saveColumnsAndParametersList[index].parameters = saveParams.parameters;
        });
      } else {
        set(state => {
          state.saveColumnsAndParametersList.push(saveParams);
        });
      }
    },
    // 저장 성공 후 편집 세션 정리 — setFilter(조회)를 거치지 않는 재조회 경로에서
    //   stale 세션(임시 DQ_ID 'I_n' 항목 등)이 남아 다음 저장/팝업에 새어 들어가는 것을 막는다.
    clearSaveColumnsAndParametersList: () => {
      set(state => {
        state.saveColumnsAndParametersList = [];
        state.tempDqIdIndex = 0;
      });
    },
    // 팝업을 열었을 때 기존에 저장이 되어 있는 데이터가 있다면 리턴 해주고
    // 만약 입력 팝업이고 데이터가 없을 시 빈 배열을 전달한다.
    // 만약 수정 팝업이고 API로 콜한 데이터가 없다면 API를 호출이 필요한지에 대한 여부 값도 준다.
    getSaveColumnsAndParametersList: (crudType: string, dqId: number | string) => {
      const item = get().saveColumnsAndParametersList.find(item => item.DQ_ID === dqId);

      let reqApiCall = false;
      let columns = [] as Columns[];
      let parameters = [] as Parameters[];

      if (item) {
        columns = item.columns;
        parameters = item.parameters;
      } else {
        // AS-IS는 삭제 대상 데이터라고 해도 수정 팝업에서 수정이 가능하다.
        // 단 crudType은 변동되지 않는다.
        if (crudType === 'M' || crudType === 'D') {
          reqApiCall = true;
        }
      }

      return {
        reqApiCall,
        columns,
        parameters,
      };
    },
  }),
  'dynamic-query'
);
