import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

// Model by Division 팝업(SCM0002/ModelPopup)의 그리드 컬럼 메타를 admin 에서 가져온다.
//   컬럼은 SCM_MST_SHEET_COLUMNS(admin 관리)에서 내려받는다
//   — /admin/menu/SCM0002/column → PR_GET_SHEET_COLUMN_LIST.
//   (신규 시트 'ModelPopup' = AS-IS base 팝업 11컬럼. 기존 'ItemPopup'=Ex 는 별개.)
const MENU_ID = 'SCM0002';
const SHEET_NM = 'ModelPopup';

interface ModelByDivisionPopupState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface ModelByDivisionPopupAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: ModelByDivisionPopupState = {
  initialized: false,
  staticColumns: [],
};

export const useModelByDivisionPopupStore = createPersistedStore<
  ModelByDivisionPopupState & ModelByDivisionPopupAction
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
  'modal-model-by-division'
);
