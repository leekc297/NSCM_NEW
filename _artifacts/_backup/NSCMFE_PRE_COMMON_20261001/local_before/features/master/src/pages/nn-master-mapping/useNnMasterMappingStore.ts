import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './nn-master-mapping.constants';
import type { SearchCondition } from './nn-master-mapping.types';
import type { SearchComboTrigger } from './utils/searchCombos';

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN> };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  /**
   * End Customer / Sales Site 콤보 원천을 정하는 "마지막에 바뀐 항목".
   *
   * searchCondition 바깥에 둔다 - setFilter 가 그 객체를 통째로 proc 요청에 실으므로 안에 두면
   * 서버가 모르는 필드가 조회 파라미터로 새어 나간다. 초기값은 진입 경로와 같은 필터 쪽이다.
   */
  comboTrigger: SearchComboTrigger;
  openSearchArea: boolean;
  // BE 메타 SHEET_COLUMNS 동적 fetch (admin UI Category Setup 즉시 반영, 룰 #65)
  staticColumns: { main: RawFlexGridColumnConfig[] };
  // Data Type SP 는 조회조건을 받지 않는다. store 필드로 참조를 고정해 다른 조회조건 변경 시
  // Data Type 콤보가 불필요하게 재조회되는 걸 막는다.
  noFilters: Record<string, never>;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>, comboTrigger?: SearchComboTrigger) => void;
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
  comboTrigger: 'team',
  openSearchArea: true,
  staticColumns: { main: [] },
  noFilters: {},
};

export const useNnMasterMappingStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: (p: Partial<SearchCondition>, comboTrigger?: SearchComboTrigger) =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
        if (comboTrigger) state.comboTrigger = comboTrigger;
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
