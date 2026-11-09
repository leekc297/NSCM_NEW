import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore, useSessionStore } from '@shared/stores';

import { MODAL_ITEM_BY_DIVISION, MODAL_NAME } from './item-by-division-modal.constants';

interface ItemByDivisionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  divisionId?: string;
}

interface ItemByDivisionModalAction {
  reset: () => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

const initItemByDivisionModalState: ItemByDivisionModalState = {
  initialized: false,
  staticColumns: [],
  divisionId: useSessionStore.getState().session.div ?? '40',
} as const;

export const useItemByDivisionModalStore = createPersistedStore<
  ItemByDivisionModalState & ItemByDivisionModalAction
>(
  set => ({
    ...initItemByDivisionModalState,
    reset: () => set(initItemByDivisionModalState),
    fetchStaticColumns: async (divisionId?: string) => {
      const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_ITEM_BY_DIVISION}/column`,
        {
          sheetNm: MODAL_NAME,
          // 사업부를 그대로 넘긴다 — 컬럼 메타 SP 가 사업부 전용 시트(itemByDivisionPopup_{사업부})와
          //   칸별 DIVISION_ID 지정을 이 값으로 고른다. 종전에는 40 만 넘겨 82 전용 칸(MDL_GR)을 걸러낼 수 없었다.
          //   2026-11-06 개발 DB 실측: 빈 값 · ALL · 40 · 81 계열 6종 · 82 · '40,81' 11가지 모두 응답이 종전과 같다
          //   (_40 외 사업부 시트 없음, 사업부 지정 칸 0건). 빈 값은 종전처럼 보내지 않는다.
          divisionId: divisionId || undefined,
        }
      );
      set(state => {
        state.initialized = true;
        state.staticColumns = regionColumns.data.result;
        state.divisionId = divisionId;
      });
    },
  }),
  'modal-item-by-division'
);
