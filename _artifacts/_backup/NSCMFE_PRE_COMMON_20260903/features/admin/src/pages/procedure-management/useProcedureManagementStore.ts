import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { SHEETS, MENU_ID } from './procedure-management.constants';

interface SearchParamProps {
  schema?: string;
  procedure?: string;
  updateYn?: string;
}

type filtersBySheet = {
  [SHEETS.PROCEDURE_LIST]?: ProcRequest<MENU_ID, SHEETS.PROCEDURE_LIST>;
  [SHEETS.PROCEDURE_INFO]?: ProcRequest<MENU_ID, SHEETS.PROCEDURE_INFO>;
};

interface ProcedureManagementState {
  initialized: boolean;
  loading: boolean;
  isOpenSearchArea: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: { [key in SHEETS]: RawFlexGridColumnConfig[] };
  error: string | null;
}

interface ProcedureManagementAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setListFilter: () => void;
  setInfoFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PROCEDURE_INFO>) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParams: SearchParamProps = {
  schema: 'ALL',
  procedure: '',
  updateYn: 'ALL',
};

const initProcedureManagementState: ProcedureManagementState = {
  initialized: false,
  loading: false,
  isOpenSearchArea: true,
  filters: {
    [SHEETS.PROCEDURE_LIST]: undefined,
    [SHEETS.PROCEDURE_INFO]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: { [SHEETS.PROCEDURE_LIST]: [], [SHEETS.PROCEDURE_INFO]: [] },
  error: null,
} as const;

export const useProcedureManagementStore = createPersistedStoreWithTab<
  ProcedureManagementState & ProcedureManagementAction
>(
  (set, get) => ({
    ...initProcedureManagementState,
    reset: () => set(initProcedureManagementState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setListFilter: () => {
      set(state => {
        state.filters[SHEETS.PROCEDURE_LIST] = { ...state.searchParams };
        state.filters[SHEETS.PROCEDURE_INFO] = undefined;
      });
    },
    setInfoFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PROCEDURE_INFO>) => {
      set(state => {
        state.filters[SHEETS.PROCEDURE_INFO] = filter ? { ...filter } : undefined;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const [list, info] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.PROCEDURE_LIST,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.PROCEDURE_INFO,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.PROCEDURE_LIST]: list.data.result,
          [SHEETS.PROCEDURE_INFO]: info.data.result,
        };
      });

      if (get().initialized) return;

      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );

      if (param.data.result?.length > 0) {
        const searchParams = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);

        set(state => {
          state.searchParams = searchParams;
        });
      }

      set(state => {
        state.initialized = true;
      });
    },
  }),
  'procedure-management'
);
