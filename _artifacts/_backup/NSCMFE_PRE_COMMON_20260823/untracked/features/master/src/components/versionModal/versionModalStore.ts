import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_SALES_VERSION, MODAL_SALES_VERSION_COLUMN_SHEET } from './version-modal.constants';

interface VersionModalState {
  staticColumns: RawFlexGridColumnConfig[];
}

interface VersionModalAction {
  fetchStaticColumns: (divisionId: string) => Promise<void>;
}

export const useVersionModalStore = createPersistedStore<VersionModalState & VersionModalAction>(
  set => ({
    staticColumns: [],
    fetchStaticColumns: async divisionId => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_SALES_VERSION}/column`,
        {
          sheetNm: MODAL_SALES_VERSION_COLUMN_SHEET,
          divisionId,
        }
      );
      set(state => {
        state.staticColumns = columns.data.result;
      });
    },
  }),
  'modal-sales-version'
);
