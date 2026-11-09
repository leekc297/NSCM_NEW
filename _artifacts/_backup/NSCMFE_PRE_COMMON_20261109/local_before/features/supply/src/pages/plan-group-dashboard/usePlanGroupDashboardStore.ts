import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './plan-group-dashboard.constants';
import type { SearchParamProps } from './plan-group-dashboard.types';

interface PlanGroupDashboardState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // SubTitle F6 저장분 mount 복원 1회 가드 (저장은 searchParam prop, 복원은 별도 배선 — basic-check #3).
  conditionsRestored: boolean;
  // 메인 그리드 조회조건 전용 — Search 클릭 전에는 undefined(useTabProcQuery enabled 게이트).
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
}

interface PlanGroupDashboardAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 기간 기본값 — AS-IS `GetDayRange()`(cs:200-212): 오늘-7일 ~ 오늘, yyyyMMdd(PeriodRangePicker
//   VALUE_FORMAT 과 동일). dayjs 로컬 기준(toISOString UTC 금지).
const initSearchParams = (): SearchParamProps => ({
  // Division 기본값은 권한목록의 첫 행 — Form 이 Division_SCP 콤보 도착 후 채운다(AS-IS setListBox
  //   DataSource 바인딩이 index 0 을 자동 선택, ALL 옵션 없음).
  divisionId: '',
  // Plan Group / Plant / Completed — ALL 포함 콤보. 'ALL' sentinel 은 조회 시 ''로 치환(setFilters).
  planGroupId: 'ALL',
  plantId: 'ALL',
  completedYn: 'ALL',
  startDate: dayjs().subtract(7, 'day').format('YYYYMMDD'),
  endDate: dayjs().format('YYYYMMDD'),
});

const initPlanGroupDashboardState = (): PlanGroupDashboardState => ({
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams(),
  conditionsRestored: false,
  filters: undefined,
  staticColumns: [],
});

export const usePlanGroupDashboardStore = createPersistedStoreWithTab<
  PlanGroupDashboardState & PlanGroupDashboardAction
>(
  (set, get) => ({
    ...initPlanGroupDashboardState(),
    reset: () => set(initPlanGroupDashboardState()),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // 개별 조회조건 머지 — Division 변경은 setDivision 이 전담한다(아래). Division 이 아닌 필드만
    //   여기로 들어온다.
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(start/end)을 제외한 검색조건을 전부
    //   초기화(PlanGroup/Plant/Completed → 초기값 'ALL')하고 그리드도 초기화(filters 비움)한다
    //   (사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 선례). AS-IS 가
    //   "그리드를 Search 로만 재조회"하던 근거로 그리드 비움을 생략하지 않는다(SCP0025 경과: AS-IS
    //   근거 제거 → 공통 요건 복원). 재조회(Search) 전까지 그리드는 빈 상태. 편집중(dirty) 가드
    //   (MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴) —
    //   이 화면은 그리드 read-only 라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
    //   하위 콤보 'ALL' 초기화는 종전 cascade-combo-filter §1.2/§1.4 의무를 포함한다.
    setDivision: divisionId => {
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initSearchParams(), // Division·기간 제외 전 조건 초기화(planGroup/plant/completed → 'ALL')
          divisionId,
          startDate: cur.startDate,
          endDate: cur.endDate,
        };
        state.filters = undefined; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      });
    },
    // 메인 SP 파라미터 6개(procedures.d.ts SCP0124.main.request). AS-IS `FindData_Main`(cs:301-310):
    //   Plan Group/Plant/Completed 의 'ALL' sentinel 은 ''(필터 없음)로 치환한다. Division 은 단일·
    //   ALL 옵션 없음이라 항상 실값. Plant 는 CSV(ALL→'')로 clbPlant.ControlValues 재현.
    setFilters: () => {
      set(state => {
        const { divisionId, planGroupId, plantId, completedYn, startDate, endDate } =
          state.searchParams;
        const unwrapAll = (v: string) => (v === 'ALL' ? '' : v);
        state.filters = {
          divisionId,
          planGroupId: unwrapAll(planGroupId),
          plantId: unwrapAll(plantId),
          completedYn: unwrapAll(completedYn),
          startDate,
          endDate,
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
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 SCP0123(plan-control) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 patch.
    //   조회조건 6개(divisionId/planGroupId/plantId/completedYn/startDate/endDate)는 전부 문자열이라
    //   역직렬화 불요(멀티셀렉트 plantId 도 CustomDropdown 콤마결합 string 이라 그대로 patch). 저장은
    //   EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라(gridAction.ts personalizeCondition) 응답에 없는
    //   키는 initSearchParams 기본값 그대로 둔다. startDate/endDate 는 '…Date' 라 EXCLUDED_DATE_PARAM
    //   (date(fr|to)$/yyyymmdd$ 등) 미해당이라 저장·복원된다(자매 SCP0123 planDate 동형 거동).
    //   setDivision/setSearchParams 를 쓰지 않는다 — divisionId 변경 cascade 가 하위조건을 지워버린다.
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
        const allow = initSearchParams();
        const patch: Partial<SearchParamProps> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in allow)) continue; // searchParams 필드만 allowlist
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
  'plan-group-dashboard'
);
