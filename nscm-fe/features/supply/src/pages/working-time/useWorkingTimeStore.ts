import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './working-time.constants';
import type { SearchParamProps } from './working-time.types';

// SP filter payload — useTabProcQuery enabled 가드.
//   MAIN = PKG_SCP0019.P_SCP0019_GET_WORKING_TIME (7 IN, OUT O_RC1 데이터 + O_RESULT_CURSOR 상태).
//   커서 실측(all_source BODY, 04_impl-gap-audit #1): O_RC1 = 피벗 데이터(정적 14 + 동적 D_yyyymmdd),
//   O_RESULT_CURSOR = 상태('0'/'SUCCESS'). 타이틀-메타 커서는 없다 — 동적 컬럼은 데이터 커서 alias 이며
//   BE 가 o_rc1_columns 로 함께 노출한다. 별도 타이틀 SP 도 없으므로 시트는 MAIN 하나뿐(03_grid-columns §2-a).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface WorkingTimeState {
  initialized: boolean;
  // F6 개인화 조회조건 복원 1회 가드 — 새로고침=새 store 라 false 로 재복원, keep-alive 탭 전환엔 유지(클로버 방지).
  conditionsRestored: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  staticColumn: RawFlexGridColumnConfig[];
}

interface WorkingTimeAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  // F6 개인화 조회조건 복원(mount 1회) — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치.
  restoreSearchConditions: () => Promise<void>;
}

// F6 개인화 복원 역직렬화 — personalizeCondition(gridAction.ts) 저장 규약의 역.
//   저장 측은 멀티셀렉트 배열=콤마 join·그 외 String·날짜(startYyyymmdd/endYyyymmdd 류)=EXCLUDED_DATE_PARAM 제외.
//   복원: 아래 멀티셀렉트 키는 콤마 분해 배열로, 그 외는 문자열 그대로 patch(저장 안 된 날짜/미등록 키는 기본값 유지).
const RESTORE_ARRAY_KEYS = new Set<keyof SearchParamProps>([
  'plantSiteIds',
  'buildingIds',
  'operationIds',
  'lineIds',
]);

// dCalendar 기본기간 — 02_search-combo §4 PERIOD_* BIZ 프리셋. 데이터량·성능 확정 전 기본안으로
//   당월 1일 ~ 익월 말일(근무 캘린더는 단기 범위) — dayjs 로컬 날짜(toISOString UTC 금지).
//   PERIOD_* SP 연동은 확인필요 이월(04_react-gap) — 우선 클라 기본값으로 개통.
const initPeriod = {
  start: dayjs().startOf('month').format('YYYYMMDD'),
  end: dayjs().add(1, 'month').endOf('month').format('YYYYMMDD'),
};

const initWorkingTimeState: WorkingTimeState = {
  initialized: false,
  conditionsRestored: false,
  isOpenSearchArea: true,
  searchParams: {
    // 마운트 시 첫 권한 division 자동선택 — Form 이 옵션 로드 후 교정(session.div 비어있을 수 있음).
    divisionId: useSessionStore.getState().session.div ?? '',
    plantSiteIds: [],
    buildingIds: [],
    operationIds: [],
    lineIds: [],
    // cboDayWeek 기본 SelectDay — btnInput 값입력 전 미선택 상태(02 §2-b·§4).
    dayWeekCode: 'SelectDay',
    startYyyymmdd: initPeriod.start,
    endYyyymmdd: initPeriod.end,
    inputValue: '',
  },
  filters: {},
  staticColumn: [],
};

export const useWorkingTimeStore = createPersistedStoreWithTab<
  WorkingTimeState & WorkingTimeAction
>(
  (set, get) => ({
    ...initWorkingTimeState,
    reset: () => set(initWorkingTimeState),

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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(날짜)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선,
    //   정본 SCP0025 setShipmentPlanFix setDivision 1:1). 기간(start/end yyyymmdd)은 유지한다.
    //   초기화 대상: plantSite/building/operation/line cascade + dayWeekCode(→SelectDay) + inputValue.
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    //   그리드측 EditTracker clearChanges·hasSearched 되돌림은 store 가 만질 수 없어 부모 resetGrid 가 보완한다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initWorkingTimeState.searchParams, // Division·기간 제외 전 조건 초기화(cascade/dayWeek/inputValue)
          divisionId,
          startYyyymmdd: cur.startYyyymmdd, // 기간 유지
          endYyyymmdd: cur.endYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilters: () => {
      // 키명 = PKG_SCP0019.P_SCP0019_GET_WORKING_TIME PROC_M COL_NM (03_grid-columns §2-a 실측 IN 7).
      //   SP 본문이 division/plant/line 을 comma-split(REGEXP_SUBSTR) IN 필터 + 'ALL' 미필터 처리하므로
      //   멀티 콤보 빈값은 'ALL' sentinel(orAll)로 넘긴다. sesUserId/mnuId 는 BE 세션 자동(보강 전송).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        const p = state.searchParams;
        const orAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
        state.filters = {
          [SHEETS.MAIN]: {
            fromYyyymmdd: p.startYyyymmdd, //   1 P_FROM_YYYYMMDD
            toYyyymmdd: p.endYyyymmdd, //        2 P_TO_YYYYMMDD
            divisionId: p.divisionId, //         3 P_DIVISION_ID (단일 필수)
            plantSiteId: orAll(p.plantSiteIds),//4 P_PLANT_SITE_ID
            factoryId: orAll(p.buildingIds), //  5 P_FACTORY_ID (Building)
            operationId: orAll(p.operationIds),//6 P_OPERATION_ID
            lineId: orAll(p.lineIds), //         7 P_LINE_ID
            sesUserId, //                        세션 자동(보강)
            mnuId: MENU_ID, //                   세션 자동(보강)
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    // ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 14행, admin 즉시 반영).
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Working Time' — 등록명 그대로 (룰 #91)
          }
        );
        set(state => {
          state.staticColumn = result.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // BE 메타 미응답 시 silent — staticColumn 은 빈 배열로 남는다 (console 금지 룰)
      }
    },

    // F6 개인화 조회조건 복원(mount 1회) — SubTitle F6 저장분(personalizeCondition)을 GET 으로 받아
    //   searchParams 에 역직렬화 patch. 멀티셀렉트는 콤마 분해 배열로, 그 외는 문자열 그대로.
    //   저장 안 된 날짜(EXCLUDED_DATE_PARAM)·미저장/조회 실패 시 기본값 유지. 자동 재조회는 하지 않는다
    //   (filters 는 비운 채 — 사용자가 Search 를 눌러 복원된 조건으로 조회, AS-IS 파리티). IntegrationPsi 선례.
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
        const init = initWorkingTimeState.searchParams;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in init)) continue; // SearchParamProps 필드만 allowlist
          const key = paramNm as keyof SearchParamProps;
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(key)) patch[key] = val === '' ? [] : val.split(',');
          else patch[key] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as SearchParamProps;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'working-time-store'
);
