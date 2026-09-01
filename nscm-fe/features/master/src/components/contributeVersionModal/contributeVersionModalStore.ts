import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_SHEET_COLUMN_META, MODAL_VERSION } from './contribute-version-modal.constants';

interface ContributeVersionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  selectedYear: string;
  // yearData 쿼리(Year SP)는 조회조건을 받지 않는다. store 필드로 참조를 고정해
  // selectedYear 변경 시 Year 콤보가 불필요하게 재조회되는 걸 막는다.
  noFilters: Record<string, never>;
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
  noFilters: {},
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
