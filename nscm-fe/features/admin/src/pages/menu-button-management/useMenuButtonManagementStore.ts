import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './menu-button-management.constants';

interface SearchParamProps {
  menuId: string;
  sheetNm: string;
  btnCd: string;
  apiNm: string;
  useYn: string;
}

interface MenuButtonManagementState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.LIST>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  openMessageModal: boolean;
}

interface MenuButtonManagementAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenMessageModal: (value: boolean) => void;
}

const initMenuButtonManagementParam: SearchParamProps = {
  menuId: 'ALL',
  sheetNm: '',
  btnCd: 'ALL',
  apiNm: '',
  useYn: 'Y',
};

const initMenuButtonManagementState: MenuButtonManagementState = {
  initialized: false,
  filters: undefined,
  searchParams: initMenuButtonManagementParam,
  staticColumns: [],
  isOpenSearchArea: true,
  openMessageModal: false,
} as const;

export const useMenuButtonManagementStore = createPersistedStoreWithTab<
  MenuButtonManagementState & MenuButtonManagementAction
>(
  (set, get) => ({
    ...initMenuButtonManagementState,
    reset: () => set(initMenuButtonManagementState),
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
          sheetNm: SHEETS.LIST,
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
        const searchParams = param.data.result.reduce(
          (acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          },
          { ...initMenuButtonManagementParam, useYn: '' } as SearchParamProps
        );

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
    setOpenMessageModal: value => {
      set(state => {
        state.openMessageModal = value;
      });
    },
  }),
  'menu-button-management'
);
