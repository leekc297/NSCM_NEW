import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ALL,
  BTN_GET_SCP_PERIOD,
  DEBUG_MODE,
  DEFAULT_DAY_WEEK,
  MENU_ID,
  SHEETS,
} from './shipment-working-day.constants';
import type { SearchCondition } from './shipment-working-day.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  openSearchArea: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  // 헤더 3단 컬럼셋(3SPAN) 조건. MAIN 과 분리한다 — AS-IS 는 조회 전에도 InitSpread 가 3SPAN 을
  //   1회 불러 정적 2열 + 초기 기간 D_ 열을 만들어 둔다(03 §4-d). Division 변경으로 그리드 행을
  //   비울 때(clearFilters)도 컬럼은 남아야 AS-IS 와 같은 형상이 된다.
  calendarFilters?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
  // 권한 Division 코드 목록. Form 로컬 useMemo 에만 두면 setFilters 가 접근할 수 없어
  //   divisionId='ALL' 전개(02 §4.4)가 통째로 끊긴다 — store 가 보유한다.
  divisionCodes: string[];
  // 컬럼 메타(admin SCM_MST_SHEET_COLUMNS 2행). 편집 가부와 필수검증이 전부 여기 달려 있다.
  staticColumns: StaticColumnsBySheet;
  // 메타 요청 "실패" 와 "정상 0건" 구분. 실패를 0건으로 삼키면 검증 없는 편집·저장이 열린다.
  staticColumnsError: boolean;
  // Period 기본값 SP 를 이미 적용했는지(1회 가드). 사용자가 지운 기간을 되살리지 않는다.
  dayRangeApplied: boolean;
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchCondition: (patch: Partial<SearchCondition>) => void;
  setDivisionCodes: (codes: string[]) => void;
  setFilters: () => void;
  syncCalendarFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  fetchDayRange: () => Promise<void>;
}

// 초기 상태는 호출 시점에 새로 만든다 — 모듈 로드 1회 상수로 두면 탭/계정 간 중첩 객체가 공유된다.
const makeInitState = (): State => ({
  initialized: false,
  openSearchArea: true,
  searchCondition: {
    // Company/Division 초기값은 콤보 로드 후 Form 이 1회 보정한다(AS-IS DataSource 바인딩 등가).
    companyId: '',
    divisionId: ALL,
    fromYyyymmdd: '',
    toYyyymmdd: '',
    dayWeekCode: DEFAULT_DAY_WEEK,
    inputValue: '',
  },
  filters: {},
  calendarFilters: undefined,
  divisionCodes: [],
  staticColumns: { [SHEETS.MAIN]: [] },
  staticColumnsError: false,
  dayRangeApplied: false,
});

// F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 대상 키 — SearchCondition 필드와 1:1.
//   personalizeCondition 이 값을 문자열로 coerce 하므로(멀티 divisionId 는 콤마 문자열) 전부 문자열
//   그대로 되돌린다. SEARCH_KEYS 밖 paramNm(구버전 잔재)은 버려 SP payload 오염을 막는다.
const SEARCH_KEYS = new Set<string>([
  'companyId',
  'divisionId',
  'fromYyyymmdd',
  'toYyyymmdd',
  'dayWeekCode',
  'inputValue',
]);

