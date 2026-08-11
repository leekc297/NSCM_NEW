import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_OWNER_BY_DIVISION } from './owner-by-division-modal.constants';

interface OwnerByDivisionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface OwnerByDivisionModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initOwnerByDivisionModalState: OwnerByDivisionModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useOwnerByDivisionModalStore = createPersistedStore<
  OwnerByDivisionModalState & OwnerByDivisionModalAction
>(
  set => ({
    ...initOwnerByDivisionModalState,
    reset: () => set(initOwnerByDivisionModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_OWNER_BY_DIVISION}/column`,
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
  'modal-owner-by-division'
);
