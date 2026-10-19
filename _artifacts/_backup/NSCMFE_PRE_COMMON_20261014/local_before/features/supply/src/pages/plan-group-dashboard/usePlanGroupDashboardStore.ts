import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './plan-group-dashboard.constants';
import type { SearchParamProps } from './plan-group-dashboard.types';

interface PlanGroupDashboardState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // 메인 그리드 조회조건 전용 — Search 클릭 전에는 undefined(useTabProcQuery enabled 게이트).
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
}

interface PlanGroupDashboardAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParams: SearchParamProps = {
  divisionId: 'ALL',
  planGroupId: 'ALL',
  plantId: 'ALL',
  completedYn: '',
  startDate: '',
  endDate: '',
  activityCode: 'ALL',
  processCode: '',
};

const initPlanGroupDashboardState: PlanGroupDashboardState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: undefined,
  staticColumns: [],
};

export const usePlanGroupDashboardStore = createPersistedStoreWithTab<
  PlanGroupDashboardState & PlanGroupDashboardAction
>(
  (set, get) => ({
    ...initPlanGroupDashboardState,
    reset: () => set(initPlanGroupDashboardState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 콤보(PlanGroup/Plant)를 'ALL' 로 초기화 — cascade-combo-filter.md
    // §1.2/§1.4 의무. 01_layout.md §2 #6·03_grid-columns.md §4 에 따라 그리드는 Search 로만
    // 재조회되므로(자동 재조회 없음) 여기서 filters/그리드를 함께 비우지 않는다(bod 화면 선례와 동일).
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (
          searchParams.divisionId !== undefined &&
          searchParams.divisionId !== get().searchParams.divisionId
        ) {
          next.planGroupId = 'ALL';
          next.plantId = 'ALL';
        }
        state.searchParams = next;
      });
    },
    // 메인 SP 파라미터 6개(procedures.d.ts SCP0124.main.request)만 추린다 — activityCode/
    // processCode 는 boundControl 미확정(plan-group-dashboard.types.ts 주석)이라 SP 파라미터로
    // 보내지 않는다(확인 필요 상태를 추측 배선하지 않음).
    setFilters: () => {
      set(state => {
        const { divisionId, planGroupId, plantId, completedYn, startDate, endDate } =
          state.searchParams;
        state.filters = { divisionId, planGroupId, plantId, completedYn, startDate, endDate };
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(ui-category hook).
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.MAIN,
        }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'plan-group-dashboard'
);
