import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_CUSTOMER, MODAL_NAME } from './customer-modal.constants';

interface CustomerModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface CustomerModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initCustomerModalState: CustomerModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useCustomerModalStore = createPersistedStore<CustomerModalState & CustomerModalAction>(
  set => ({
    ...initCustomerModalState,
    reset: () => set(initCustomerModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_CUSTOMER}/column`,
        {
          sheetNm: MODAL_NAME,
        }
      );
      set(state => {
        state.staticColumns = regionColumns.data.result;
        state.initialized = true;
      });
    },
  }),
  'modal-customer'
);
