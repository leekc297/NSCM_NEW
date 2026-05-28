import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './user-management.constants';

interface SearchParamProps {
  user: string;
  department: string;
  group: string;
  useYn: string;
}

interface UserManagementState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.USER_MGMT>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  openSsoUserModal: boolean;
  openSsoDeptModal: boolean;
}

interface UserManagementAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenSsoUserModal: (value: boolean) => void;
  setOpenSsoDeptModal: (value: boolean) => void;
}

const initUserManagementParam: SearchParamProps = {
  user: '',
  department: '',
  group: 'ALL',
  useYn: 'Y',
};

const initUserManagementState: UserManagementState = {
  initialized: false,
  filters: undefined,
  searchParams: initUserManagementParam,
  staticColumns: [],
  isOpenSearchArea: true,
  openSsoUserModal: false,
  openSsoDeptModal: false,
} as const;

export const useUserManagementStore = createPersistedStoreWithTab<
  UserManagementState & UserManagementAction
>(
  (set, get) => ({
    ...initUserManagementState,
    reset: () => set(initUserManagementState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.USER_MGMT,
        }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );

      if (param.data.result?.length > 0) {
        const searchParams = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);

        set(state => {
          state.searchParams = searchParams;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setOpenSsoUserModal: value => {
      set(state => {
        state.openSsoUserModal = value;
      });
    },
    setOpenSsoDeptModal: value => {
      set(state => {
        state.openSsoDeptModal = value;
      });
    },
  }),
  'user-management'
);
