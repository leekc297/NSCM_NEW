import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

// CAPA Item 팝업(SCM0002/CapaItemPopup)의 그리드 컬럼 메타를 admin 에서 가져온다.
//   아1 = AS-IS SCM0002_CAPAItemPopup(SCP0104) — SCM0002 고유(공통 COM 아님).
const MENU_ID = 'SCM0002';
const SHEET_NM = 'CapaItemPopup';

interface CapaItemPopupState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface CapaItemPopupAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: CapaItemPopupState = {
  initialized: false,
  staticColumns: [],
};

export const useCapaItemPopupStore = createPersistedStore<CapaItemPopupState & CapaItemPopupAction>(
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
  'modal-capa-item'
);
