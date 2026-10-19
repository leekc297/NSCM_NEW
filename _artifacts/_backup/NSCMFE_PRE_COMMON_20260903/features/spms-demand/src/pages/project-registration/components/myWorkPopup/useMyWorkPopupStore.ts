import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, RESPONSE_SET } from '../../project-registration.constants';

// My Work 팝업 전용 미니 store — RegionModal(packages 공용 팝업)과 동일하게, 이 팝업이 필요로
// 하는 상태(그리드 컬럼 메타)만 따로 둔다. 팝업 열림/닫힘·대상 프로젝트는 이 store 가 아니라
// 호출부(MyProjectGrid.tsx)의 로컬 useState 가 갖는다(RegionModal 과 동일한 소유 방식).
interface MyWorkPopupState {
  /** 컬럼 메타 로드가 끝났는지 — 팝업 재오픈 시 중복 조회 방지용 */
  initialized: boolean;
  /** 샘플 일정 그리드 컬럼 메타 — /admin/menu/SDM1010/column 에서 받아온다 */
  staticColumns: RawFlexGridColumnConfig[];
}

interface MyWorkPopupAction {
  fetchStaticColumns: () => Promise<void>;
  reset: () => void;
}

export const useMyWorkPopupStore = createPersistedStoreWithTab<
  MyWorkPopupState & MyWorkPopupAction
>(
  set => ({
    initialized: false,
    staticColumns: [],
    reset: () => set({ initialized: false, staticColumns: [] }),
    fetchStaticColumns: async () => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: RESPONSE_SET.POPUP_MY_WORK }
      );
      set(state => {
        state.staticColumns = columns.data.result;
        state.initialized = true;
      });
    },
  }),
  'project-registration-my-work-popup'
);
