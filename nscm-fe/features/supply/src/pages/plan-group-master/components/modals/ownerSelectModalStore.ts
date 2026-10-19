import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { OWNER_COLUMN_PROGRAM_ID, OWNER_COLUMN_SHEET_NAME } from './owner-select-modal.constants';

interface OwnerSelectModalState {
  // 두 그리드가 공유하는 컬럼 메타 — admin(SCM_MST_SHEET_COLUMNS, PROGRAM_ID='DMF000') 동적 fetch.
  staticColumn: RawFlexGridColumnConfig[];
}

interface OwnerSelectModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: OwnerSelectModalState = {
  staticColumn: [],
};

export const useOwnerSelectModalStore = createPersistedStore<
  OwnerSelectModalState & OwnerSelectModalAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${OWNER_COLUMN_PROGRAM_ID}/column`,
        {
          sheetNm: OWNER_COLUMN_SHEET_NAME,
        }
      );
      set(state => {
        state.staticColumn = result.data.result;
      });
    },
  }),
  'scp0121-owner-select-modal'
);
