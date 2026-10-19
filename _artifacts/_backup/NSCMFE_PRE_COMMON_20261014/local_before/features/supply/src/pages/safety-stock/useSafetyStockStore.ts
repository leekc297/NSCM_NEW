import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './safety-stock.constants';
import type { SearchParamProps } from './safety-stock.types';

interface SafetyStockState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // Search 클릭 전에는 undefined(useTabProcQuery enabled 게이트) — nscm-patterns.md §3.6.
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
  // 조회 직후 전 칼럼 read-only(gridSignals#6 LockColumn(0,Max,true)) — TO-BE 는 EditButton 토글을
  //   이식하지 않으므로(asis_to_tobe.md §11) 이 화면은 상시 read-only 이며, 신규행만 편집 가능하다
  //   (design 01_layout.md §11, 03_grid-columns.md §1 확인 필요 각주). SCP0127 과 달리 isEditMode
  //   state 자체를 두지 않는다 — Edit 미이식이 이 화면의 확정 사실이라 토글 여지가 없다.
}

interface SafetyStockAction {
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
  valueType: '',
  periodFrom: '',
  periodTo: '',
};

const initSafetyStockState: SafetyStockState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: undefined,
  staticColumns: [],
};

export const useSafetyStockStore = createPersistedStoreWithTab<
  SafetyStockState & SafetyStockAction
>(
  (set, get) => ({
    ...initSafetyStockState,
    reset: () => set(initSafetyStockState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 조건(planGroupId) 초기화 — design 02 §3 cascade 필터형(재조회 아님).
    //   그리드/조회 재실행은 Search 버튼으로만(자동 재조회 없음).
    //
    // Division 변경 = 그리드 초기화 의무(nscm-patterns.md §5-5). AS-IS `cboDivision`은
    //   `ClbDivision_SelectedIndexChanged`(.cs:324 배선, .cs:894~899)에 연결돼 있고 이 핸들러가
    //   `SpreadInfo.ClearDataSource(spdMain)`를 호출한다(본 회차 원문 직접 확인) — Division 변경 시
    //   `filters`를 undefined 로 되돌려 `useTabProcQuery`의 `enabled` 게이트를 끄고 그리드를 비운다
    //   (재조회는 Search 버튼으로만 — filters 리셋은 조회 트리거가 아니라 화면 초기화).
    //   주의: PlanGroup(`clbPlanGroup`)에는 이 패턴을 적용하지 않는다 — `CboPlanGroup_
    //   SelectedIndexChanged`(.cs:901~904) 핸들러는 존재하나 Designer.cs 어디에도 `clbPlanGroup`에
    //   `+=`로 연결되지 않은 dead code(본 회차 Designer.cs 재확인, `cboPlanGroup`/`PlanGroup_
    //   SelectedIndexChanged` 0 hit) — AS-IS 에서도 실제로 발생하지 않는 동작이라 TO-BE 에도
    //   추가하지 않는다.
    setSearchParams: searchParams => {
      set(state => {
        const prev = get().searchParams;
        const next = { ...prev, ...searchParams };
        const divisionChanged =
          searchParams.divisionId !== undefined && searchParams.divisionId !== prev.divisionId;
        if (divisionChanged) {
          next.planGroupId = 'ALL';
          state.filters = undefined;
        }
        state.searchParams = next;
      });
    },
    // SP 파라미터 9종(design 03 §4.2, spCalls#2)만 추린다.
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
  'safety-stock'
);
