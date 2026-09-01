import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './nn-master-mapping.constants';
import type { SearchCondition } from './nn-master-mapping.types';

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN> };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // BE 메타 SHEET_COLUMNS 동적 fetch (admin UI Category Setup 즉시 반영, 룰 #65)
  staticColumns: { main: RawFlexGridColumnConfig[] };
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

// AS-IS .cs L479-485 의 7개 search param + 'ALL' sentinel
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
  staticColumns: { main: [] },
};

export const useNnMasterMappingStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
        if (p.divisionId) {
          state.filters = initState.filters;
          void state.fetchStaticColumns();
        }
      }),
    setFilter: () =>
      set(state => {
        state.filters = { [SHEETS.MAIN]: state.searchCondition };
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    /**
     * fetchStaticColumns — admin SHEET_COLUMNS 동적 fetch (DMF0004 표준).
     * 메모리 feedback_admin_meta_dynamic_fetch + feedback_grid_no_hardcoded_static_columns.
     * BE: POST /admin/menu/{MENU_ID}/column { sheetNm }
     */
    fetchStaticColumns: async () => {
      const fetchOne = async (sheetNm: string): Promise<RawFlexGridColumnConfig[]> => {
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm }
          );
          const result = res.data?.result;
          if (!Array.isArray(result)) return [];
          // SP PR_GET_SHEET_COLUMN_LIST 가 VISIBLE_FLAG 'Y'/'N' VARCHAR2 반환.
          // BE Jackson 변환에 따라 키가 visible / visibleFlag / VISIBLE_FLAG 중 하나로 도착 → 모두 체크.
          // 값도 boolean / 'Y' / 'N' 모두 대응 (admin UI Category Setup visible='N' 즉시 반영 의무, 룰 #65).
          const isFalsy = (v: unknown) => v === false || v === 'N' || v === 'n';
          return result.map(c => {
            const raw = c as unknown as Record<string, unknown>;
            const visibleRaw = raw.visible ?? raw.visibleFlag ?? raw.VISIBLE_FLAG;
            const displayRaw = raw.display ?? raw.displayFlag ?? raw.DISPLAY_FLAG;
            return {
              ...c,
              visible: !isFalsy(visibleRaw),
              display: !isFalsy(displayRaw),
            };
          });
        } catch {
          return [];
        }
      };
      const main = await fetchOne(SHEETS.MAIN);
      set(state => {
        state.staticColumns = { main };
        state.initialized = true;
      });
    },
  }),
  'nn-master-mapping'
);
