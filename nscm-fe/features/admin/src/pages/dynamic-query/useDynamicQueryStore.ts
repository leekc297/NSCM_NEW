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
}

interface DynamicQueryAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSelectedQueryId: (id: string) => void;
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

    reset: () => {
      set(state => {
        state.filters = {};
        state.searchCondition = { ...initSearch };
        state.selectedQueryId = '';
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
        state.filters[SHEETS.MAIN] = (searchCondition as unknown) as ProcRequest<
          MENU_ID,
          SHEETS.MAIN
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
        // PROC_M COL_NM 매칭: COLUMNS/PARAMETERS SP 는 'dqId' (P_DQ_ID), HISTORY SP 는 'queryId' (P_QUERYID)
        state.filters[SHEETS.COLUMNS] = { dqId: id } as ProcRequest<MENU_ID, SHEETS.COLUMNS>;
        state.filters[SHEETS.PARAMETERS] = { dqId: id } as ProcRequest<MENU_ID, SHEETS.PARAMETERS>;
        state.filters[SHEETS.HISTORY] = { queryId: id } as ProcRequest<MENU_ID, SHEETS.HISTORY>;
      });
    },
    fetchStaticColumns: async () => {
      const [main, columns, parameters, history] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm: SHEETS.MAIN }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm: SHEETS.COLUMNS }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm: SHEETS.PARAMETERS }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm: SHEETS.HISTORY }),
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
        const param = await apiClient.get<
          { paramNm: keyof SearchCondition; paramCtn: string }[]
        >(`/admin/menu/${MENU_ID}/search-conditions`);

        if (param.data.result?.length > 0) {
          const restored = param.data.result.reduce((acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn as SearchCondition[typeof curr.paramNm];
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
