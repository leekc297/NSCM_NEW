import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../plant-site.constants';

// Vendor 검색 팝업 = 화면 전용 시트 SCP0001.vendor(PKG_SCM0002.P_SCM0002_GET_VENDOR_POPUP 배선,
//   05_register.sql — MNU_BTN_MPG/API_M/PROC_M/컬럼메타). PLANT_NAME(신규행 R-17)·HQ Vendor(R-18) 셀이 연다.
const MODAL_COLUMN_SHEET: SHEETS = SHEETS.VENDOR;

interface State {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}
interface Action {
  fetchStaticColumns: () => Promise<void>;
}

export const useVendorModalStore = createPersistedStore<State & Action>(set => ({
  initialized: false,
  staticColumns: [],
  fetchStaticColumns: async () => {
    const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
      `/admin/menu/${MENU_ID}/column`,
      { sheetNm: MODAL_COLUMN_SHEET }
    );
    set(state => {
      state.staticColumns = columns.data.result;
      state.initialized = true;
    });
  },
}), 'plant-site-vendor-modal');
