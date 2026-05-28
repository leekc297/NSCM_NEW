import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { POPUP_ID, SHEETS } from './sso-dept-modal.constants';

interface StoreState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface StoreAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: StoreState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useSsoDeptModalStore = createPersistedStore<StoreState & StoreAction>(
  set => ({
    ...initState,
    reset: () => set(initState),
    fetchStaticColumns: async () => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${POPUP_ID}/column`,
        {
          sheetNm: SHEETS.SSO_DEPT,
        }
      );
      set(state => {
        state.staticColumns = columns.data.result;
        state.initialized = true;
      });
    },
  }),
  'sso-dept-modal'
);
