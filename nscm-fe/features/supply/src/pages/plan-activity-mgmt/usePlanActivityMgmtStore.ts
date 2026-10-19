import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './plan-activity-mgmt.constants';
import type { PlanActivityMgmtSearchParams } from './plan-activity-mgmt.types';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface PlanActivityMgmtState {
  searchParams: PlanActivityMgmtSearchParams;
  // SubTitle F6 저장분 mount 복원 1회 가드 (저장은 searchParam prop, 복원은 별도 배선 — basic-check #3).
  conditionsRestored: boolean;
  filters: FiltersBySheet;
  staticColumns: RawFlexGridColumnConfig[];
  openSearchArea: boolean;
}

interface PlanActivityMgmtAction {
  reset: () => void;
  // searchParams 갱신. division/planGroup 변경 시 그리드 초기화(filters 비움) — design 01 L3/L4.
  setSearchParams: (params: Partial<PlanActivityMgmtSearchParams>) => void;
  // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 제외 검색조건 전부 초기화 + 그리드 초기화.
  setDivision: (divisionId: string) => void;
  // 조회 발사 — searchParams 를 SP payload 로 변환해 filters 참조 교체(useTabProcQuery 자동 발사).
  setFilters: () => void;
  // division/planGroup 변경 시 그리드 공백(query disabled).
  clearFilters: () => void;
  // 컬럼 메타(SCM_MST_SHEET_COLUMNS 'Plan Activity Mgmt' 15컬럼) fetch — mount + Search 마다.
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

const initSearchParams: PlanActivityMgmtSearchParams = {
  divisionId: '',
  planGroupId: '',
  planGroupName: '',
  prsCd: '',
  prsName: '',
};

const initState: PlanActivityMgmtState = {
  searchParams: initSearchParams,
  conditionsRestored: false,
  filters: { [SHEETS.MAIN]: undefined },
  staticColumns: [],
  openSearchArea: true,
};

export const usePlanActivityMgmtStore = createPersistedStoreWithTab<
  PlanActivityMgmtState & PlanActivityMgmtAction
>((set, get) => ({
  ...initState,
  reset: () => set(initState),
  setSearchParams: params => {
    set(state => {
      state.searchParams = { ...get().searchParams, ...params };
      // division / planGroup 변경 = 그리드 초기화 의무(design 01 L3/L4, nscm-patterns §5-5).
      //   Process(prsCd) 변경은 그리드를 비우지 않는다(AS-IS 그대로).
      if (params.divisionId !== undefined || params.planGroupId !== undefined) {
        state.filters = { [SHEETS.MAIN]: undefined };
      }
    });
  },
  // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건(PlanGroup/Process)을 전부 초기화하고
  //   그리드도 초기화(filters 비움)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 선례).
  //   이 화면은 기간/날짜 조회조건이 없어 Division(새 값)만 유지한다. 종전 setSearchParams 핸들러는 PlanGroup 만
  //   비우고 Process(prsCd/prsName)는 남겼으나, 공통 요건상 Process 도 함께 초기화한다. 편집중(dirty) 가드(MSG00704)는
  //   Form onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴) — 취소 시 controlled 콤보가 이전 Div 로 복귀.
  setDivision: divisionId => {
    set(state => {
      state.searchParams = { ...initSearchParams, divisionId };
      state.filters = { [SHEETS.MAIN]: undefined }; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
    });
  },
  setFilters: () => {
    set(state => {
      const sc = get().searchParams;
      // 키명 = SCM_ADM_PROC_M.COL_NM(camelCase 컨벤션, 자매 SCP0006). SP IN 순번: divisionId /
      //   planGroupId / prsCd (design 02 §2-4). snake_case p_* 로 보내면 BE 가 COL_NM 으로 값을 못 찾아
      //   조용히 조회 0행이 된다(메모리 generic-callproc-param-key-must-match-proc-m-colnm).
      //   prsCd 는 선택 Process code 직접 전달(AS-IS 오타 인자 dtPlanGroup 감쌈 미이식).
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId: sc.divisionId,
          planGroupId: sc.planGroupId,
          prsCd: sc.prsCd,
        },
      };
    });
  },
  clearFilters: () => {
    set(state => {
      state.filters = { [SHEETS.MAIN]: undefined };
    });
  },
  fetchStaticColumns: async () => {
    const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN],
    });
    set(state => {
      state.staticColumns = res.data.result;
    });
  },
  setOpenSearchArea: open => {
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    });
  },
  // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 SCP0123(plan-control)·scp-bom 파리티.
  //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 patch.
  //   조회조건 5키(divisionId/planGroupId/planGroupName/prsCd/prsName)는 전부 문자열이라 역직렬화 불요(그대로 patch).
  //   저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라(gridAction.ts personalizeCondition) 응답에 없는
  //   키는 initSearchParams 기본값 그대로 둔다. 이 화면은 날짜 조회조건이 없어 제외 키도 없다.
  //   setSearchParams/setDivision 을 쓰지 않는다 — divisionId 변경 cascade 가 나머지 조건을 지워버린다.
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
      const patch: Partial<PlanActivityMgmtSearchParams> = {};
      for (const { paramNm, paramCtn } of rows) {
        if (!(paramNm in initSearchParams)) continue; // searchParams 필드만 allowlist
        patch[paramNm as keyof PlanActivityMgmtSearchParams] = paramCtn ?? '';
      }
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    } catch {
      // 미저장/실패 = 기본값 유지 (console 금지 룰)
    }
  },
}), 'plan-activity-mgmt');
