import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { SHEETS, MENU_ID } from './ui-category-setup.constants';
// import type { SearchParamProps } from './ui-category-setup.types';

interface SearchParamProps {
  programId: string;
  sheetName: string;
  columnName: string;
  columnLabelName: string;
  valid: string;
}
interface UICategorySetupState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.COLUMN>;
  searchParams: SearchParamProps;
  staticColumns: { [key in SHEETS]: RawFlexGridColumnConfig[] };
}

interface UICategorySetupAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParam: SearchParamProps = {
  programId: '',
  sheetName: '',
  columnName: '',
  columnLabelName: '',
  valid: 'Y',
};

const initUICategorySetupState: UICategorySetupState = {
  initialized: false,
  isOpenSearchArea: true,
  filters: undefined,
  searchParams: initSearchParam,
  staticColumns: { [SHEETS.COLUMN]: [], [SHEETS.MEASURE]: [] },
};

export const useUICategorySetupStore = createPersistedStoreWithTab<
  UICategorySetupState & UICategorySetupAction
>(
  (set, get) => ({
    ...initUICategorySetupState,
    reset: () => set(initUICategorySetupState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const [column, measure] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.COLUMN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MEASURE,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.COLUMN]: column.data.result,
          [SHEETS.MEASURE]: measure.data.result,
        };
      });
      if (get().initialized) return;
      void (async () => {
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
      })();
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'ui-category'
);
