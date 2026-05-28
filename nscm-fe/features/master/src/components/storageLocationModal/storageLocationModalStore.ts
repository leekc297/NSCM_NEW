import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_SLOC } from './storage-location-modal.constants';

interface SlocModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface SlocModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSlocModalState: SlocModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useSlocModalStore = createPersistedStore<SlocModalState & SlocModalAction>(
  set => ({
    ...initSlocModalState,
    reset: () => set(initSlocModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_SLOC}/column`,
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
  'modal-sloc'
);
