import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
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
  restoreSearchConditions: () => Promise<void>;
}

// Period 기본값 — AS-IS setPeriod()(.cs:874~889) = 이번 주 월요일 ~ +52주(월요일+364일).
//   C# DayOfWeek(Sun=0,Mon=1)과 dayjs .day() 가 동일 체계 — today.add(1 - today.day(), 'day') 가
//   일요일은 다음날 월요일, 월~토는 당주 월요일로 당겨 AS-IS mondayDate 와 1:1 일치한다.
//   모듈 로드 시점 1회 평가(자매 validation-shipment-result 동일 패턴). toISOString(UTC) 금지.
const thisMonday = dayjs().add(1 - dayjs().day(), 'day');

const initSearchParams: SearchParamProps = {
  // Division 은 단일 선택(AS-IS GetDivision(false,"") — ALL 옵션 없음, design 02 §1 주1).
  //   콤보 로드 후 SafetyStockForm 이 첫 항목을 자동선택한다.
  divisionId: '',
  planGroupId: 'ALL',
  // Site(다중)/Stage(단일)/Type(단일) — init(GET_SEARCH_INFO) 커서 원천. 빈 값 = 무필터(ALL).
  //   Site/Stage 는 Division cascade 하위이므로 Division 변경 시 setSearchParams 가 초기화한다.
  scmSiteId: '',
  itemId: '',
  stage: '',
  validYn: '',
  valueType: '',
  periodFrom: thisMonday.format('YYYYMMDD'),
  periodTo: thisMonday.add(52 * 7, 'day').format('YYYYMMDD'),
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
          // Division cascade 하위(PlanGroup/Site/Stage) 초기화 — AS-IS RefreshSiteByDivision·
          //   RefreshStageByDivision(.cs:260~281)이 Division 변경마다 목록을 다시 거르므로 선택값을
          //   비워 재선택되게 한다. Type(valueType)은 Division 하위가 아니라 유지한다.
          next.planGroupId = 'ALL';
          next.scmSiteId = '';
          next.stage = '';
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
    // F6 저장 조회조건 복원(진입 시) — SRCH-12, 자매 SCP0127 동형. 공통 SubTitle 은 저장(F6)·초기화
    //   (F10)만 담당하고 진입 복원은 화면 store 몫이다. initialized 가드로 탭 수명 내 1회(F10 reset 은
    //   MotherStore.resetSearchCondition 이 initialized 보존 → 초기화 직후 재복원 안 함). 기간은 저장
    //   제외 규약(EXCLUDED_DATE_PARAM)이라 서버가 안 돌려주며, 와도 건너뛴다. 실패는 기본값 유지.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, string> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearchParams)) continue;
          if (paramNm === 'periodFrom' || paramNm === 'periodTo') continue;
          patch[paramNm] = paramCtn ?? '';
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParamProps>) };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지
      }
    },
  }),
  'safety-stock'
);
