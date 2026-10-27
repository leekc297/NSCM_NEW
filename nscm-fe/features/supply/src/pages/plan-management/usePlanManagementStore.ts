import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './plan-management.constants';
import type { SelectedPlan } from './plan-management.types';

interface SearchParamProps {
  divisionId: string;
  planYear: string;
  planWeek: string;
}

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface PlanManagementState {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  /** 더블클릭·REVISION 변경으로 선택된 행 — Detail(Engine) 조회 컨텍스트 */
  selected: SelectedPlan | null;
  staticColumns: {
    [SHEETS.MAIN_GRID]: RawFlexGridColumnConfig[];
    [SHEETS.DETAIL_GRID]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
}

interface PlanManagementAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  /** 조회(Search) — mainGrid filter 발사 + Detail/선택 초기화 */
  setMainFilters: () => void;
  /** 저장 액션 성공 후 재조회 — mainGrid filter 만 새 참조로 교체 */
  refreshMainFilters: () => void;
  /** Detail(Engine) 조회 — 선택 행 division+revision */
  setDetailFilters: (filter?: ProcRequest<MENU_ID, SHEETS.DETAIL_GRID>) => void;
  setSelected: (selected: SelectedPlan | null) => void;
  /** mount 시 keep-alive 잔존 filters 무효화(stale 자동 발사 방지) */
  clearFilters: () => void;
  /** 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회) */
  restoreSearchConditions: () => Promise<void>;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initState: PlanManagementState = {
  initialized: false,
  conditionsRestored: false,
  searchParams: { divisionId: '', planYear: '', planWeek: '' },
  filters: {},
  selected: null,
  staticColumns: {
    [SHEETS.MAIN_GRID]: [],
    [SHEETS.DETAIL_GRID]: [],
  },
  openSearchArea: true,
};

// mainGrid 조회 파라미터 — PKG_SCP0134.P_SCP0134_GET_PLAN_MST COL_NM(05_register.sql PROC_M).
//   sesUserId(P_USER_ID)는 BE call-proc 경로가 세션 주입 → FE 미전송. sesUserGrId(P_GROUP_ID)는 FE 가 싣는다.
const buildMainFilter = (p: SearchParamProps): ProcRequest<MENU_ID, SHEETS.MAIN_GRID> => ({
  divisionId: p.divisionId,
  planYear: p.planYear,
  planWeek: p.planWeek,
  sesUserGrId: useSessionStore.getState().session.groupId ?? '',
});

export const usePlanManagementStore = createPersistedStoreWithTab<
  PlanManagementState & PlanManagementAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        // Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5) + 하위 초기화.
        //   Year 는 Form 이 당해년도로 즉시 복원, PlanWeek 는 콤보 첫 값 재선택된다.
        if (searchParams.divisionId !== undefined) {
          state.searchParams.planYear = '';
          state.searchParams.planWeek = '';
          state.filters = {};
          state.selected = null;
        }
      });
    },
    setMainFilters: () => {
      set(state => {
        const p = get().searchParams;
        state.filters = {
          [SHEETS.MAIN_GRID]: buildMainFilter(p),
          // Detail(Engine)은 행 더블클릭·REVISION 변경으로만 발사
          [SHEETS.DETAIL_GRID]: undefined,
        };
        state.selected = null;
      });
    },
    refreshMainFilters: () => {
      set(state => {
        state.filters[SHEETS.MAIN_GRID] = buildMainFilter(get().searchParams);
      });
    },
    setDetailFilters: filter => {
      set(state => {
        state.filters[SHEETS.DETAIL_GRID] = filter ? { ...filter } : undefined;
      });
    },
    setSelected: selected => {
      set(state => {
        state.selected = selected;
      });
    },
    clearFilters: () => {
      set(state => {
        state.filters = {};
        state.selected = null;
      });
    },
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — scp-bom 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn. searchParams 3필드 전부 문자열.
    //   저장분 없거나 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입(personalizeCondition)
    //   이라 응답에 없는 키는 기본값 그대로. Year 는 Form 이 당해년도로 강제 복원하므로 복원값과 무관.
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
        const patch: Partial<SearchParamProps> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (paramNm in initState.searchParams)
            patch[paramNm as keyof SearchParamProps] = paramCtn ?? '';
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
    fetchStaticColumns: async () => {
      // admin 컬럼 메타(SCM_MST_SHEET_COLUMNS) — sheetNm 은 SHEET_NAME 값 공간('Main Grid'/'Detail Grid')
      const fetchColumns = (sheetNm: string) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm });
      const [main, detail] = await Promise.all([
        fetchColumns(ADMIN_SHEET_NAME[SHEETS.MAIN_GRID] ?? ''),
        fetchColumns(ADMIN_SHEET_NAME[SHEETS.DETAIL_GRID] ?? ''),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN_GRID]: main.data.result ?? [],
          [SHEETS.DETAIL_GRID]: detail.data.result ?? [],
        };
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
  }),
  'plan-management'
);
