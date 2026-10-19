import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './outsourcing-capacity.constants';
import type { SearchCondition } from './outsourcing-capacity.types';

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
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (13행 등록됨, design 03 §0).
  //   미등록/실패 시 빈 배열 → 그리드가 constants(MAIN_COLUMNS) fallback.
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
  // 기본 사업부 = 세션 division (supply 표준, formation/tact-time 동일). Division 콤보가 첫 옵션으로 교정.
  divisionId: useSessionStore.getState().session.div ?? '',
  plantSiteIds: [],
  itemId: '',
  nickName: '',
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

// 다중 선택 배열 -> GET SP 파라미터 문자열. Plant Site 는 콤마(,) 구분.
//   근거: AS-IS SCP0023_GET_OUTSOURCING_CAPA 가 String_Split(@p_plant_site_id, ',') 로 분할(asis.py 실측
//   2026-09-22, convert-sp). TO-BE PKG_SCP0023 GET 도 콤마 정규화. (design 02 §6-4 의 '^' 표기는 SP 실측으로 정정.)
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useOutsourcingCapacityStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // GET 파라미터 (design 00 §4 / 03 §4.1): p_division_id, p_plant_site_id, p_item_id, p_valid,
    //   debug_mode, p_nick_name. p_valid/debug_mode 는 상수(AS-IS FindData_Main cs:367-372).
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orAll(c.divisionId),
            plantSiteId: joinOrAll(c.plantSiteIds),
            itemId: orAll(c.itemId),
            nickName: orAll(c.nickName),
            valid: 'ALL',
            debugMode: 'N',
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
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
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
  'outsourcing-capacity-store'
);
