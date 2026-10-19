import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { COLUMN_SHEET_NAME, MENU_ID, RESPONSE_SET, SHEETS } from './formation.constants';

interface SearchParamProps {
  divisionId: string;
  plantSiteId: string;
  itemId: string;
}

type filtersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface FormationState {
  initialized: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
}

interface FormationAction {
  reset: () => void;
  setFilters: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  plantSiteId: '',
  itemId: '',
};

const initFormationStoreState: FormationState = {
  initialized: false,
  filters: {
    [SHEETS.FORMATION]: undefined,
    [SHEETS.EXCEPT]: undefined,
    [SHEETS.EXCEPT_LT]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [RESPONSE_SET.FORMATION]: [],
    [RESPONSE_SET.EXCEPT]: [],
    [RESPONSE_SET.EXCEPT_LT]: [],
  },
  openSearchArea: true,
} as const;

export const useFormationStore = createPersistedStoreWithTab<FormationState & FormationAction>(
  (set, get) => ({
    ...initFormationStoreState,
    reset: () => set(initFormationStoreState),
    // 조회(Search) 1회 = Formation/Except/Except_LT 3그리드 전부 전체조회. 세 필터를 동시에 커밋한다.
    setFilters: () => {
      set(state => {
        const params = { ...get().searchParams };
        state.filters[SHEETS.FORMATION] = params;
        state.filters[SHEETS.EXCEPT] = params;
        state.filters[SHEETS.EXCEPT_LT] = params;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        // division 이 바뀌면 조회 전 신규행/조회결과가 남지 않도록 필터를 비운다.
        if (searchParams.divisionId) state.filters = initFormationStoreState.filters;
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(ui-category hook).
    //   sheetNm 은 DB SHEET_NAME(공백 포함 표시명)과 정확히 일치해야 한다(COLUMN_SHEET_NAME).
    fetchStaticColumns: async () => {
      const fetchColumns = (rs: RESPONSE_SET) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: COLUMN_SHEET_NAME[rs],
        });

      const [formation, except, exceptLt] = await Promise.all([
        fetchColumns(RESPONSE_SET.FORMATION),
        fetchColumns(RESPONSE_SET.EXCEPT),
        fetchColumns(RESPONSE_SET.EXCEPT_LT),
      ]);
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.FORMATION]: formation.data.result,
          [RESPONSE_SET.EXCEPT]: except.data.result,
          [RESPONSE_SET.EXCEPT_LT]: exceptLt.data.result,
        };
      });

      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const restored = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);
        set(state => {
          state.searchParams = restored;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
  }),
  'formation'
);
