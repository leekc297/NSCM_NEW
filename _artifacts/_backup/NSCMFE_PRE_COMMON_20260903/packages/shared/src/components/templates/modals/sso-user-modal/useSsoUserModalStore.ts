import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { POPUP_ID, SHEETS } from './sso-user-modal.constants';

interface StoreState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface StoreAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initRegionModalState: StoreState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useSsoUserModalStore = createPersistedStore<StoreState & StoreAction>(
  set => ({
    ...initRegionModalState,
    reset: () => set(initRegionModalState),
    fetchStaticColumns: async () => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${POPUP_ID}/column`,
        {
          sheetNm: SHEETS.SSO_USER,
        }
      );
      set(state => {
        state.staticColumns = columns.data.result;
        state.initialized = true;
      });
    },
  }),
  'sso-user-modal'
);
