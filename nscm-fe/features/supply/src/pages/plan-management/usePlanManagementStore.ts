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
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  /**
   * PlanWeek 콤보 첫 값(최신 주차) — Form 이 옵션 로드 시마다 갱신한다.
   * searchParams 바깥에 두는 이유: setPlanFilters 가 searchParams 를 그대로 proc 요청에 실어
   * 보내므로, 안에 두면 서버가 모르는 필드가 조회 파라미터로 새어 나간다(sales-site trigger 규약).
   */
  planWeekFirst: string;
  /**
   * 조회 시점의 "PlanWeek=현재 주차" 여부(AS-IS nSelPlanWeek==0 등가, design 03 §3 R9).
   * 조회 버튼을 누른 순간의 값으로 고정 — 이후 콤보를 바꿔도 재조회 전엔 잠금 판정이 안 바뀐다.
   */
  weekCurrent: boolean;
  /** 더블클릭 선택 행 컨텍스트(AS-IS nSelRowSpdPlan/txtRevision 등가) */
  selected: SelectedPlan | null;
  staticColumns: {
    [SHEETS.PLAN_MGMT]: RawFlexGridColumnConfig[];
    [SHEETS.ENGINE_RUN]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
}

interface PlanManagementAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setPlanWeekFirst: (code: string) => void;
  /** 조회(Search) — planMgmt filter 발사 + weekCurrent 확정 + 하위(engine/confirm/선택) 초기화 */
  setPlanFilters: () => void;
  /** 저장(STOP/RUN) 성공 후 재조회 — planMgmt filter 만 새 참조로 교체(선택/Engine 유지) */
  refreshPlanFilters: () => void;
  setEngineFilters: (filter?: ProcRequest<MENU_ID, SHEETS.ENGINE_RUN>) => void;
  setConfirmFilters: (filter?: ProcRequest<MENU_ID, SHEETS.PLAN_CONFIRM>) => void;
  setSelected: (selected: SelectedPlan | null) => void;
  /** mount 시 keep-alive 잔존 filters 무효화(stale 자동 발사 방지 — nscm-patterns §5-7) */
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initState: PlanManagementState = {
  initialized: false,
  searchParams: { divisionId: '', planYear: '', planWeek: '' },
  filters: {},
  planWeekFirst: '',
  weekCurrent: false,
  selected: null,
  staticColumns: {
    [SHEETS.PLAN_MGMT]: [],
    [SHEETS.ENGINE_RUN]: [],
  },
  openSearchArea: true,
};

const buildPlanFilter = (p: SearchParamProps): ProcRequest<MENU_ID, SHEETS.PLAN_MGMT> => ({
  divisionId: p.divisionId, // 1 P_DIVISION_ID
  planYear: p.planYear, // 2 P_PLAN_YEAR
  planWeek: p.planWeek, // 3 P_PLAN_WEEK (비필수 — 빈값 허용)
  // 5 P_GROUP_ID — BE 가 주입하지 않는 세션성 파라미터라 FE 가 반드시 싣는다(design 03 §4.2,
  //   AS-IS 는 이 파라미터를 누락한 채 운영된 결함 의심 — TO-BE 는 반복하지 않는다).
  //   4 P_USER_ID(sesUserId)는 BE call-proc 경로가 세션에서 주입하므로 싣지 않는다.
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
        // Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5) + cascade 하위 초기화.
        //   PlanYear/PlanWeek 재조회는 Form 의 콤보 쿼리 파라미터(division)가 바뀌며 한 액션으로
        //   함께 발사된다(AS-IS SetChangedControl 단일 핸들러 직렬 처리 등가, design 02 §3).
        if (searchParams.divisionId !== undefined) {
          state.searchParams.planYear = '';
          state.searchParams.planWeek = '';
          state.filters = {};
          state.selected = null;
          state.weekCurrent = false;
        }
        // PlanYear 변경 → PlanWeek 만 재조회(cascade 하위 초기화)
        if (searchParams.planYear !== undefined && searchParams.divisionId === undefined) {
          state.searchParams.planWeek = '';
        }
      });
    },
    setPlanWeekFirst: code => {
      set(state => {
        state.planWeekFirst = code;
      });
    },
    setPlanFilters: () => {
      set(state => {
        const p = get().searchParams;
        state.filters = {
          [SHEETS.PLAN_MGMT]: buildPlanFilter(p),
          // Engine/Confirm 은 행 더블클릭·REVISION 변경으로만 발사(AS-IS FindData_Engin 경로)
          [SHEETS.ENGINE_RUN]: undefined,
          [SHEETS.PLAN_CONFIRM]: undefined,
        };
        // R9 판정 고정 — 조회 시점의 PlanWeek 가 콤보 첫 값(현재 주차)인가(AS-IS nSelPlanWeek==0)
        state.weekCurrent = p.planWeek !== '' && p.planWeek === get().planWeekFirst;
        state.selected = null;
      });
    },
    refreshPlanFilters: () => {
      set(state => {
        state.filters[SHEETS.PLAN_MGMT] = buildPlanFilter(get().searchParams);
      });
    },
    setEngineFilters: filter => {
      set(state => {
        state.filters[SHEETS.ENGINE_RUN] = filter ? { ...filter } : undefined;
      });
    },
    setConfirmFilters: filter => {
      set(state => {
        state.filters[SHEETS.PLAN_CONFIRM] = filter ? { ...filter } : undefined;
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
    fetchStaticColumns: async () => {
      // admin 컬럼 메타(SCM_MST_SHEET_COLUMNS) — sheetNm 은 SHEET_NAME 값 공간(SHT_NM 아님, design 03 §0)
      const fetchColumns = (sheetNm: string) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm });
      const [plan, engine] = await Promise.all([
        fetchColumns(ADMIN_SHEET_NAME[SHEETS.PLAN_MGMT] ?? ''),
        fetchColumns(ADMIN_SHEET_NAME[SHEETS.ENGINE_RUN] ?? ''),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.PLAN_MGMT]: plan.data.result ?? [],
          [SHEETS.ENGINE_RUN]: engine.data.result ?? [],
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
