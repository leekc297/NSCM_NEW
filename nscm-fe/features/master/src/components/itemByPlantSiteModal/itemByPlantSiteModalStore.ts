import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore, useSessionStore } from '@shared/stores';

import { MODAL_ITEM_BY_PLANT_SITE, MODAL_NAME } from './item-by-plant-site-modal.constants';

interface ItemByPlantSiteModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  divisionId?: string;
}

interface ItemByPlantSiteModalAction {
  reset: () => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

const initItemByPlantSiteModalState: ItemByPlantSiteModalState = {
  initialized: false,
  staticColumns: [],
  divisionId: useSessionStore.getState().session.div ?? '40',
} as const;

export const useItemByPlantSiteModalStore = createPersistedStore<
  ItemByPlantSiteModalState & ItemByPlantSiteModalAction
>(
  set => ({
    ...initItemByPlantSiteModalState,
    reset: () => set(initItemByPlantSiteModalState),
    fetchStaticColumns: async (divisionId?: string) => {
      // admin 컬럼 메타(SCM_MST_SHEET_COLUMNS, PROGRAM_ID=COM0014). 미배포면 빈 배열 → 컴포넌트가
      //   constants 고정 컬럼으로 fallback 렌더(admin 우선 + constants fallback 공통 패턴).
      //   메타 등록 SQL 배포 전에는 /admin/menu/COM0014/column 이 비거나 실패할 수 있으므로 catch 해
      //   initialized 만 세운다 — 모달은 constants fallback 으로 정상 렌더된다.
      try {
        const regionColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MODAL_ITEM_BY_PLANT_SITE}/column`,
          {
            sheetNm: MODAL_NAME,
            divisionId: divisionId === '40' ? '40' : undefined,
          }
        );
        set(state => {
          state.initialized = true;
          state.staticColumns = regionColumns.data.result ?? [];
          state.divisionId = divisionId;
        });
      } catch {
        set(state => {
          state.initialized = true;
          state.staticColumns = [];
          state.divisionId = divisionId;
        });
      }
    },
  }),
  'modal-item-by-plant-site'
);
