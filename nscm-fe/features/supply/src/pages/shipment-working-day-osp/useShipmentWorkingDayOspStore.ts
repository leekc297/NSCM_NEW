import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { DAY_WEEK, MENU_ID, SHEETS } from './shipment-working-day-osp.constants';
import type { SearchParamProps } from './shipment-working-day-osp.types';

// SP filter payload — useTabProcQuery enabled 가드.
//   MAIN = PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (4 IN, OUT o_rc1 데이터 + o_result_cursor 상태).
//   커서 실측(all_source BODY, 03_grid-columns §4): o_rc1 = 동적 PIVOT(정적 6 + 'D_'||YYYYMMDD), o_result_cursor = 상태.
//   동적 기간 헤더는 데이터 커서가 아니라 사내 배선 타이틀 시트 CALENDAR(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)로
//   조회한다 — AS-IS InitSpread → GetSpdTitle(.cs:151,825-838) 1:1. (2026-10-20 정정: 이전 'BE 가 o_rc1_columns 로 노출'
//   가정은 BaseService 원문과 다르다 — 사이드카는 SYS0013 DynamicQuery 전용, DoD B26/B27.)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface ShipmentWorkingDayOspState {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  // 서버 dayRange(기본 조회기간) 적용 1회 가드 — false 인 동안 Page 의 dayRange 쿼리가 살아 있고 applyDayRange 가 기간을 교체한다.
  //   Reset Condition(F10) 의 reset() 이 false 로 되돌리면 캐시된 서버 구간을 다시 적용한다(BusinessPlan 정본 패턴).
  dayRangeApplied: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  // 동적 기간 헤더(3SPAN) 조건 — MAIN 과 분리한다. AS-IS 는 조회 전에도 Form_Load → CreateSpread → InitSpread 가
  //   GetSpdTitle 로 초기 기간의 일자 컬럼을 만들고(.cs:112,145,151), 조회 시 FindData_Main → InitSpread 로 다시 만든다(.cs:438).
  //   Division 변경(resetGrid/clearFilters)은 행만 비우고 컬럼셋(기간 축)은 남긴다 — AS-IS CboDivision 핸들러도 컬럼 무변경(.cs:660-663).
  calendarFilters?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
  staticColumn: RawFlexGridColumnConfig[];
}

interface ShipmentWorkingDayOspAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: () => void;
  clearFilters: () => void;
  // 조회 전 초기 컬럼셋 — 현재 Period 로 calendarFilters 를 1회 채운다(AS-IS Form_Load InitSpread 등가). 같으면 no-op.
  syncCalendarFilters: () => void;
  // mount 시 persist 된 이전 탭의 calendarFilters 무효화(stale 기간 헤더 자동 발사 방지).
  clearCalendarFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
  // 서버 dayRange o_rc1[0].PERIOD('yyyymmdd:yyyymmdd') → 기본 Period 1회 적용 (AS-IS dCalendar.InitValue = GetDayRange() .cs:137 1:1).
  applyDayRange: (range?: string) => void;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·날짜키 제외 — personalizeCondition).
//   plantSiteIds 는 배열 → 저장 시 콤마 join, 복원 시 split. 기간(startYyyymmdd/endYyyymmdd)은 저장측
//   EXCLUDED_DATE_PARAM 이 제외하므로 복원 rows 에 오지 않는다. 불리언 조회조건 없음.
const ARRAY_KEYS = new Set<string>(['plantSiteIds']);

// dCalendar 기본기간 placeholder — 정본은 서버 dayRange(PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD — AS-IS InitControls
//   `dCalendar.InitValue = GetDayRange()` .cs:137 = DateUtil.GetDayRange(cboDivision,'DAILY')) 응답이며 applyDayRange 가 교체한다.
//   응답 전·미응답 fallback 은 그 SP 산식 근사 = 오늘 ~ 12개월 뒤 일자의 직전 일요일(일요일이면 당일; SP L2773~2779
//   `TRUNC(TO_DATE(max)+1,'IW')-1`). 사내 실측 2026-10-20 → '20261020:20271017' 과 동일 산식. dayjs 로컬 날짜(toISOString UTC 금지).
//   (이전 '당월 1일 ~ 익월 말일' 은 AS-IS 산식과 달라 2026-10-20 정정.)
const initPeriod = (() => {
  const start = dayjs();
  const limit = start.add(12, 'month');
  return {
    start: start.format('YYYYMMDD'),
    end: limit.subtract(limit.day(), 'day').format('YYYYMMDD'), // day(): 0=일 → 직전(또는 당일) 일요일
  };
})();

const initShipmentWorkingDayOspState: ShipmentWorkingDayOspState = {
  initialized: false,
  conditionsRestored: false,
  dayRangeApplied: false,
  isOpenSearchArea: true,
  searchParams: {
    // 마운트 시 첫 권한 division 자동선택 — Form 이 옵션 로드 후 교정(session.div 비어있을 수 있음).
    divisionId: useSessionStore.getState().session.div ?? '',
    plantSiteIds: [],
    // cboDayWeek 기본 SelectDay — btnInput 값입력 전 선택셀 기입 모드(02 §2 #4).
    dayWeekCode: DAY_WEEK.SELECT_DAY,
    startYyyymmdd: initPeriod.start,
    endYyyymmdd: initPeriod.end,
    inputValue: '',
  },
  filters: {},
  calendarFilters: undefined,
  staticColumn: [],
};

export const useShipmentWorkingDayOspStore = createPersistedStoreWithTab<
  ShipmentWorkingDayOspState & ShipmentWorkingDayOspAction
