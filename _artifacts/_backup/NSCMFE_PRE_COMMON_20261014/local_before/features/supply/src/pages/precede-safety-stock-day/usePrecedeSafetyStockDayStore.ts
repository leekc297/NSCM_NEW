import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './precede-safety-stock-day.constants';
import type { SearchParamProps } from './precede-safety-stock-day.types';

interface PrecedeSafetyStockDayState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // Search 클릭 전에는 undefined(useTabProcQuery enabled 게이트) — nscm-patterns.md §3.6.
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
}

interface PrecedeSafetyStockDayAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParams: SearchParamProps = {
  divisionId: 'ALL',
  planGroupId: 'ALL',
  scmSiteId: 'ALL',
  itemId: '',
  stage: 'ALL',
  validYn: '',
  valueType: '',
  periodFrom: '',
  periodTo: '',
};

const initPrecedeSafetyStockDayState: PrecedeSafetyStockDayState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: undefined,
  staticColumns: [],
};

export const usePrecedeSafetyStockDayStore = createPersistedStoreWithTab<
  PrecedeSafetyStockDayState & PrecedeSafetyStockDayAction
>(
  (set, get) => ({
    ...initPrecedeSafetyStockDayState,
    reset: () => set(initPrecedeSafetyStockDayState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 조건(planGroupId/scmSiteId/stage) 초기화 — 02_search-combo.md §3
    // 공통 QA(cascade 필터형, 재조회 아님). 그리드/조회 재실행은 Search 버튼으로만(자동 재조회 없음).
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (
          searchParams.divisionId !== undefined &&
          searchParams.divisionId !== get().searchParams.divisionId
        ) {
          next.planGroupId = 'ALL';
          next.scmSiteId = 'ALL';
          next.stage = 'ALL';
        }
        state.searchParams = next;
      });
    },
    // SP 파라미터 9종(procedures.d.ts SCP0127.main.request)만 추린다 — design/02_search-combo.md §5.
    setFilters: () => {
      set(state => {
        const {
          divisionId,
          planGroupId,
          scmSiteId,
          itemId,
          stage,
          validYn,
          valueType,
          periodFrom,
          periodTo,
        } = state.searchParams;
        state.filters = {
          divisionId,
          planGroupId,
          scmSiteId,
          itemId,
          stage,
          validYn,
          valueType,
          periodFrom,
          periodTo,
        };
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
  'precede-safety-stock-day'
);
