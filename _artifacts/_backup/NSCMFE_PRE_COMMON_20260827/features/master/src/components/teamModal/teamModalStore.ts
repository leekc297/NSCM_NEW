import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_TEAM } from './team-modal.constants';

interface TeamModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface TeamModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initTeamModalState: TeamModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useTeamModalStore = createPersistedStore<TeamModalState & TeamModalAction>(
  set => ({
    ...initTeamModalState,
    reset: () => set(initTeamModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_TEAM}/column`,
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
  'modal-team'
);
