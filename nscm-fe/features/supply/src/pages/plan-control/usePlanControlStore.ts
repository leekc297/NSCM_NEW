import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './plan-control.constants';
import type {
  EngineRunContext,
  MasterValidationResult,
  PlanControlSearchParams,
} from './plan-control.types';

type GridSheet = SHEETS.PLAN_CONTROL | SHEETS.ENGINE_RUN;

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface PlanControlState {
  searchParams: PlanControlSearchParams;
  // SubTitle F6 저장분 mount 복원 1회 가드 (저장은 searchParam prop, 복원은 별도 배선 — basic-check #3).
  conditionsRestored: boolean;
  filters: FiltersBySheet;
  // 시트 2개 각각의 컬럼 메타(admin fetch — 하드코딩 금지, CLAUDE.md §2 체크3/4).
  staticColumns: Partial<Record<GridSheet, RawFlexGridColumnConfig[]>>;
  // 하단 Status 그리드 + 폴링 대상 행. null 이면 조회 자체를 하지 않는다(AS-IS nSelRowSpdMain = -1).
  engineRunContext: EngineRunContext | null;
  // SCP0039 팝업 결과 — DETAIL 셀 표시(G06·G17)와 Confirm 가드(B16·B17)의 유일한 원천.
  masterValidation: MasterValidationResult;
  openSearchArea: boolean;
}

interface PlanControlAction {
  reset: () => void;
  // 조회조건 갱신. 4개 조건 중 무엇이 바뀌어도 상·하 그리드를 함께 비운다(X02, AS-IS ClearDataSource 8회).
  setSearchParams: (params: Partial<PlanControlSearchParams>) => void;
  // 조회 발사 — planStartYyyymmdd 는 모드(일단위/주단위)에 따라 소스가 갈리므로 호출부가 확정해 넘긴다(F07).
  setFilters: (planStartYyyymmdd: string) => void;
  clearFilters: () => void;
  setEngineRunContext: (context: EngineRunContext | null) => void;
  setMasterValidation: (result: MasterValidationResult) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

const initSearchParams: PlanControlSearchParams = {
  divisionId: '',
  planGroupId: '',
  planDateCode: '',
  planDate: '',
};

const initMasterValidation: MasterValidationResult = {
  isValidSearch: false,
  criticalCnt: 0,
  warningCnt: 0,
};

const initState: PlanControlState = {
  searchParams: initSearchParams,
  conditionsRestored: false,
  filters: {},
  staticColumns: {},
  engineRunContext: null,
  masterValidation: initMasterValidation,
  openSearchArea: true,
};

const fetchColumns = async (sheetNm: string): Promise<RawFlexGridColumnConfig[]> => {
  const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
    sheetNm,
  });
  return res.data.result ?? [];
};

export const usePlanControlStore = createPersistedStoreWithTab<
  PlanControlState & PlanControlAction
>((set, get) => ({
  ...initState,
  reset: () => set(initState),
  setSearchParams: params => {
    set(state => {
      const next = { ...get().searchParams, ...params };
      // Division 변경 = 하위 조건도 함께 초기화(AS-IS SetChangedControl 연쇄 cs:270-278).
      //   Plan Group / Plan Date 후보가 Division 으로 좁혀지므로 이전 선택을 들고 있으면 안 된다.
      if (params.divisionId !== undefined && params.divisionId !== get().searchParams.divisionId) {
        next.planGroupId = '';
        next.planDateCode = '';
      }
      state.searchParams = next;
      // 조회조건 4개 중 무엇이 바뀌어도 상·하 그리드를 함께 비운다(X02). 한쪽만 비우면 하단 Status 에
      //   이전 Plan ID 잔상이 남고, 낡은 데이터로 CONFIRM 을 누르면 잘못된 키로 저장된다.
      state.filters = {};
      state.engineRunContext = null;
      state.masterValidation = initMasterValidation;
    });
  },
  setFilters: planStartYyyymmdd => {
    set(state => {
      const sc = get().searchParams;
      // 키명 = SCM_ADM_PROC_M.COL_NM(camelCase 실측). snake_case p_* 로 보내면 BE 가 COL_NM 매칭에
      //   실패해 조용히 NULL 바인딩된다(메모리 scp-proc-m-colnm-is-camelcase).
      //   SP IN 순번: 1 divisionId / 2 planGroupId / 3 planStartYyyymmdd / 4 actvCd / 5 planId.
      //   전체조회는 actvCd·planId 를 빈 문자열로 보낸다(AS-IS cs:488).
      state.filters = {
        [SHEETS.PLAN_CONTROL]: {
          divisionId: sc.divisionId,
          planGroupId: sc.planGroupId,
          planStartYyyymmdd,
          actvCd: '',
          planId: '',
        },
      };
      // 조회 재발사 시 하단 Status·폴링은 초기화한다(AS-IS FindData_Main 진입 시 timerStatus.Stop, R21).
      state.engineRunContext = null;
    });
  },
  clearFilters: () => {
    set(state => {
      state.filters = {};
      state.engineRunContext = null;
    });
  },
  setEngineRunContext: context => {
    set(state => {
      state.engineRunContext = context;
    });
  },
  setMasterValidation: result => {
    set(state => {
      state.masterValidation = result;
    });
  },
  fetchStaticColumns: async () => {
    // 시트 2개를 각각 조회한다(SHEET_NAME 축 = 'Plan Control' / 'Status').
    const [planControl, engineRun] = await Promise.all([
      fetchColumns(ADMIN_SHEET_NAME[SHEETS.PLAN_CONTROL]),
      fetchColumns(ADMIN_SHEET_NAME[SHEETS.ENGINE_RUN]),
    ]);
    set(state => {
      state.staticColumns = {
        [SHEETS.PLAN_CONTROL]: planControl,
        [SHEETS.ENGINE_RUN]: engineRun,
      };
    });
  },
  setOpenSearchArea: open => {
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    });
  },
  // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 scp-bom 파리티.
  //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 patch.
  //   조회조건 4개(divisionId/planGroupId/planDateCode/planDate)는 전부 문자열이라 역직렬화 불요(그대로 patch).
  //   저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라(gridAction.ts personalizeCondition) 응답에 없는
  //   키는 initSearchParams 기본값 그대로 둔다. planDate 키는 EXCLUDED_DATE_PARAM 미해당이라 저장·복원된다
  //   (AS-IS ConditionNotUseList 는 키기반 공용 저장에 반영되지 않음 — SSP0021 선례와 동일 거동).
  //   setSearchParams 를 쓰지 않는다 — divisionId 변경 cascade 가 planGroupId/planDateCode 를 지워버린다.
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
      const patch: Partial<PlanControlSearchParams> = {};
      for (const { paramNm, paramCtn } of rows) {
        if (!(paramNm in initSearchParams)) continue; // searchParams 필드만 allowlist
        patch[paramNm as keyof PlanControlSearchParams] = paramCtn ?? '';
      }
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    } catch {
      // 미저장/실패 = 기본값 유지 (console 금지 룰)
    }
  },
}), 'plan-control');
