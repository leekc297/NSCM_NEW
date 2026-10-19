import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

// City by Country 공용 팝업 = 표준 COM0001(PKG_COM0000.P_COM0001_GET_CITY_BY_COUNTRY_POPUP).
//   SCP0001 COUNTRY/CITY 셀(R-20)이 이 팝업을 연다 — 공용 메뉴 재사용(등록 불요).
const MODAL_MENU = 'COM0001' as const;
const MODAL_COLUMN_SHEET = 'countryPopup';

interface State {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}
interface Action {
  fetchStaticColumns: () => Promise<void>;
}

export const useCityByCountryModalStore = createPersistedStore<State & Action>(set => ({
  initialized: false,
  staticColumns: [],
  fetchStaticColumns: async () => {
    const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
      `/admin/menu/${MODAL_MENU}/column`,
      { sheetNm: MODAL_COLUMN_SHEET }
    );
    set(state => {
      state.staticColumns = columns.data.result;
      state.initialized = true;
    });
  },
}), 'plant-site-city-modal');
