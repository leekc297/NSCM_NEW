import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { sessionTimeZone } from '@foundation/utils';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  BTN_DAY_PERIOD,
  COMBO,
  DEFAULT_PLAN_TYPE,
  DEFAULT_STATUS,
  FIXED_DIVISION,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  PLAN_TYPE_P_FROM_OFFSET,
  PLAN_TYPE_PLAN,
  SHEETS,
} from './shipment-change-request.constants';
import type { RequestInfo, SearchCondition } from './shipment-change-request.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SUB]?: ProcRequest<MENU_ID, SHEETS.SUB>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.SUB]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  // 저장된 조회조건에서 Period(fromYyyymmdd/toYyyymmdd)를 복원했는지 표식.
  //   true 면 mount 기본값 산출(initPeriodDefault→fetchDayRange)이 복원값을 덮지 않는다
  //   (F6 conditionIncludeKeys 로 저장한 Shipment Date 가 재진입 시 기본 30일로 되돌아가던 것 방지).
  periodRestored: boolean;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  requestInfo: RequestInfo;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  // GAP-08: mount 시 Period 기본값(30일) 세팅. Plan Type 변경 시 재계산 + 그리드 clear.
  initPeriodDefault: () => void;
  /**
   * AS-IS GetDayRange 등가 — 캘린더(영업일/타임존) 기준 SP 산출. dayjs 근사 금지(design 02 §5.4).
   *   force=true 면 periodRestored(복원 Period) 가드를 무시하고 강제로 재산출한다 — Plan Type 변경
   *   cascade 처럼 사용자가 명시적으로 기간 재계산을 의도한 경로 전용. 기본(false)은 복원값을 보존한다.
   */
  fetchDayRange: (fromDate: string, force?: boolean) => Promise<void>;
  changePlanType: (changeType: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setRequestInfo: (p: Partial<RequestInfo>) => void;
  clearRequestInfo: () => void;
  /** 요청자명(세션) 주입 — AS-IS SetUserInfo(cs:517~526)의 이름 축. */
  initSessionFields: () => void;
  /**
   * 요청부서(세션 축) 보완 — AS-IS 는 `UserInfoContext["Dept_ID"]/["Dept_Name"]`(cs:521~526)를 쓴다.
   *   TO-BE UserSession 에 부서 필드가 없어 **로그인 사용자 부서를 주는 콤보**로 대체한다.
   *   금지: 서브 조회 o_rc2 로 채우기 — 그 커서는 모델 담당자(승인자 후보)라 남의 부서가 저장된다.
   */
  fetchRequestorDept: () => Promise<void>;
  fetchStaticColumns: () => Promise<void>;
}

// AS-IS cs:517~526 SetUserInfo 는 세션에서 이름·부서명·부서ID 를 모두 주입하지만, TO-BE UserSession
//   에는 부서 필드가 없다(실측: groupId/langCd/userId/userEngNm/userNm/div/menus 뿐).
//   -> 이름만 세션에서 채우고 부서는 `fetchRequestorDept()`(로그인 사용자 부서 콤보)로 보완한다.
//   종전엔 `requestor` 에 **userId** 를 넣어 Requestor 칸에 ID 가 보였다(자매 SSP0200 은 이름).
const sessionUserName = (): string => {
  const session = useSessionStore.getState().session;
  const name = session.langCd === 'KO' ? session.userNm : (session.userEngNm ?? session.userNm);
  return String(name ?? session.userId ?? '');
};

// R9 ClearRequestInfo / Plan Type 변경 시 **유지**할 세션 축 3필드(AS-IS 는 clear 직후 SetUserInfo 로
//   다시 채운다 — cs:517~526). 요청부서는 콤보 1회 조회분이라 비우면 재조회 없이 빈칸으로 남는다.
const sessionRequestFields = (prev: RequestInfo): Partial<RequestInfo> => ({
  requestor: sessionUserName(),
  requestDeptName: prev.requestDeptName,
  requestDeptId: prev.requestDeptId,
});

const emptyRequestInfo: RequestInfo = {
  requestNo: '',
  title: '',
  requestor: '',
  requestDeptName: '',
  requestDeptId: '',
  approval: '',
  approvalId: '',
  appDeptName: '',
  appDeptId: '',
  changeReason: '',
  reasonDetail: '',
};

