import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './auth-approval.constants';
import type { SearchCondition } from './auth-approval.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface AuthApprovalState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface AuthApprovalAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchSearchConditions: () => Promise<void>;
  fetchStaticColumns: () => Promise<void>;
}

const fmt = (d: Date) =>
  `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
const today = new Date();
const oneMonthBefore = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());

const initSearch: SearchCondition = {
  userId: '',
  startDate: fmt(oneMonthBefore),
  endDate: fmt(today),
  status: 'REQUEST',
};

export const useAuthApprovalStore = createPersistedStoreWithTab<
  AuthApprovalState & AuthApprovalAction
>(
  (set, get) => ({
    initialized: false,
    filters: {},
    searchCondition: { ...initSearch },
    openSearchArea: true,
    staticColumns: [],

    reset: () => {
      set(state => {
        state.filters = {};
        state.searchCondition = { ...initSearch };
        state.staticColumns = [];
      });
    },
    setSearchCondition: params => {
      set(state => {
        state.searchCondition = { ...state.searchCondition, ...params };
      });
    },
    setFilter: () => {
      const { searchCondition } = get();
      set(state => {
        state.filters[SHEETS.MAIN] = (searchCondition as unknown) as ProcRequest<
          MENU_ID,
          SHEETS.MAIN
        >;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    fetchStaticColumns: async () => {
      const res = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = res.data.result;
      });
    },
    fetchSearchConditions: async () => {
      if (get().initialized) return;
      try {
        const param = await apiClient.get<
          { paramNm: keyof SearchCondition; paramCtn: string }[]
        >(`/admin/menu/${MENU_ID}/search-conditions`);

        if (param.data.result?.length > 0) {
          const restored = param.data.result.reduce((acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          }, {} as Partial<SearchCondition>);
          set(state => {
            state.searchCondition = { ...state.searchCondition, ...restored };
          });
        }
      } catch {
        // silently fail
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'auth-approval'
);
