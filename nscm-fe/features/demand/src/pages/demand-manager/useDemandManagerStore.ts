import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { DIVISION_40, MENU_ID, SHEETS } from './demand-manager.constants';
import type { SearchCondition } from './demand-manager.types';

// SP filter payload — useTabProcQuery 는 filters 를 참조로 비교하므로 store 참조를 그대로 넘긴다
// (인라인 객체 금지 — 무한 재조회 방지).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.LOOKUP_PROJECT]?: ProcRequest<MENU_ID, SHEETS.LOOKUP_PROJECT>;
};

interface State {
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // 조회 시점에 고정한 기간 — 그리드 월 컬럼 산출의 단일 원천
  appliedFrom: string;
  appliedTo: string;
  // F6 저장 조회조건 복원 1회 가드 (탭 오픈당) — MotherStore PRESERVED_ON_CONDITION_RESET 보존 키
  initialized: boolean;
}

interface Action {
  reset: () => void;
  /**
   * F6 로 저장한 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M)을 탭 진입 시 1회 복원한다.
   * initialized 가드 — F10(초기화)은 MotherStore 가 initialized 를 보존하므로 재복원되지 않는다.
   */
  restoreSearchConditions: () => Promise<void>;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  applyColumnVisibility: (visibleKeys: string[]) => void;
}

// AS-IS InitControls — 기본 기간은 전년 1월 ~ 익년 12월 (36개월)
const defaultFrom = () => `${dayjs().subtract(1, 'year').format('YYYY')}01`;
const defaultTo = () => `${dayjs().add(1, 'year').format('YYYY')}12`;

const initSearch: SearchCondition = {
  versionNo: '', // ⭐ 버전 팝업 주입 전까지 조회 차단 (MSG00283)
  periodFrom: defaultFrom(),
  periodTo: defaultTo(),
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: [],
  appliedFrom: '',
  appliedTo: '',
  initialized: false,
};

/**
 * F6 저장 조회조건 역파싱 키 분류.
 *
 * 저장(GridAction.personalizeCondition)은 모든 값을 문자열로 coerce 한다(배열=콤마 join /
 * 불리언=String). 이 화면 SearchCondition 은 현재 전부 문자열이라 두 집합이 비지만,
 * 조회조건 필드가 늘어도 따라오도록 초기값의 실제 타입에서 파생해 둔다.
 */
const ARRAY_KEYS = new Set<string>(
  Object.entries(initSearch)
    .filter(([, v]) => Array.isArray(v))
    .map(([k]) => k)
);
const BOOL_KEYS = new Set<string>(
  Object.entries(initSearch)
    .filter(([, v]) => typeof v === 'boolean')
    .map(([k]) => k)
);
// 저장 포맷 = yyyyMM 6자리 + 유효 월. 다른 포맷이면 조회 검증(validateFind)이 통과하지 못한다.
const isValidYm = (v: unknown): v is string => {
  if (typeof v !== 'string' || !/^\d{6}$/.test(v)) return false;
  const m = Number(v.slice(4, 6));
  return m >= 1 && m <= 12;
};

export const useDemandManagerStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드). 저장조건 없음/조회 실패는
    //   기본값 유지(화면 차단 금지, console 금지 룰). F10(Reset Condition)은 SubTitle 공통이
    //   DB 삭제 + MotherStore.resetSearchCondition 으로 처리하는데, 그 쪽이 initialized 를 보존하므로
    //   초기화 직후 이 함수가 다시 복원해 버리는 일은 없다.
    //   주의: 마운트 effect 가 이 함수를 fetchStaticColumns 보다 먼저 await 한다. 이 화면은
    //   Division 40 하드코딩이라 컬럼 메타가 복원값에 의존하지는 않지만, 복원된 조회조건이
    //   그리드 렌더보다 먼저 자리잡도록 순서를 맞춰 둔다.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true; // 먼저 세운다 — 마운트 중복 호출/재마운트 재복원 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;

        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          // 현재 SearchCondition 에 없는 키(구버전 잔재)는 버린다 — setFilter 가 조회조건을
          //   SP payload 로 옮겨 담으므로 모르는 필드가 섞이면 그대로 새어 나간다.
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        // Period 는 yyyyMM 유효 월만 채택 — 오염된 값이면 기본 36개월 구간을 유지한다.
        if (!isValidYm(patch.periodFrom)) delete patch.periodFrom;
        if (!isValidYm(patch.periodTo)) delete patch.periodTo;
        // versionNo 는 팝업이 주입하는 스냅샷이라 없는 버전일 수 있다. 그래도 사용자가 저장한
        //   조건이므로 그대로 복원한다 — 없는 버전이면 SP 가 0건을 돌려줄 뿐이다.

        set(state => {
          state.searchCondition = {
            ...state.searchCondition,
            ...(patch as Partial<SearchCondition>),
          };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
    },
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        state.filters = {
          // ── PKG_DMF0068.P_DMF0068_GET_ORDERLIST (sesUserId·mnuId 는 BE 자동주입) ──
          [SHEETS.MAIN]: {
            divisionId: DIVISION_40,
            versionNo: c.versionNo,
            fromDt: c.periodFrom,
            toDt: c.periodTo,
          },
          // ── PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT (Project 셀 콤보) ──
          [SHEETS.LOOKUP_PROJECT]: {
            divisionId: DIVISION_40,
            versionNo: c.versionNo,
          },
        };
        // 그리드 월 컬럼은 "조회에 사용된" 기간으로만 산출한다 (조회조건 편집 중 흔들리지 않도록 고정)
        state.appliedFrom = c.periodFrom;
        state.appliedTo = c.periodTo;
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.appliedFrom = '';
        state.appliedTo = '';
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 159건 'ContributeSalesList')
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'ContributeSalesList' — 등록명 그대로 (룰 #91)
            divisionId: DIVISION_40,
          }
        );
        set(state => {
          state.staticColumns = result.data.result ?? [];
        });
      } catch {
        // BE 메타 미응답 시 silent — 빈 배열 유지 (console 금지 룰)
      }
    },

    applyColumnVisibility: visibleKeys => {
      set(state => {
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        const visibleSet = new Set(visibleKeys);
        state.staticColumns = cur.map(c => ({ ...c, display: visibleSet.has(c.colNm) }));
      });
    },
  }),
  'demand-manager'
);