const initSearch: SearchCondition = {
  divisionId: FIXED_DIVISION, // R3 고정 '40'
  fromSiteIds: [],
  toSiteIds: [],
  changeType: DEFAULT_PLAN_TYPE, // 'C'
  status: DEFAULT_STATUS, // 'ALL'
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  erpSoNo: '',
  confirmId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.SUB]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  periodRestored: false,
  filters: {},
  openSearchArea: true,
  requestInfo: emptyRequestInfo,
  staticColumns: emptyStaticColumns,
};

// design 02 §2-3/§3: Period 기본 = GetDayRange(base) = SCM0001_GET_SCP_DAY_PERIOD(base, offset=30, TZ).
//   30일 범위 산출은 SP 몫이다(SCM_SYS_CALENDAR_M 기준 영업일/타임존) — dayjs 근사 금지(design 02 §5.4,
//   자매 SSP0200 fetchDayRange 동일). 아래 fetchDayRange 가 /GET_SCP_DAY_PERIOD/call-proc 로 호출한다.
// SP 에 넘길 base(p_from_date): Plan Type 'P' 는 오늘+9D(cs:3096, design 02 §3 cascade#2), 그 외 '' →
//   SP 가 세션 타임존 기준 '오늘'을 잡는다. +9 캘린더 가산만 dayjs 로 한다(AS-IS 도 C# 클라 계산).
const periodFromBase = (changeType: string): string =>
  changeType === PLAN_TYPE_PLAN ? dayjs().add(PLAN_TYPE_P_FROM_OFFSET, 'day').format('YYYYMMDD') : '';

