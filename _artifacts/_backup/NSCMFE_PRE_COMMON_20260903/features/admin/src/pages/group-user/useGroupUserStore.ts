import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS, UNIT_TP_CD } from './group-user.constants';

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.USER_INFO]: RawFlexGridColumnConfig[];
  [SHEETS.DIVISION]: RawFlexGridColumnConfig[];
};

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.USER_INFO]?: ProcRequest<MENU_ID, SHEETS.USER_INFO>;
  [SHEETS.DIVISION]?: ProcRequest<MENU_ID, SHEETS.DIVISION>;
};

interface SearchParamProps {
  search: string;
}

interface GroupUserState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  staticColumns: StaticColumnsBySheet;
  selectedUserGrId: string;
  selectedUserId: string;
  isOpenSearchArea: boolean;
  focusSheet: SHEETS;
}

interface GroupUserAction {
  reset: () => void;
  setSearchParams: (params: Partial<SearchParamProps>) => void;
  setMainFilter: () => void;
  setSelectedUserGrId: (id: string) => void;
  setSelectedUserId: (id: string) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setFocusSeet: (sheet: SHEETS) => void;
}

const initSearch: SearchParamProps = { search: '' };

const initState: GroupUserState = {
  initialized: false,
  filters: {},
  searchParams: initSearch,
  staticColumns: {
    [SHEETS.MAIN]: [],
    [SHEETS.USER_INFO]: [],
    [SHEETS.DIVISION]: [],
  },
  selectedUserGrId: '',
  selectedUserId: '',
  isOpenSearchArea: true,
  focusSheet: SHEETS.MAIN,
} as const;

export const useGroupUserStore = createPersistedStoreWithTab<GroupUserState & GroupUserAction>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: params => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
    },
    setMainFilter: () => {
      set(state => {
        state.filters[SHEETS.MAIN] = { ...state.searchParams } as ProcRequest<MENU_ID, SHEETS.MAIN>;
      });
    },
    setSelectedUserGrId: id => {
      set(state => {
        state.selectedUserGrId = id;
        state.selectedUserId = '';
        state.filters[SHEETS.USER_INFO] = { userGrId: id } as ProcRequest<
          MENU_ID,
          SHEETS.USER_INFO
        >;
        state.filters[SHEETS.DIVISION] = undefined;
      });
    },
    setSelectedUserId: id => {
      const userGrId = get().selectedUserGrId;
      set(state => {
        state.selectedUserId = id;
        state.filters[SHEETS.DIVISION] = {
          userGrId,
          userId: id,
          unitTpCd: UNIT_TP_CD.DIVISION,
        } as ProcRequest<MENU_ID, SHEETS.DIVISION>;
      });
    },
    fetchStaticColumns: async () => {
      const [main, userInfo, division] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MAIN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.USER_INFO,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.DIVISION,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
          [SHEETS.USER_INFO]: userInfo.data.result,
          [SHEETS.DIVISION]: division.data.result,
        };
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setFocusSeet: sheet => {
      set(state => {
        state.focusSheet = sheet;
      });
    },
  }),
  'group-user'
);
