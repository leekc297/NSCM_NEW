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
  filters: FiltersBySheet;
  staticColumns: RawFlexGridColumnConfig[];
  openSearchArea: boolean;
}

interface PlanActivityMgmtAction {
  reset: () => void;
  // searchParams 갱신. division/planGroup 변경 시 그리드 초기화(filters 비움) — design 01 L3/L4.
  setSearchParams: (params: Partial<PlanActivityMgmtSearchParams>) => void;
  // 조회 발사 — searchParams 를 SP payload 로 변환해 filters 참조 교체(useTabProcQuery 자동 발사).
  setFilters: () => void;
  // division/planGroup 변경 시 그리드 공백(query disabled).
  clearFilters: () => void;
  // 컬럼 메타(SCM_MST_SHEET_COLUMNS 'Plan Activity Mgmt' 15컬럼) fetch — mount + Search 마다.
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
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
}), 'plan-activity-mgmt');
