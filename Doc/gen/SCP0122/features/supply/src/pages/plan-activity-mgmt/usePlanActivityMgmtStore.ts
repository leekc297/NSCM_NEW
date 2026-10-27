// SCP0122 PlanActivityMgmt — TobeGen 생성 골격 (As-is SCP0122_PlanActivityMgmt, Fact Pack Doc/asisfacts/screens/SCP0122)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './plan-activity-mgmt.constants';

interface SearchParamProps {
  planGroups: string[];
  process: string;
  divisionId: string;
}

// SP IN 파라미터(call-proc filters) — 멀티선택 = 콤마 delim('ALL' = 빈값), 팝업 텍스트 = raw(''), 체크 = 'Y'/'N' (AS-IS ControlValues 1:1 · dmf0045 선례)
//   SCM_ADM_PROC_M.COL_NM(camelCase) 과 키가 같아야 BE 가 positional 매핑한다 — 등록 SQL(<ID>_registration.sql BLOCK 2) 과 대사할 것
type PlanActivityMgmtFilter = Record<keyof SearchParamProps, string>;
const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
const yn = (b?: boolean): string => (b ? 'Y' : 'N');
const toFilter = (p: SearchParamProps): PlanActivityMgmtFilter => ({
  planGroups: j(p.planGroups),
  process: p.process,
  divisionId: p.divisionId,
});

interface PlanActivityMgmtState {
  initialized: boolean;
  filters?: PlanActivityMgmtFilter; // useTabProcQuery filters — ProcRequest 와 호환(string 값)
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;

}

interface PlanActivityMgmtAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;

}

const initPlanActivityMgmtParam: SearchParamProps = {
  planGroups: [],
  process: '',
  divisionId: '',
};

const initPlanActivityMgmtState: PlanActivityMgmtState = {
  initialized: false,
  filters: undefined,
  searchParams: initPlanActivityMgmtParam,
  staticColumns: [],
  isOpenSearchArea: true,

} as const;

export const usePlanActivityMgmtStore = createPersistedStoreWithTab<PlanActivityMgmtState & PlanActivityMgmtAction>(
  (set, get) => ({
    ...initPlanActivityMgmtState,
    reset: () => set(initPlanActivityMgmtState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = toFilter(get().searchParams);
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
        sheetNm: SHEETS.PLAN_ACTIVITY_MGMT,
      });
      set(state => {
        state.staticColumns = result.data.result;
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        // 저장된 조회조건(문자열) → 화면 타입으로 복원 (멀티/팝업: 콤마 분리, 체크: Y/N, 그 외 문자열)
        const saved = Object.fromEntries(param.data.result.map(r => [r.paramNm, r.paramCtn])) as Record<string, string | undefined>;
        const arr = (v?: string) => (v && v !== 'ALL' ? v.split(',').filter(Boolean) : []);
        const bool = (v?: string) => v === 'Y' || v === 'true';
        const str = (v: string | undefined, d: string) => v ?? d;
        const searchParams: SearchParamProps = {
          ...initPlanActivityMgmtParam,
          planGroups: arr(saved.planGroups),
          process: str(saved.process, initPlanActivityMgmtParam.process),
          divisionId: str(saved.divisionId, initPlanActivityMgmtParam.divisionId),
        };
        set(state => {
          state.searchParams = searchParams;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
  }),
  'plan-activity-mgmt'
);
