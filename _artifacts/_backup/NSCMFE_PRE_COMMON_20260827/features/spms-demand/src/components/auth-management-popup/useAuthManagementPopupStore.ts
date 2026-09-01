import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  MENU_ID,
  RESPONSE_SET,
} from '../../pages/project-registration/project-registration.constants';

interface AuthManagementPopupState {
  initialized: boolean;
  staticColumns: {
    [RESPONSE_SET.POPUP_USER]: RawFlexGridColumnConfig[];
    [RESPONSE_SET.POPUP_AUTH_WRITE]: RawFlexGridColumnConfig[];
    [RESPONSE_SET.POPUP_AUTH_READ]: RawFlexGridColumnConfig[];
    [RESPONSE_SET.POPUP_AUTH_REQ]: RawFlexGridColumnConfig[];
  };
}

interface AuthManagementPopupAction {
  fetchStaticColumns: () => Promise<void>;
  reset: () => void;
}

const initState: AuthManagementPopupState = {
  initialized: false,
  staticColumns: {
    [RESPONSE_SET.POPUP_USER]: [],
    [RESPONSE_SET.POPUP_AUTH_WRITE]: [],
    [RESPONSE_SET.POPUP_AUTH_READ]: [],
    [RESPONSE_SET.POPUP_AUTH_REQ]: [],
  },
};

// RegionModal(공용 국가/도시 팝업)과 달리 이 팝업은 SDM1010 화면 전용 시트만 다루므로
// MENU_ID 를 별도 모듈로 분리하지 않고 project-registration.constants 의 SHEETS.POPUP_* 를 그대로 쓴다.
export const useAuthManagementPopupStore = createPersistedStoreWithTab<
  AuthManagementPopupState & AuthManagementPopupAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    fetchStaticColumns: async () => {
      const [user, authWrite, authRead, authReq] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.POPUP_USER,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.POPUP_AUTH_WRITE,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.POPUP_AUTH_READ,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.POPUP_AUTH_REQ,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.POPUP_USER]: user.data.result,
          [RESPONSE_SET.POPUP_AUTH_WRITE]: authWrite.data.result,
          [RESPONSE_SET.POPUP_AUTH_READ]: authRead.data.result,
          [RESPONSE_SET.POPUP_AUTH_REQ]: authReq.data.result,
        };
        state.initialized = true;
      });
    },
  }),
  'project-registration-auth-management-popup-v2'
);
