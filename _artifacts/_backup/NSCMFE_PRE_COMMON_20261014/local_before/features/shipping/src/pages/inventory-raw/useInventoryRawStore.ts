import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, DIVISION_FIXED, MENU_ID, SHEETS } from './inventory-raw.constants';
import type { InventoryRawSearchParams } from './inventory-raw.types';

interface InventoryRawState {
  searchParams: InventoryRawSearchParams;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  openItemModal: boolean;
}

interface InventoryRawAction {
  reset: () => void;
  setSearchParams: (patch: Partial<InventoryRawSearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenItemModal: (open: boolean) => void;
}

const initSearchParams: InventoryRawSearchParams = {
  divisionId: DIVISION_FIXED,
  plantSiteIds: [],
  inventoryType: '',
  planStartYyyymmdd: '',
  itemId: '',
};

const initState: InventoryRawState = {
  searchParams: initSearchParams,
  filters: undefined,
  staticColumns: [],
  isOpenSearchArea: true,
  openItemModal: false,
};

export const useInventoryRawStore = createPersistedStoreWithTab<
  InventoryRawState & InventoryRawAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      });
    },
    // SP `SSP.SSP0017_GET_INVENTORY_RAW` IN 5개(division/plant_site/item_id/inventory_type/
    //   plan_start_yyyymmdd) — user_id/program_id/sheet_name/language 는 BE 세션·라우트 자동 주입
    //   (convert-core §3.5 @LoginUser 주입 규약과 동일, DMF0004 SalesSite 표준과 일치).
    setFilters: () => {
      const sp = get().searchParams;
      set(state => {
        state.filters = {
          divisionId: sp.divisionId,
          plantSite: sp.plantSiteIds.join(','),
          itemId: sp.itemId,
          inventoryType: sp.inventoryType,
          planStartYyyymmdd: sp.planStartYyyymmdd,
        };
      });
    },
    // keep-alive 탭에 남은 이전 filters 무효화(nscm-patterns §5-7 진입 자동조회 금지 게이트).
    clearFilters: () => {
      set(state => {
        state.filters = undefined;
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setOpenItemModal: open => {
      set(state => {
        state.openItemModal = open;
      });
    },
  }),
  'inventory-raw'
);
