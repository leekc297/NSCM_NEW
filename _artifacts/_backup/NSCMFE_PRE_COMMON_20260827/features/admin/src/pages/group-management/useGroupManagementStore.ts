import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './group-management.constants';

interface GroupManagementState {
  initialized: boolean;
  loading: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.GROUP_MGMT>;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
}

interface GroupManagementAction {
  reset: () => void;
  setFilters: (filters: ProcRequest<MENU_ID, SHEETS.GROUP_MGMT>) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initGroupManagementState: GroupManagementState = {
  initialized: false,
  loading: false,
  filters: undefined,
  staticColumns: [],
  isOpenSearchArea: true,
} as const;

export const useGroupManagementStore = createPersistedStoreWithTab<
  GroupManagementState & GroupManagementAction
>(
  set => ({
    ...initGroupManagementState,
    reset: () => set(initGroupManagementState),
    setFilters: filters => {
      set(state => {
        state.filters = filters;
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.GROUP_MGMT,
        }
      );
      set(state => {
        state.staticColumns = result.data.result;
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
  }),
  'group-management'
);