export const useShipmentWorkingDayStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    // F10(조회조건 초기화)에서 그리드는 유지한다(사용자 지시 2026-10-06) — 그리드 행/컬럼셋 축인
    //   filters·calendarFilters 는 보존하고 조회조건만 초기화한다. staticColumns·initialized 등은
    //   resetSearchCondition(PRESERVED_ON_CONDITION_RESET)이 별도 복원한다. reset 은 F10 에서만 호출된다
    //   (전역 clear-all 은 createStore 의 별도 reset). 재조회는 Search 로만.
    reset: () => {
      const { filters, calendarFilters } = get();
      set({ ...makeInitState(), filters, calendarFilters });
    },

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    setSearchCondition: patch =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...patch };
      }),

    setDivisionCodes: codes =>
      set(state => {
        if (state.divisionCodes.join(',') !== codes.join(',')) state.divisionCodes = codes;
      }),

    setFilters: () => {
      set(state => {
        const c = state.searchCondition;
        // 3 P_DIVISION_ID — 주의: 리터럴 'ALL' 을 보내면 TO-BE SP 가 UPPER(값)='ALL' 로
        //   필터를 건너뛰어 권한 밖 Division 행까지 반환한다(AS-IS 에 없는 권한 우회).
        //   AS-IS CString.GetCheckedListValue 2인자 오버로드가 'ALL' 을 dt 전건 CODE 콤마
        //   전개로 바꾼 동작을 그대로 재현한다(CS2:526-547, cs:387).
        const divisionId = c.divisionId === ALL ? state.divisionCodes.join(',') : c.divisionId;
        // 이중 방어 — 전개 결과가 비면 filters 를 세우지 않는다. Oracle 은 빈 문자열을 NULL 로
        //   보므로 `:B_DIVISION_YN IS NULL` 가지가 열려 필터가 사라진다. 화면 가드(handleSearch)를
        //   누가 우회해도 여기서 한 번 더 막는다.
        if (!divisionId) return;
        // 같은 축의 이중 방어 — companyId 가 비면 SP 의 `:B_COMPANY_YN IS NULL` 가지가 열려
        //   전 회사 행이 돌아온다(BODY L206-209). Company 는 ALL 옵션이 없는 단일 선택이라
        //   "전 회사"는 화면 사양에 없다.
        if (!c.companyId) return;
        // 키명 = SCM_ADM_PROC_M.COL_NM 실측 camelCase, IN 순번 1~5.
        //   (PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY)
        state.filters = {
          [SHEETS.MAIN]: {
            fromYyyymmdd: c.fromYyyymmdd, //  1 P_FROM_YYYYMMDD (AS-IS cs:389 Text1.Replace("-",""))
            toYyyymmdd: c.toYyyymmdd, //      2 P_TO_YYYYMMDD   (AS-IS cs:390)
            divisionId, //                    3 P_DIVISION_ID (위 전개값)
            companyId: c.companyId, //        4 P_COMPANY_ID (단일 선택, ALL 옵션 없음)
            debugMode: DEBUG_MODE, //         5 P_DEBUG_MODE (AS-IS cs:409 "F")
          },
        };
        // 컬럼셋 재구성 트리거는 조회 발사 시점 스냅샷 하나뿐이다 — 기간을 바꿔도 조회 전에는
        //   컬럼이 그대로다(AS-IS drpPeriod 에 이벤트 배선 0건, 03 §2-a). 조회조건 state 를
        //   컬럼 memo deps 에 넣으면 미저장 편집이 조용히 날아간다.
        state.calendarFilters = {
          startYyyymmdd: c.fromYyyymmdd, // 1 P_START_YYYYMMDD
          endYyyymmdd: c.toYyyymmdd, //     2 P_END_YYYYMMDD
        };
      });
    },

    // 조회 전 초기 형상 — AS-IS Form_Load 가 InitSpread 에서 3SPAN 을 1회 불러 정적 2열 +
    //   초기 기간의 D_ 열을 만들어 둔다(행만 없다).
    //   호출처는 단 하나다: 페이지가 dayRangeApplied 전이 시점에 1회만 부른다(calendarInitRef).
    //   금지: 기간 state 변화에 반응해 부르지 않는다 — 컬럼셋 재구성 트리거는 조회 발사 시점
    //   스냅샷(setFilters)뿐이어야 하고, 반응형으로 열면 미저장 편집이 조용히 사라진다(03 §2-a).
    syncCalendarFilters: () =>
      set(state => {
        const c = state.searchCondition;
        if (!c.fromYyyymmdd || !c.toYyyymmdd) return;
        if (
          state.calendarFilters?.startYyyymmdd === c.fromYyyymmdd &&
          state.calendarFilters?.endYyyymmdd === c.toYyyymmdd
        ) {
          return;
        }
        state.calendarFilters = { startYyyymmdd: c.fromYyyymmdd, endYyyymmdd: c.toYyyymmdd };
      }),

    // 그리드 행만 비운다(MAIN query disabled). 컬럼셋은 기간 축이라 남긴다 — AS-IS 도 Division
    //   변경으로 컬럼을 다시 만들지 않는다.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch(mount + Search 마다). 실측 2행 등록돼 있다.
    //   "정상 0건"(미등록)과 "실패"를 구분한다 — 편집 가부(INPUT_TP_CD)와 저장 필수검증이 전부
    //   이 메타에 달려 있어(hook #130), 실패를 0건으로 삼키면 검증 없는 저장이 열린다.
    //   실패 시 마지막 정상 메타는 보존한다(빈 배열로 덮으면 조용히 컬럼이 사라진다).
    fetchStaticColumns: async () => {
      // 1) 컬럼 메타 — 매 호출(mount + Search). 성패로 staticColumnsError 갱신.
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        set(state => {
          if (
            next.length > 0 &&
            JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)
          ) {
            state.staticColumns[SHEETS.MAIN] = next;
          }
          state.staticColumnsError = false;
        });
      } catch {
        set(state => {
          state.staticColumnsError = true;
        });
      }

      // 2) F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드, SSP0014 동형). 기간(from/to)을
      //    복원하면 dayRangeApplied=true 로 세워 기본기간 SP(fetchDayRange)가 덮어쓰지 않게 한다.
      //    페이지가 fetchDayRange 를 initialized 이후로 미뤄 순서를 보장한다.
      //    createPersistedStoreWithTab 은 sessionStorage 미영속이라 전체 새로고침 시 복원이 다시 돈다.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const rows = res.data.result ?? [];
          if (rows.length > 0) {
            const patch: Record<string, string> = {};
            for (const { paramNm, paramCtn } of rows) {
              if (SEARCH_KEYS.has(paramNm)) patch[paramNm] = paramCtn ?? '';
            }
            set(state => {
              state.searchCondition = {
                ...state.searchCondition,
                ...(patch as Partial<SearchCondition>),
              };
              if (patch.fromYyyymmdd && patch.toYyyymmdd) state.dayRangeApplied = true;
            });
          }
        } catch {
          // 저장조건 미존재/조회 실패 — 기본값 유지 (console 금지 룰)
        }
        set(state => {
          state.initialized = true;
        });
      }
    },

    // Period 기본값 — PKG_COM0000.P_SCM0001_GET_SCP_PERIOD (IN fromDate/offsetMonth/timeZone,
    //   OUT o_rc1 1행 1열 'YYYYMMDD:YYYYMMDD'). SCM_SYS_CALENDAR_M 존재구간 + 종료일 직전 일요일
    //   보정이라 dayjs().add(12,'month') 근사로는 경계가 어긋난다(자매 3화면이 근사로 우회해 gap 잔존).
    //   offsetMonth 는 SP 가 무시하고 12 를 고정한다(AS-IS 동일) — 빈 값으로 보낸다.
    //   timeZone: TO-BE UserSession 에 타임존 필드가 없다. 자매 SSP0200 과 동일하게 빈 값으로
    //   보내 SP 기본 처리(FN_MULTY_TIME)에 맡긴다.
    fetchDayRange: async () => {
      if (get().dayRangeApplied) return;
      try {
        const res = await apiClient.post<Record<string, Record<string, string>[]>>(
          `/${MENU_ID}/${SHEETS.MAIN}/${BTN_GET_SCP_PERIOD}/call-proc`,
          { fromDate: '', offsetMonth: '', timeZone: '' }
        );
        if (res.status >= 400 || Number(res.data.code)) return;
        const first = res.data.result?.o_rc1?.[0];
        // 반환 컬럼명은 PERIOD 지만 AS-IS 가 인덱스 접근(Rows[0][0])이었으므로 첫 값으로도 읽는다.
        const raw = first ? String(first.PERIOD ?? Object.values(first)[0] ?? '') : '';
        const [from, to] = raw.split(':');
        if (!from || !to) return;
        set(state => {
          state.searchCondition.fromYyyymmdd = from;
          state.searchCondition.toYyyymmdd = to;
          state.dayRangeApplied = true;
        });
      } catch {
        // SP/권한 미배포 시 기본 기간 없음 — 사용자가 직접 지정한다. 클라 근사로 대체하지 않는다.
      }
    },
  }),
  'shipment-working-day-store'
);
