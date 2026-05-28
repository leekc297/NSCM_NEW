import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_OWNER } from './owner-modal.constants';

interface OwnerModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface OwnerModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initOwnerModalState: OwnerModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useOwnerModalStore = createPersistedStore<OwnerModalState & OwnerModalAction>(
  set => ({
    ...initOwnerModalState,
    reset: () => set(initOwnerModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_OWNER}/column`,
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
  'modal-owner'
);
