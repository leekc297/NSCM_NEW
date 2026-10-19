import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, LT_OP, MENU_ID, SHEETS, VALID_ALL } from './operation-lt.constants';
import type { SearchCondition } from './operation-lt.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch (실측 13행 등록됨, design 03 §1).
  //   미등록/실패 시 빈 배열 -> 그리드가 constants MAIN_COLUMNS fallback.
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionIds: [],
  ltOperationIds: [],
  plantSiteIds: [],
  itemId: '',
  validYn: VALID_ALL, // 기본 ALL (design 02 §4)
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열 (빈 배열 = 'ALL' 센티널, design 02 §5).
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useOperationLTStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // GET SP 파라미터 매핑 (design 03 §4-2 SCP0037_GET_OPERATION_LT 5 param):
    //   1 p_division_id  (콤보 체크값 콤마)
    //   2 p_scm_site_id  (clbPlantSite 콤마 다중)
    //   3 p_item_id      (txtItemId 텍스트, NICK_NAME LIKE 도 매칭)
    //   4 p_scm_valid_yn (ALL -> NULL: SITE_ITEM_VALID_YN 무필터)
    //   5 p_lt_operation (cboLTOperation 콤마 다중)
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: joinOrAll(c.divisionIds), // 1
            scmSiteId: joinOrAll(c.plantSiteIds), // 2
            itemId: orAll(c.itemId), // 3
            scmValidYn: c.validYn === VALID_ALL ? 'ALL' : c.validYn, // 4 (ALL -> SP NULL 처리)
            ltOperation: joinOrAll(c.ltOperationIds), // 5
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'operation-lt-store'
);

// LT Operation 선택이 INV_FLAG 컬럼 조건부 Visible 트리거인지 판정 (design 01 R6 / 03 §2).
//   AS-IS 는 단일 checked 값 == 'PRE_INSP' 비교(cs L854-861). 다중 선택 시 PRE_INSP 단독일 때만 표시.
export const isPreInspSelected = (ltOperationIds: string[]): boolean =>
  ltOperationIds.length === 1 && ltOperationIds[0] === LT_OP.PRE_INSP;
