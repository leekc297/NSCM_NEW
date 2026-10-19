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
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
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
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 배열 역직렬화 키(SubTitle F6 저장은 배열=콤마join 평문화 — personalizeCondition).
const ARRAY_KEYS = new Set<string>(['plantSiteIds']);

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
  conditionsRestored: false,
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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화하고 그리드도 초기화한다
    //   (사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, 정본 SCP0025 setDivision 1:1).
    //   이 화면엔 유지 대상 기간/날짜 필드가 없다(검색조건 = division/plantSite/item/nick) → Division 만 새 값으로 두고
    //   나머지(plantSiteIds/itemId/nickName)는 initSearch 로 되돌린다. 편집중(dirty) 가드(MSG00704)는 Form onChange
    //   의 confirmIfDirtyKey 가 처리한다(commit 51d4e9fa 패턴) — 통과 후 호출되므로 미저장 편집 폐기는 안전.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch, // Division 제외 전 조건 초기화(plantSite/item/nick)
          divisionId,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태(미저장 편집행도 함께 소거)
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 역직렬화(배열 split, 나머지 그대로).
    //   저장분 없으면 기본값 유지.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          patch[paramNm] = ARRAY_KEYS.has(paramNm) ? (val ? val.split(',').filter(Boolean) : []) : val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'outsourcing-capacity-store'
);
