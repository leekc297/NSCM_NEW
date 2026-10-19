import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

// Customer 공용 팝업 = 표준 COM0002(PKG_COM0000.P_COM0002_GET_CUSTOMER_BY_DIVISION_POPUP).
//   SCP0001 SOLDTO/SHIPTO 셀(R-27)이 division 파라미터로 이 팝업을 연다 — 공용 메뉴 재사용.
//   주의(§2.6 잔여): design 03 §1.3 은 AS-IS PlantCustomerbyDivision 을 지목한다. TO-BE 표준
//   COM0002 로 재사용하되 후보 집합 의미 패리티(PlantCustomer vs Customer)는 확인 대상으로 남긴다.
const MODAL_MENU = 'COM0002' as const;
const MODAL_COLUMN_SHEET = 'customerPopup';

interface State {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}
interface Action {
  fetchStaticColumns: () => Promise<void>;
}

export const useCustomerModalStore = createPersistedStore<State & Action>(set => ({
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
}), 'plant-site-customer-modal');
