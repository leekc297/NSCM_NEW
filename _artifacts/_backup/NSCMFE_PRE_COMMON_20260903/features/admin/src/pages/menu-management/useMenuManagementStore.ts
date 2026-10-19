import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { SHEETS, MENU_ID } from './menu-management.constants';

type filtersBySheet = {
  [SHEETS.LEVEL_ONE_MENU]?: ProcRequest<MENU_ID, SHEETS.LEVEL_ONE_MENU>;
  [SHEETS.LEVEL_TWO_MENU]?: ProcRequest<MENU_ID, SHEETS.LEVEL_TWO_MENU>;
  [SHEETS.LEVEL_THREE_MENU]?: ProcRequest<MENU_ID, SHEETS.LEVEL_THREE_MENU>;
};

interface MenuManagementState {
  initialized: boolean;
  loading: boolean;
  filters: filtersBySheet;
  staticColumns: {
    [key in SHEETS]: RawFlexGridColumnConfig[];
  };
  isOpenSearchArea: boolean;
  levelTwoMenuCleared: boolean;
  levelThreeMenuCleared: boolean;
  clickedLevelOneMenu: string;
  clickedLevelTwoMenu: string;
  clickedRow: number;
  openMessageModal: boolean;
}

type PROC_ID = SHEETS.LEVEL_ONE_MENU | SHEETS.LEVEL_TWO_MENU | SHEETS.LEVEL_THREE_MENU;

interface MenuManagementAction {
  reset: () => void;
  setFilters: <T extends PROC_ID>(sheet: T, filters: filtersBySheet[T]) => void;
  fetchStaticColumns: () => Promise<void>;
  setClickedLevelOneMenu: (menuId: string) => void;
  setClickedLevelTwoMenu: (menuId: string) => void;
  setClickedRow: (value: number) => void;
  setOpenMessageModal: (value: boolean) => void;
}

const initMenuManagementState: MenuManagementState = {
  initialized: false,
  loading: false,
  filters: {
    [SHEETS.LEVEL_ONE_MENU]: undefined,
    [SHEETS.LEVEL_TWO_MENU]: undefined,
    [SHEETS.LEVEL_THREE_MENU]: undefined,
  },
  staticColumns: {
    [SHEETS.LEVEL_ONE_MENU]: [],
    [SHEETS.LEVEL_TWO_MENU]: [],
    [SHEETS.LEVEL_THREE_MENU]: [],
  },
  isOpenSearchArea: false,
  levelTwoMenuCleared: false,
  levelThreeMenuCleared: false,
  clickedLevelOneMenu: '',
  clickedLevelTwoMenu: '',
  clickedRow: -1,
  openMessageModal: false,
} as const;

export const useMenuManagementStore = createPersistedStoreWithTab<
  MenuManagementState & MenuManagementAction
>(
  set => ({
    ...initMenuManagementState,
    reset: () => set(initMenuManagementState),
    setFilters: (sheet, filter) => {
      set(state => {
        state.filters[sheet] = { ...filter };
        if (sheet === SHEETS.LEVEL_ONE_MENU) {
          state.filters[SHEETS.LEVEL_TWO_MENU] = undefined;
          state.filters[SHEETS.LEVEL_THREE_MENU] = undefined;
        } else if (sheet === SHEETS.LEVEL_TWO_MENU)
          state.filters[SHEETS.LEVEL_THREE_MENU] = undefined;
      });
    },
    fetchStaticColumns: async () => {
      const [levelOneMenu, levelTwoMenu, levelThreeMenu] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LEVEL_ONE_MENU,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LEVEL_TWO_MENU,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LEVEL_THREE_MENU,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.LEVEL_ONE_MENU]: levelOneMenu.data.result,
          [SHEETS.LEVEL_TWO_MENU]: levelTwoMenu.data.result,
          [SHEETS.LEVEL_THREE_MENU]: levelThreeMenu.data.result,
        };
        state.initialized = true;
      });
    },
    setClickedLevelOneMenu: menuId => {
      set(state => {
        state.clickedLevelOneMenu = menuId;
      });
    },
    setClickedLevelTwoMenu: menuId => {
      set(state => {
        state.clickedLevelTwoMenu = menuId;
      });
    },
    setClickedRow: value => {
      set(state => {
        state.clickedRow = value;
      });
    },
    setOpenMessageModal: value => {
      set(state => {
        state.openMessageModal = value;
      });
    },
  }),
  'menu-management'
);
