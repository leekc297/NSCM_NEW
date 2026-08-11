import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_PROJECT } from './project-modal-constants';

interface ProjectModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface ProjectModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initProjectModalState: ProjectModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useProjectModalStore = createPersistedStore<ProjectModalState & ProjectModalAction>(
  set => ({
    ...initProjectModalState,
    reset: () => set(initProjectModalState),
    fetchStaticColumns: async () => {
      const projectColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_PROJECT}/column`,
        {
          sheetNm: MODAL_NAME,
        }
      );
      set(state => {
        state.staticColumns = projectColumns.data.result;
        state.initialized = true;
      });
    },
  }),
  'modal-project'
);
