import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_SHEET_COLUMN_META, MODAL_VERSION } from './contribute-version-modal.constants';

interface ContributeVersionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  selectedYear: string;
}

interface ContributeVersionModalAction {
  reset: () => void;
  setSelectedYear: (year: string) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: ContributeVersionModalState = {
  initialized: false,
  staticColumns: [],
  selectedYear: '',
} as const;

export const useContributeVersionModalStore = createPersistedStore<
  ContributeVersionModalState & ContributeVersionModalAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    setSelectedYear: year =>
      set(state => {
        state.selectedYear = year;
      }),
    fetchStaticColumns: async () => {
      const cols = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_VERSION}/column`,
        { sheetNm: MODAL_SHEET_COLUMN_META }
      );
      set(state => {
        state.staticColumns = cols.data.result;
        state.initialized = true;
      });
    },
  }),
  'modal-contribute-version'
);
