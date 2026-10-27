import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MENU_ID } from '../../plan-group-master.constants';

// 등록 팝업 그리드 컬럼 메타 — admin(SCM_MST_SHEET_COLUMNS, SCP0121 / sheet 'PlanGroupInfoPopup').
const POPUP_ADMIN_SHEET = 'PlanGroupInfoPopup';

interface PlanGroupInfoModalState {
  staticColumns: RawFlexGridColumnConfig[];
}

interface PlanGroupInfoModalAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: PlanGroupInfoModalState = {
  staticColumns: [],
};

export const usePlanGroupInfoModalStore = createPersistedStore<
  PlanGroupInfoModalState & PlanGroupInfoModalAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    fetchStaticColumns: async () => {
      const res = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: POPUP_ADMIN_SHEET }
      );
      set(state => {
        state.staticColumns = res.data.result ?? [];
      });
    },
  }),
  'scp0121-plan-group-info-modal'
);
