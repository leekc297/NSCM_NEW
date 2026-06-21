import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS, UNIT_TP_CD } from './group-user.constants';

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.USER_INFO]: RawFlexGridColumnConfig[];
  [SHEETS.DIVISION]: RawFlexGridColumnConfig[];
  [SHEETS.PLANT]: RawFlexGridColumnConfig[];
  [SHEETS.CUSTOMER]: RawFlexGridColumnConfig[];
};

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.USER_INFO]?: ProcRequest<MENU_ID, SHEETS.USER_INFO>;
  [SHEETS.DIVISION]?: ProcRequest<MENU_ID, SHEETS.DIVISION>;
  [SHEETS.PLANT]?: ProcRequest<MENU_ID, SHEETS.PLANT>;
  [SHEETS.CUSTOMER]?: ProcRequest<MENU_ID, SHEETS.CUSTOMER>;
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
}

interface GroupUserAction {
  reset: () => void;
  setSearchParams: (params: Partial<SearchParamProps>) => void;
  setMainFilter: () => void;
  setSelectedUserGrId: (id: string) => void;
  setSelectedUserId: (id: string) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
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
    [SHEETS.PLANT]: [],
    [SHEETS.CUSTOMER]: [],
  },
  selectedUserGrId: '',
  selectedUserId: '',
  isOpenSearchArea: true,
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
        state.filters[SHEETS.PLANT] = undefined;
        state.filters[SHEETS.CUSTOMER] = undefined;
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
        state.filters[SHEETS.PLANT] = {
          userGrId,
          userId: id,
          unitTpCd: UNIT_TP_CD.PLANT,
        } as ProcRequest<MENU_ID, SHEETS.PLANT>;
        state.filters[SHEETS.CUSTOMER] = {
          userGrId,
          userId: id,
          unitTpCd: UNIT_TP_CD.CUSTOMER,
        } as ProcRequest<MENU_ID, SHEETS.CUSTOMER>;
      });
    },
    fetchStaticColumns: async () => {
      const [main, userInfo, division, plant, customer] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MAIN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.USER_INFO,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.DIVISION,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.PLANT,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.CUSTOMER,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
          [SHEETS.USER_INFO]: userInfo.data.result,
          [SHEETS.DIVISION]: division.data.result,
          [SHEETS.PLANT]: plant.data.result,
          [SHEETS.CUSTOMER]: customer.data.result,
        };
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
  }),
  'group-user'
);
