import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './auth-request.constants';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface AuthRequestState {
  initialized: boolean;
  filters: FiltersBySheet;
  staticColumns: { [key in SHEETS]: RawFlexGridColumnConfig[] };
  langCd: string;
  tmzCd: string;
}

interface AuthRequestAction {
  reset: () => void;
  initFilters: () => void;
  setLangCd: (langCd: string) => void;
  setTmzCd: (tmzCd: string) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initAuthRequestState: AuthRequestState = {
  initialized: false,
  filters: {
    [SHEETS.AUTHORITY]: undefined,
    [SHEETS.DIVISION]: undefined,
    [SHEETS.MY_AUTHORITY_LIST]: undefined,
    [SHEETS.USER_INFO]: undefined,
  },
  staticColumns: {
    [SHEETS.AUTHORITY]: [],
    [SHEETS.DIVISION]: [],
    [SHEETS.MY_AUTHORITY_LIST]: [],
    [SHEETS.USER_INFO]: [],
  },
  langCd: '',
  tmzCd: '',
};

export const useAuthRequestStore = createPersistedStoreWithTab<
  AuthRequestState & AuthRequestAction
>(
  set => ({
    ...initAuthRequestState,
    reset: () => set(initAuthRequestState),
    initFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        if (state.initialized) return;
        state.filters[SHEETS.AUTHORITY] = {};
        state.filters[SHEETS.DIVISION] = {};
        state.filters[SHEETS.MY_AUTHORITY_LIST] = { sesUserId };
        state.filters[SHEETS.USER_INFO] = { sesUserId };
        state.initialized = true;
      });
    },
    setLangCd: langCd => {
      set(state => {
        state.langCd = langCd;
      });
    },
    setTmzCd: tmzCd => {
      set(state => {
        state.tmzCd = tmzCd;
      });
    },
    fetchStaticColumns: async () => {
      const [authority, division, myAuth, userInfo] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.AUTHORITY,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.DIVISION,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MY_AUTHORITY_LIST,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.USER_INFO,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.AUTHORITY]: authority.data.result,
          [SHEETS.DIVISION]: division.data.result,
          [SHEETS.MY_AUTHORITY_LIST]: myAuth.data.result,
          [SHEETS.USER_INFO]: userInfo.data.result,
        };
      });
    },
  }),
  'auth-request'
);
