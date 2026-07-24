import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_NAME, MODAL_PROJECT_BY_DIVISION } from './project-by-division-modal.constants';

interface ProjectByDivisionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface ProjectByDivisionModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initProjectByDivisionModalState: ProjectByDivisionModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useProjectByDivisionModalStore = createPersistedStore<
  ProjectByDivisionModalState & ProjectByDivisionModalAction
>(
  set => ({
    ...initProjectByDivisionModalState,
    reset: () => set(initProjectByDivisionModalState),
    fetchStaticColumns: async () => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_PROJECT_BY_DIVISION}/column`,
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
  'modal-project-by-division'
);
