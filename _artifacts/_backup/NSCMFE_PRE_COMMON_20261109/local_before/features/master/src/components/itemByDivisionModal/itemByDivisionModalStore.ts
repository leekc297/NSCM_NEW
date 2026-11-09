import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore, useSessionStore } from '@shared/stores';

import { MODAL_ITEM_BY_DIVISION, MODAL_NAME } from './item-by-division-modal.constants';

interface ItemByDivisionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  divisionId?: string;
}

interface ItemByDivisionModalAction {
  reset: () => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

const initItemByDivisionModalState: ItemByDivisionModalState = {
  initialized: false,
  staticColumns: [],
  divisionId: useSessionStore.getState().session.div ?? '40',
} as const;

export const useItemByDivisionModalStore = createPersistedStore<
  ItemByDivisionModalState & ItemByDivisionModalAction
>(
  set => ({
    ...initItemByDivisionModalState,
    reset: () => set(initItemByDivisionModalState),
    fetchStaticColumns: async (divisionId?: string) => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_ITEM_BY_DIVISION}/column`,
        {
          sheetNm: MODAL_NAME,
          divisionId: divisionId === '40' ? '40' : undefined,
        }
      );
      set(state => {
        state.initialized = true;
        state.staticColumns = regionColumns.data.result;
        state.divisionId = divisionId;
      });
    },
  }),
  'modal-item-by-division'
);
