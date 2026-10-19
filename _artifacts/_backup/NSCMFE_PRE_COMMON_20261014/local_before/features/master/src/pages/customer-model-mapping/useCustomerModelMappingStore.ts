import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './customer-model-mapping.constants';
import type { SearchParamProps } from './customer-model-mapping.types';

interface CustomerModelMappingState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS>;
  staticColumn: RawFlexGridColumnConfig[];
}

interface CustomerModelMappingAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initCustomerModelMappingState: CustomerModelMappingState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: useSessionStore.getState().session.div ?? '40',
    deptId: 'ALL',
    endCustomer: 'ALL',
    salesSite: 'ALL',
    customerPJT: '',
    customerModel: '',
    projectCode: '',
    itemId: '',
    activeFlag: 'Y',
  },
  staticColumn: [],
};

export const useCustomerModelMappingStore = createPersistedStoreWithTab<
  CustomerModelMappingState & CustomerModelMappingAction
>(
  (set, get) => ({
    ...initCustomerModelMappingState,
    reset: () => set(initCustomerModelMappingState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: (searchParams: Partial<SearchParamProps>) => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();
          state.filters = initCustomerModelMappingState.filters;
        }
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
          sheetNm: SHEETS.CUSTOMER_MODEL_MAPPING,
        }
      );
      set(state => {
        state.staticColumn = result.data.result;
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
  'customer-model-mapping'
);
