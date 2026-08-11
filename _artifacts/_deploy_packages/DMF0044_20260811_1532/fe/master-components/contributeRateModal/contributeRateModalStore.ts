import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_RATE } from './contribute-rate-modal.constants';

interface ContributeRateModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface ContributeRateModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: ContributeRateModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useContributeRateModalStore = createPersistedStore<
  ContributeRateModalState & ContributeRateModalAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    fetchStaticColumns: async () => {
      const cols = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_RATE}/column`,
        { sheetNm: MODAL_NAME }
      );
      set(state => {
        state.staticColumns = cols.data.result;
        state.initialized = true;
      });
    },
  }),
  'modal-contribute-rate'
);
