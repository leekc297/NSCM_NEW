import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_REGION } from './region-modal.constants';

interface RegionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface RegionModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initRegionModalState: RegionModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useRegionModalStore = createPersistedStore<RegionModalState & RegionModalAction>(
  set => ({
    ...initRegionModalState,
    reset: () => set(initRegionModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_REGION}/column`,
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
  'modal-region'
);
