import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './api-management.constants';

interface SearchParamProps {
  apiType: string;
  apiId: string;
  useYn: string;
}

interface ApiManagementState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.LIST>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  clickedRow: number;
  openMessageModal: boolean;
}

interface ApiManagementAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setClickedRow: (value: number) => void;
  setOpenMessageModal: (value: boolean) => void;
}

const initApiManagementParam: SearchParamProps = {
  apiType: 'ALL',
  apiId: '',
  useYn: 'Y',
};

const initApiManagementState: ApiManagementState = {
  initialized: false,
  filters: undefined,
  searchParams: initApiManagementParam,
  staticColumns: [],
  isOpenSearchArea: true,
  clickedRow: -1,
  openMessageModal: false,
} as const;

export const useApiManagementStore = createPersistedStoreWithTab<
  ApiManagementState & ApiManagementAction
>(
  (set, get) => ({
    ...initApiManagementState,
    reset: () => set(initApiManagementState),
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
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.LIST,
        }
      );
      set(state => {
        state.staticColumns = result.data.result;
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
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setClickedRow: value => {
      set(state => {
        state.clickedRow = value;
      });
    },
    setOpenMessageModal: value => {
      set(state => {
        state.openMessageModal = value;
      });
    },
  }),
  'api-management'
);
