import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

// Project by Division 팝업(SCM0002/ProjectByDivPopup)의 그리드 컬럼 메타를 admin 에서 가져온다.
//   프1 = AS-IS SCM0002_ProjectbyDivisionPopup(base) — SCM0002 고유(공통 COM0005 Ex 아님).
const MENU_ID = 'SCM0002';
const SHEET_NM = 'ProjectByDivPopup';

interface ProjectByDivisionPopupState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface ProjectByDivisionPopupAction {
  reset: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: ProjectByDivisionPopupState = {
  initialized: false,
  staticColumns: [],
};

export const useProjectByDivisionPopupStore = createPersistedStore<
  ProjectByDivisionPopupState & ProjectByDivisionPopupAction
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
  'modal-project-by-division'
);
