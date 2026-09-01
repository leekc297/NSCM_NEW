import type { FlexGridColumnConfig } from '@foundation/models';

import { createPersistedStore } from './index';

interface DataGridState {
  candidateColumns: FlexGridColumnConfig[];
  staticColumns: FlexGridColumnConfig[];
  loading: boolean;
  error: string | null;
}

interface DataGridAction {
  reset: () => void;
  saveStaticColumns: (staticColumnsConfig: FlexGridColumnConfig[]) => Promise<void>;
  // TODO: 화면별 static columns params 필요 - 강민재
  fetchStaticColumns: () => Promise<void>;
}

const initDataGridState: DataGridState = {
  candidateColumns: [],
  staticColumns: [],
  loading: false,
  error: null,
};

export const useDataGridStore = createPersistedStore<DataGridState & DataGridAction>(
  set => ({
    ...initDataGridState,
    reset: () => set(() => ({ ...initDataGridState })),
    fetchStaticColumns: async () => {
      // TODO: 임시 await, 삭제 필요, static column info 가져오기 필요 - 강민재
      await Promise.resolve();
      set(state => {
        state.candidateColumns = [];
        state.staticColumns = [];
      });
    },
    saveStaticColumns: async staticColumnsConfig => {
      // TODO: 임시 await, 삭제 필요, static column info 저장 필요 - 강민재
      await Promise.resolve();
      console.error(staticColumnsConfig);
    },
  }),
  ''
);
