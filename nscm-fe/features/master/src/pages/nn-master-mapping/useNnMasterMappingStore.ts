import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { MENU_ID } from './nn-master-mapping.constants';
import { MENU_ID as MENU_ID_CONST, SHEETS } from './nn-master-mapping.constants';

interface SearchCondition {
  dataTypeCode: string;
  divisionId: string;
  deptId: string;
  endCustomer: string;
  scmSiteId: string;
  projectCode: string;
  itemId: string;
}

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN> };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // ⭐ ui-dynamic-property-management.md §4 — admin SCM_MST_SHEET_COLUMNS 동적 fetch.
  staticColumns: {
    [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  };
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

// AS-IS .cs L479-485 의 7개 search param + 'ALL' sentinel 사용
const initSearch: SearchCondition = {
  dataTypeCode: 'ALL',
  divisionId: '81',
  deptId: 'ALL',
  endCustomer: 'ALL',
  scmSiteId: 'ALL',
  projectCode: '',
  itemId: '',
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: {
    [SHEETS.MAIN]: [],
  },
};

export const useNnMasterMappingStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () =>
      set(state => {
        state.filters = { [SHEETS.MAIN]: state.searchCondition };
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // ⭐ ui-category-setup-column-meta.md §3 / DMF0004 표준 패턴.
    fetchStaticColumns: async () => {
      const main = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID_CONST}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result ?? [],
        };
      });
      if (!get().initialized) {
        set(state => {
          state.initialized = true;
        });
      }
    },
  }),
  'nn-master-mapping'
);