>(
  (set, get) => ({
    ...initShipmentWorkingDayOspState,
    // F10(조회조건 초기화) — 컬럼셋(calendarFilters, 기간 축)은 보존한다. 비우면 Page 의 1회 동기화(calendarInitRef)가 다시 돌지 않아
    //   다음 조회 전까지 일자 컬럼이 사라진다(자매 SCP0095 reset 의 calendarFilters 보존 1:1).
    reset: () => set({ ...initShipmentWorkingDayOspState, calendarFilters: get().calendarFilters }),

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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(TO-BE 공통 요건이 AS-IS 핸들러보다 우선 — apply-division-reset,
    //   정본 SCP0025 setDivision). 유지: divisionId(새 값)·startYyyymmdd·endYyyymmdd. 초기화:
    //   plantSiteIds(cascade 하위)·dayWeekCode(기본 SelectDay)·inputValue. 편집중(dirty) 가드(MSG00704)는
    //   Form 의 onChange 가 confirmIfDirtyKey 로 처리하고(commit 51d4e9fa 패턴), 미저장 편집 폐기·hasSearched
    //   리셋은 부모 resetGrid(onDivisionChange)가 담당한다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initShipmentWorkingDayOspState.searchParams, // plantSite/dayWeek/inputValue 초기화
          divisionId,
          startYyyymmdd: cur.startYyyymmdd,
          endYyyymmdd: cur.endYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilters: () => {
      // 키명 = PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP all_arguments COL_NM (03 §4 실측 IN 4).
      //   SP 본문이 plant 를 comma-split IN 필터 + 'ALL' 미필터 처리하므로 멀티 콤보 빈값은 'ALL' sentinel(orAll).
      //   sesUserId/mnuId 는 BE 세션 자동(콤보 권한필터용, GET IN 아님 — 미전송).
      set(state => {
        const p = state.searchParams;
        const orAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: p.divisionId, //           1 P_DIVISION_ID (단일 필수)
            plantSiteId: orAll(p.plantSiteIds), //  2 P_PLANT_SITE_ID
            fromYyyymmdd: p.startYyyymmdd, //        3 P_FROM_YYYYMMDD
            toYyyymmdd: p.endYyyymmdd, //            4 P_TO_YYYYMMDD
          },
        };
        // 컬럼셋 재구성 = 조회 발사 시점 스냅샷 — AS-IS FindData_Main → InitSpread → GetSpdTitle(.cs:438,151,833-834)이
        //   dCalendar.Text1/Text2 로 3SPAN 을 다시 부른다. 키명 = 사내 PROC_M COL_NM(proc_params.csv P_SCP0009_GET_SHEET_CALENDAR_3SPAN IN 2).
        //   기간 state 변화에 반응형으로 열지 않는다(조회 전 기간 수정만으로 컬럼이 바뀌면 미저장 편집이 조용히 날아간다).
        state.calendarFilters = {
          startYyyymmdd: p.startYyyymmdd, // 1 P_START_YYYYMMDD (AS-IS dCalendar.Text1.Replace("-",""))
          endYyyymmdd: p.endYyyymmdd, //     2 P_END_YYYYMMDD   (AS-IS dCalendar.Text2.Replace("-",""))
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    syncCalendarFilters: () =>
      set(state => {
        const p = state.searchParams;
        if (!p.startYyyymmdd || !p.endYyyymmdd) return;
        if (
          state.calendarFilters?.startYyyymmdd === p.startYyyymmdd &&
          state.calendarFilters?.endYyyymmdd === p.endYyyymmdd
        ) {
          return;
        }
        state.calendarFilters = { startYyyymmdd: p.startYyyymmdd, endYyyymmdd: p.endYyyymmdd };
      }),
    clearCalendarFilters: () =>
      set(state => {
        state.calendarFilters = undefined;
      }),

    // ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 6행, admin 즉시 반영).
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Shipment Working Day OSP' — 등록명 그대로 (룰 #91)
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 shipment-plan-fix 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화. plantSiteIds 는 콤마 split,
    //   그 외는 문자열 그대로. 저장측이 날짜키(startYyyymmdd/endYyyymmdd)를 제외하므로 기간은 기본값 유지.
    //   저장분 없으면 기본값 유지. divisionId 저장분이 있으면 세션 기본 divisionId 를 덮는다.
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
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initShipmentWorkingDayOspState.searchParams)) continue; // 조회조건 필드만 allowlist
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as SearchParamProps;
          // 저장된 Period 가 있으면 서버 dayRange 가 덮지 못하게 잠근다(BusinessPlan·sales-plan 규칙). 현재 저장측은 날짜키를
          //   제외하므로 통상 도달하지 않으나, 저장 정책이 바뀌어도 복원값이 응답 도착 순간 되돌아가지 않도록 가드한다.
          if ('startYyyymmdd' in patch || 'endYyyymmdd' in patch) state.dayRangeApplied = true;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },

    // 서버 dayRange o_rc1[0].PERIOD 'yyyymmdd:yyyymmdd' → 기본 Period (AS-IS dCalendar.InitValue = GetDayRange() .cs:137 1:1).
    //   형식 불일치·빈값(SP 는 조회 구간이 없으면 NULL)은 무시 = placeholder 유지. 1회 적용 가드(dayRangeApplied).
    applyDayRange: range => {
      if (!range || !/^\d{8}:\d{8}$/.test(range)) return;
      if (get().dayRangeApplied) return;
      const [start, end] = range.split(':');
      set(state => {
        state.searchParams = { ...state.searchParams, startYyyymmdd: start, endYyyymmdd: end };
        state.dayRangeApplied = true;
      });
    },
  }),
  'shipment-working-day-osp-store'
);
