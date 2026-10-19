import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './demand-exception.constants';
import type { SearchParamProps } from './demand-exception.types';

interface DemandExceptionState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // Search 클릭 전에는 undefined(useTabProcQuery enabled 게이트) — nscm-patterns.md §3.6.
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
  // 조회 직후 전 칼럼 read-only(gridSignals#7 LockColumn(0,Max,true)) — TO-BE 는 EditButton 토글을
  //   이식하지 않으므로(asis_to_tobe.md §11) 이 화면은 상시 read-only 이며, 신규행만 편집 가능하다
  //   (SCP0128 SafetyStock 선례와 동일 — isEditMode state 자체를 두지 않는다).
}

interface DemandExceptionAction {
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
  stage: '',
  validYn: '',
  periodFrom: '',
  periodTo: '',
};

const initDemandExceptionState: DemandExceptionState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: undefined,
  staticColumns: [],
};

export const useDemandExceptionStore = createPersistedStoreWithTab<
  DemandExceptionState & DemandExceptionAction
>(
  (set, get) => ({
    ...initDemandExceptionState,
    reset: () => set(initDemandExceptionState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 조건(planGroupId) 초기화 — design 02 §3 cascade 필터형(재조회 아님).
    //   그리드/조회 재실행은 Search 버튼으로만(자동 재조회 없음).
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (
          searchParams.divisionId !== undefined &&
          searchParams.divisionId !== get().searchParams.divisionId
        ) {
          next.planGroupId = 'ALL';
        }
        state.searchParams = next;
      });
    },
    // SP 파라미터 8종(design 03 §4.2, spCalls#2)만 추린다.
    setFilters: () => {
      set(state => {
        const { divisionId, planGroupId, scmSiteId, itemId, stage, validYn, periodFrom, periodTo } =
          state.searchParams;
        state.filters = {
          divisionId,
          planGroupId,
          scmSiteId,
          itemId,
          stage,
          validYn,
          periodFrom,
          periodTo,
        };
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(ui-category hook).
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'demand-exception'
);
