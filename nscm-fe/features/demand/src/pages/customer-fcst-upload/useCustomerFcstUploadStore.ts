import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './customer-fcst-upload.constant';
import type { SearchParamProps } from './customer-fcst-upload.types';

interface CustomerFcstUploadState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS>;
  staticColumn: RawFlexGridColumnConfig[];
}

interface CustomerFcstUploadAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initCustomerFcstUploadState: CustomerFcstUploadState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: '40',
    team: '',
    endCustomer: '',
    salesSite: '',
    project: '',
    plantSite: '',
    bucket: '',
    modelNickname: '',
    period: '',
    customsHandbook: '',
  },
  staticColumn: [],
};

export const useCustomerFcstUploadStore = createPersistedStoreWithTab<
  CustomerFcstUploadState & CustomerFcstUploadAction
>(
  (set, get) => ({
    ...initCustomerFcstUploadState,
    reset: () => set(initCustomerFcstUploadState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();
          state.filters = initCustomerFcstUploadState.filters;
        }
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = state.searchParams;
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.CUSTOMER_FCST_UPLOAD,
        }
      );
      set(state => {
        state.staticColumn = result.data.result;
        state.initialized = true;
      });
    },
  }),
  'customer-fcst-upload'
);
