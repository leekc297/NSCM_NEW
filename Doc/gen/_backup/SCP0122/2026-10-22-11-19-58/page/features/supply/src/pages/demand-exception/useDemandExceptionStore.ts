import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './demand-exception.constants';
import type { SearchParamProps } from './demand-exception.types';

interface DemandExceptionState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // SubTitle F6 저장분 mount 복원 1회 가드 (저장은 searchParam prop, 복원은 별도 배선 — basic-check #3).
  conditionsRestored: boolean;
  // Search 클릭 전에는 undefined(useTabProcQuery enabled 게이트) — nscm-patterns.md §3.6.
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
  // TO-BE 는 EditButton 편집모드 토글(잠금 토글 절차)만 이식하지 않고(asis_to_tobe.md §11), 편집가능
  //   여부는 컬럼 white-list(demandExceptionEditLock)로 판정한다 — 조회 후 별도 Edit 버튼 없이 기존행도
  //   바로 수정 가능(DIVISION_ID·감사·ITEM_ID 제외). SCP0128 SafetyStock 선례와 동일(isEditMode state 없음).
}

interface DemandExceptionAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// Period 기본값 — AS-IS setPeriod()(.cs:831~846) = 이번 주 월요일 ~ +52주(월요일+364일).
//   C# DayOfWeek(Sun=0,Mon=1)과 dayjs .day() 동일 체계 — today.add(1 - today.day(), 'day')가 당주
//   월요일로 정렬(일요일은 다음날 월요일). 형제 SCP0128 useSafetyStockStore 와 동일 패턴.
const thisMonday = dayjs().add(1 - dayjs().day(), 'day');

const initSearchParams: SearchParamProps = {
  // Division 은 단일 선택(AS-IS setListBox(...,false) — ALL 옵션 없음, .cs:163). 콤보 로드 후
  //   DemandExceptionForm 이 첫 항목을 자동선택한다(형제 SCP0128 동형).
  divisionId: '',
  planGroupId: 'ALL',
  // Site(다중)/Stage(단일) — init(GET_SEARCH_INFO) 커서 원천. 빈 값 = 무필터(ALL). Division cascade
  //   하위이므로 Division 변경 시 setDivision 이 초기화한다.
  scmSiteId: '',
  itemId: '',
  stage: '',
  validYn: '',
  periodFrom: thisMonday.format('YYYYMMDD'),
  periodTo: thisMonday.add(52 * 7, 'day').format('YYYYMMDD'),
};

const initDemandExceptionState: DemandExceptionState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  conditionsRestored: false,
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
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(Period from/to)을 제외한 검색조건을 전부
    //   초기화하고 그리드도 초기화(filters=undefined)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이
    //   AS-IS 핸들러보다 우선, SCP0025 정본 패턴). 재조회는 Search 버튼으로만(enabled=!!filters 게이트).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 Division onChange 가 confirmIfDirtyKey 로 처리한다
    //   (commit 51d4e9fa 패턴) — 취소 시 controlled 콤보가 이전 Division 으로 복귀.
    setDivision: divisionId => {
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initSearchParams, // Division·기간 제외 전 조건 초기화(planGroup/site/stage/validYn/item)
          divisionId,
          periodFrom: cur.periodFrom,
          periodTo: cur.periodTo,
        };
        state.filters = undefined; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
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
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티(basic-check #3).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 을 searchParams 에 patch.
    //   조회조건 6키(divisionId/planGroupId/scmSiteId/itemId/stage/validYn)는 전부 문자열이라 역직렬화
    //   불요(그대로 patch — 멀티셀렉트도 콤마결합 문자열로 저장/복원). periodFrom/periodTo 는 저장측
    //   EXCLUDED_DATE_PARAM(^period(from|to)?$)에 걸려 저장 자체가 제외되므로 복원 대상이 아니다(기본값
    //   유지). setSearchParams/setDivision 을 경유하지 않는다 — Division 변경 cascade 가 나머지 조건을
    //   초기화해 복원값을 날려버린다. 저장분 없으면 기본값 유지(자매 SCP0128 1:1).
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
        const patch: Partial<SearchParamProps> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearchParams)) continue; // searchParams 필드만 allowlist
          patch[paramNm as keyof SearchParamProps] = paramCtn ?? '';
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'demand-exception'
);