// 다중/단일/다건 -> SP 파라미터 문자열. ALL/빈값 = '' (전체, GET SP TRIM 무시).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const oneOrEmpty = (v: string): string => (v && v !== ALL ? v : '');
// 개행/콤마 다건 -> 콤마 join (AS-IS UsrMultiLineEditor .Text, GET SP FN_GET_IN_STR IN절).
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentChangeRequestStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    // F10(조회조건 초기화) 전용 — MotherStore.resetSearchCondition 이 이 reset() 을 부른다.
    //   자매 SSP0200 ac551790 과 동일 규약:
    //   · 조회된 그리드(filters)는 비우지 않는다 — 조회조건만 초기화하고 조회 데이터는 유지한다.
    //     (종전 `set(initState)` 는 filters 까지 날려 F10 이 그리드까지 비웠다.)
    //   · staticColumns/initialized 는 MotherStore 가 별도 보존하므로 함께 유지한다.
    //   · Period 는 initSearch 에서 ''이므로 삭제만 되지 않도록 기본값을 재산출한다.
    //   · 요청정보는 "삭제"가 아니라 "초기화"다 — 세션 축(Requestor/Dept)은 유지하고 편집필드
    //     (Approval/Title/Change Reason/Reason Detail)만 비운다(clearRequestInfo 와 동일 규약).
    //     종전엔 initState 의 emptyRequestInfo 로 Requestor/Dept 까지 전부 비워 삭제처럼 보였다
    //     (사용자 신고 2026-10-28).
    reset: () => {
      const { filters, staticColumns, initialized, requestInfo } = get();
      set({
        ...initState,
        filters,
        staticColumns,
        initialized,
        requestInfo: { ...emptyRequestInfo, ...sessionRequestFields(requestInfo) },
      });
      // Plan Type 기준 30일 기본값 재산출(SCM0001_GET_SCP_DAY_PERIOD SP — fetchDayRange, 아래 참조).
      get().initPeriodDefault();
    },
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setPeriod: (fromYyyymmdd, toYyyymmdd) =>
      set(state => {
        state.searchCondition.fromYyyymmdd = fromYyyymmdd;
        state.searchCondition.toYyyymmdd = toYyyymmdd;
      }),
    // GAP-08: mount 최초 진입 시 Period 기본값(현 Plan Type 기준 30일 범위) SP 산출.
    initPeriodDefault: () => {
      void get().fetchDayRange(periodFromBase(get().searchCondition.changeType));
    },
    // AS-IS GetDayRange 등가 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD(IN fromDate/offsetDay/timeZone,
    //   OUT o_rc1 1행 1열 "YYYYMMDD:YYYYMMDD"). SCM_SYS_CALENDAR_M 기준이라 dayjs 근사로는 경계가 어긋난다.
    //   timeZone: 세션 TZ 를 보낸다 — SP 가 fromDate 공란이면 FN_MULTY_TIME(P_TIMEZONE) 으로 '오늘'을 잡는다.
    //   자매 SSP0200 useShipmentChangeRequestPlanStore.fetchDayRange 와 동일 배선(design 02 §5.4).
    fetchDayRange: async (fromDate, force = false) => {
      // 복원된 Period(F6 저장분)가 있으면 mount 기본값 산출로 덮지 않는다 — restore 와 이 비동기
      //   SP 호출의 완료 순서에 무관하게 복원값이 이긴다. force(=Plan Type cascade)는 가드를 넘긴다.
      if (!force && get().periodRestored) return;
      try {
        const res = await apiClient.post<Record<string, Record<string, string>[]>>(
          `/${MENU_ID}/${SHEETS.MAIN}/${BTN_DAY_PERIOD}/call-proc`,
          {
            fromDate,
            offsetDay: PERIOD_OFFSET_DAY,
            timeZone: sessionTimeZone(useSessionStore.getState().session),
          }
        );
        if (res.status >= 400 || Number(res.data.code)) return;
        const first = res.data.result?.o_rc1?.[0];
        const raw = first ? String(Object.values(first)[0] ?? '') : '';
        const [from, to] = raw.split(':');
        if (!from || !to) return;
        // await 사이에 restore 가 periodRestored 를 세웠을 수 있다 — 쓰기 직전 재확인(느린 SP 대비).
        if (!force && get().periodRestored) return;
        set(state => {
          state.searchCondition.fromYyyymmdd = from;
          state.searchCondition.toYyyymmdd = to;
        });
      } catch {
        // SP/권한 미배포 시 기간 기본값 없음 — 사용자가 직접 지정한다. 클라 근사로 대체하지 않는다.
      }
    },
    // GAP-08: Plan Type 변경(design 02 §3 cascade#2) — Period 재계산 + 그리드/요청정보 clear(InitSpread).
    changePlanType: changeType => {
      set(state => {
        state.searchCondition.changeType = changeType;
        state.filters = {};
        // 세션 축 3필드(요청자·요청부서)는 유지한다 — 비우면 Plan Type 을 바꾼 뒤 Dept Name 이
        //   빈칸이 되고, 저장 payload 의 요청부서까지 빈 값으로 나간다.
        state.requestInfo = { ...emptyRequestInfo, ...sessionRequestFields(get().requestInfo) };
      });
      // Period 기본값 SP 재산출 — 'P' 면 fromDate=오늘+9D, 그 외 ''(SP 가 세션TZ '오늘'). set() 이후 비동기 갱신.
      //   force=true: 사용자가 Plan Type 을 바꾼 명시 재계산이므로 복원 Period 가드를 넘어 항상 갱신한다.
      void get().fetchDayRange(periodFromBase(changeType), true);
    },
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST(메인) 파라미터 (design 02 §1):
        //   p_division_id / p_from_site / p_to_site / p_change_type / p_status / p_item_id /
        //   p_from_yyyymmdd / p_to_yyyymmdd / p_erp_so_no / p_confirm_id / p_language(@sesLangCd 세션)
        const language = useSessionStore.getState().session.langCd ?? '';
        const base = {
          divisionId: c.divisionId,
          fromSite: joinOrEmpty(c.fromSiteIds),
          toSite: joinOrEmpty(c.toSiteIds),
          changeType: c.changeType,
          status: oneOrEmpty(c.status),
          itemId: multiLine(c.itemId),
          fromYyyymmdd: c.fromYyyymmdd,
          toYyyymmdd: c.toYyyymmdd,
          erpSoNo: multiLine(c.erpSoNo),
          confirmId: multiLine(c.confirmId),
          language,
        };
        state.filters = {
          // 메인/서브는 동일 조회조건, 서브 GET SP 는 내부적으로 request_status='D' 필터.
          [SHEETS.MAIN]: base,
          [SHEETS.SUB]: base,
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    setRequestInfo: p =>
      set(state => {
        state.requestInfo = { ...get().requestInfo, ...p };
      }),
    clearRequestInfo: () =>
      set(state => {
        // R9 ClearRequestInfo — Requestor/Dept 세션값은 유지, 편집필드만 초기화.
        state.requestInfo = { ...emptyRequestInfo, ...sessionRequestFields(get().requestInfo) };
      }),

    initSessionFields: () =>
      set(state => {
        state.requestInfo.requestor = sessionUserName();
      }),

    fetchRequestorDept: async () => {
      // 1) 로그인 사용자 부서ID — @sesUserId 는 BE 가 주입한다(화면이 싣지 않는다).
      //    조회 실패·0행이면 빈 값으로 남긴다. 임의 대체값(모델 담당자 부서 등)으로 채우지 않는다 —
      //    그 값이 요청확정 payload 의 요청부서로 그대로 저장된다.
      try {
        const deptRows = await apiClient.getCombo({ comboId: COMBO.REQUESTOR_DEPT });
        const deptId = String(deptRows?.[0]?.CODE ?? '');
        if (!deptId) return;
        // 2) 표시용 부서명. 본문 WHERE 가 LIKE '%값%' OR 체인이라 과다 매칭될 수 있어 완전일치로 좁힌다.
        //    이름을 못 찾으면 공백으로 둔다(부서ID 를 부서명 칸에 넣지 않는다).
        let deptName = '';
        try {
          const nameRows = await apiClient.getCombo({
            comboId: COMBO.DEPT_NAME,
            deptId,
            param1: String(useSessionStore.getState().session.langCd ?? ''),
          });
          deptName = String((nameRows ?? []).find(r => String(r.CODE) === deptId)?.NAME ?? '');
        } catch {
          // 부서명 조회 실패는 표시 축만 비운다 — 부서ID(저장 축)는 유지한다.
        }
        set(state => {
          state.requestInfo.requestDeptId = deptId;
          state.requestInfo.requestDeptName = deptName;
        });
      } catch {
        // 콤보 미등록/권한 오류 — 요청부서는 빈 값으로 남는다.
      }
    },

    fetchStaticColumns: async () => {
      // 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4.1). 미등록/실패 시 빈 배열 유지.
      for (const sheet of [SHEETS.MAIN, SHEETS.SUB]) {
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm: ADMIN_SHEET_NAME[sheet] }
          );
          const next = res.data.result ?? [];
          if (next.length > 0) {
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          }
        } catch {
          // 미등록/실패 = 빈 배열(console 금지 룰)
        }
      }
      // 저장된 조회조건 복원(최초 1회) — 자매 SSP0200 ac551790 item4 와 동일 규약.
      //   F6(personalizeCondition) 저장은 되는데 복원 경로가 없어 재진입 시 사라졌다.
      //   다중선택(fromSiteIds/toSiteIds)은 저장 시 콤마 join 되므로(gridAction personalizeCondition)
      //   배열로 되돌린다. 직접 set 이라 Plan Type cascade 미발동(복원값 그대로 유지).
      //   실패/미등록은 무시한다 — 명시 Search 전에는 어차피 조회가 나가지 않는다.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const list = res.data.result ?? [];
          if (list.length > 0) {
            const restored: Partial<SearchCondition> = {};
            for (const { paramNm, paramCtn } of list) {
              if (paramNm === 'fromSiteIds' || paramNm === 'toSiteIds') {
                restored[paramNm] = paramCtn ? paramCtn.split(',').filter(Boolean) : [];
              } else {
                (restored as Record<string, unknown>)[paramNm] = paramCtn;
              }
            }
            // Shipment Date(기간)까지 복원됐으면 periodRestored 를 세워 mount 기본값 산출이 덮지 않게 한다
            //   (F6 는 conditionIncludeKeys=['fromYyyymmdd','toYyyymmdd'] opt-in 으로 날짜를 저장한다).
            const periodRestored = !!(restored.fromYyyymmdd && restored.toYyyymmdd);
            set(state => {
              state.searchCondition = { ...get().searchCondition, ...restored };
              if (periodRestored) state.periodRestored = true;
            });
          }
        } catch {
          // 복원 실패 무시
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-change-request-store'
);
