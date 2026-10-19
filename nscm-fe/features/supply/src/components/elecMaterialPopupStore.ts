import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

// Elec Material 팝업(SCM0002/ElecPopup)의 그리드 컬럼 메타를 admin 에서 가져온다.
//   /admin/menu/SCM0002/column {sheetNm:'ElecPopup'} → PR_GET_SHEET_COLUMN_LIST.
const MENU_ID = 'SCM0002';
const SHEET_NM = 'ElecPopup';

interface ElecMaterialPopupState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface ElecMaterialPopupAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: ElecMaterialPopupState = {
  initialized: false,
  staticColumns: [],
};

export const useElecMaterialPopupStore = createPersistedStore<
  ElecMaterialPopupState & ElecMaterialPopupAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    fetchStaticColumns: async () => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEET_NM }
      );
      set(state => {
        state.initialized = true;
        state.staticColumns = columns.data.result;
      });
    },
  }),
  'modal-elec-material'
);
