import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { SHEETS, MENU_ID } from './group-menu.constants';

type filtersBySheet = {
  [SHEETS.GROUP]?: ProcRequest<MENU_ID, SHEETS.GROUP>;
  [SHEETS.MENU]?: ProcRequest<MENU_ID, SHEETS.MENU>;
  [SHEETS.BUTTON]?: ProcRequest<MENU_ID, SHEETS.BUTTON>;
};

interface GroupMenuState {
  initialized: boolean;
  loading: boolean;
  filters: filtersBySheet;
  staticColumns: {
    [key in SHEETS]: RawFlexGridColumnConfig[];
  };
  isOpenSearchArea: boolean;
  menuGridCleared: boolean;
  buttonGridCleared: boolean;
}

type PROC_ID = SHEETS.GROUP | SHEETS.MENU | SHEETS.BUTTON;

interface GroupMenuAction {
  reset: () => void;
  setFilters: <T extends PROC_ID>(sheet: T, filters: filtersBySheet[T]) => void;
  fetchStaticColumns: () => void;
}

const initGroupMenuState: GroupMenuState = {
  initialized: false,
  loading: false,
  filters: {
    [SHEETS.GROUP]: undefined,
    [SHEETS.MENU]: undefined,
    [SHEETS.BUTTON]: undefined,
  },
  staticColumns: {
    [SHEETS.GROUP]: [],
    [SHEETS.MENU]: [],
    [SHEETS.BUTTON]: [],
  },
  isOpenSearchArea: false,
  menuGridCleared: false,
  buttonGridCleared: false,
} as const;

export const useGroupMenuStore = createPersistedStoreWithTab<GroupMenuState & GroupMenuAction>(
  set => ({
    ...initGroupMenuState,
    reset: () => set(initGroupMenuState),
    setFilters: (sheet, filters) => {
      set(state => {
        state.filters[sheet] = { ...filters };
        if (sheet === SHEETS.GROUP) {
          state.filters[SHEETS.MENU] = undefined;
          state.filters[SHEETS.BUTTON] = undefined;
        } else if (sheet === SHEETS.MENU) state.filters[SHEETS.BUTTON] = undefined;
      });
    },
    fetchStaticColumns: () => {
      void (async () => {
        const [group, menu, button] = await Promise.all([
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: SHEETS.GROUP,
          }),
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: SHEETS.MENU,
          }),
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: SHEETS.BUTTON,
          }),
        ]);
        set(state => {
          state.staticColumns = {
            [SHEETS.GROUP]: group.data.result,
            [SHEETS.MENU]: menu.data.result,
            [SHEETS.BUTTON]: button.data.result,
          };
          state.initialized = true;
        });
      })();
    },
  }),
  'group-menu-management'
);
