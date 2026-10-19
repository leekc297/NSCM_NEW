import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_MATERIAL_BY_DIVISION, MODAL_NAME } from './material-by-division-modal.constants';

interface MaterialByDivisionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface MaterialByDivisionModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initMaterialByDivisionModalState: MaterialByDivisionModalState = {
  initialized: false,
  staticColumns: [],
} as const;

export const useMaterialByDivisionModalStore = createPersistedStore<
  MaterialByDivisionModalState & MaterialByDivisionModalAction
>(
  set => ({
    ...initMaterialByDivisionModalState,
    reset: () => set(initMaterialByDivisionModalState),
    // 컬럼 메타는 division 무관(SCM_MST_SHEET_COLUMNS.DIVISION_ID = NULL)이라 divisionId 를 넘기지 않는다.
    fetchStaticColumns: async () => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_MATERIAL_BY_DIVISION}/column`,
        { sheetNm: MODAL_NAME }
      );
      set(state => {
        state.initialized = true;
        state.staticColumns = columns.data.result;
      });
    },
  }),
  'modal-material-by-division'
);
