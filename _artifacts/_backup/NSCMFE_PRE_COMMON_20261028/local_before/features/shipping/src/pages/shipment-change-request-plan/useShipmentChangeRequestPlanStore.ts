import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  BTN_DAY_PERIOD,
  COMBO,
  DEFAULT_CHANGE_TYPE,
  DEFAULT_STATUS,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  SHEETS,
} from './shipment-change-request-plan.constants';
import type { RequestInfo, SearchCondition } from './shipment-change-request-plan.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SUB]?: ProcRequest<MENU_ID, SHEETS.SUB>;
};

type StaticColumnsBySheet = Record<SHEETS, RawFlexGridColumnConfig[]>;

interface State {
  initialized: boolean;
  /** 명시 조회 게이트 — 진입 자동조회 금지(nscm-patterns §5-7). */
  hasSearched: boolean;
  searchParams: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  /** chkSingleProcess — 해제 시 동일 ERP_SO_NO 전 행 전파(CP-11). AS-IS 기본 해제. */
  singleProcess: boolean;
  /**
   * C4 JVFlag — Division ATTRIBUTE1='0'(VP 경유만 권한)이면 true 이고, true 면 From Site 선택을
   * 무시하고 권한 전체 코드를 콤마 전개해 보낸다(C5, GetCheckedListValue 3번째 인자 false).
   * 원천 SP(SSP0200_GET_SHIPMENT_DIVISION)가 미이관이라 현재는 false 고정이다 — 조용한 기본값이
   * 되지 않도록 store 상태로 명시 보관하고 04/__asis-mapping__ 에 근거를 남긴다.
   */
  jvFlag: boolean;
  /** JVFlag=true 경로에서 콤마 전개할 From Site 권한 전체 코드(Form 이 콤보 결과로 채운다). */
  fromSiteAllCodes: string[];
  requestInfo: RequestInfo;
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchCondition>) => void;
  setPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  /** Div 변경 = 하위 콤보 선택값 + 그리드 + 컬럼메타 초기화 의무(hook #5 §1.4). */
  changeDivision: (divisionId: string) => void;
  /** ChangeType 변경 = 기간 재산출 + 요청정보 초기화 + 양 그리드 재구성(§3.2 #4·#5). */
  setFromSiteAllCodes: (codes: string[]) => void;
  setSingleProcess: (checked: boolean) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setRequestInfo: (p: Partial<RequestInfo>) => void;
  clearRequestInfo: () => void;
  /** 승인자 빈칸일 때만 서버 기본 승인자로 채운다(Δ7 / L-152). */
  fillApprovalIfEmpty: (approval: string, approvalId: string, dept: string, deptId: string) => void;
  initSessionFields: () => void;
  /**
   * 요청부서(세션 축) 보완 — AS-IS 는 `UserInfoContext["Dept_ID"]/["Dept_Name"]`(cs:523~524)를 쓴다.
   *   TO-BE UserSession 에 부서 필드가 없어 **로그인 사용자 부서를 주는 콤보**로 대체한다.
   *   금지: detail 조회 o_rc2 로 채우기 — 그 커서는 모델 담당자(승인자 후보)라 남의 부서가 저장된다.
   */
  fetchRequestorDept: () => Promise<void>;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  /** AS-IS GetDayRange 등가 — 캘린더 기준 SP 호출. dayjs 근사 금지(design 02 §5.4). */
  fetchDayRange: (fromDate: string) => Promise<void>;
}

const emptyRequestInfo: RequestInfo = {
  requestNo: '',
  requestor: '',
  requestDeptName: '',
  requestDeptId: '',
  approval: '',
  approvalId: '',
  appDeptName: '',
  appDeptId: '',
  title: '',
  changeReason: '',
  reasonDetail: '',
};

const initSearch: SearchCondition = {
  divisionId: '', // 콤보 로드 후 첫 행으로 채운다(AS-IS SelectedIndex=0)
  fromSiteIds: [],
  toSiteIds: [],
  status: DEFAULT_STATUS,
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
  erpSoNo: '',
  confirmId: '',
  changeType: DEFAULT_CHANGE_TYPE,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.SUB]: [],
};

const initState: State = {
  initialized: false,
  hasSearched: false,
  searchParams: initSearch,
  filters: {},
  openSearchArea: true,
  singleProcess: false,
  jvFlag: false,
  fromSiteAllCodes: [],
  requestInfo: emptyRequestInfo,
  staticColumns: emptyStaticColumns,
};

// 콤보 -> SP 파라미터. ALL/미선택은 'ALL' 로 보낸다(사용자 지시 2026-09-30 — SP 가 'ALL'=전체 처리).
//   과거엔 '' 로 보냈으나, 화면 표기(ALL)와 전송값을 일치시킨다. 다중선택은 실제 선택값을 콤마 join.
const joinOrAll = (values: string[]): string =>
  values.length === 0 || values.includes(ALL) ? ALL : values.join(',');
const oneOrAll = (value: string): string => (value && value !== ALL ? value : ALL);
// 개행/콤마 다건 입력 -> 콤마 join (AS-IS UsrMultiLineEditor .Text).
const multiLine = (value: string): string =>
  value
    ? value
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

// AS-IS cs:510~526 은 세션에서 이름·부서명·부서ID 를 모두 주입하지만, TO-BE UserSession 에는
//   부서 필드가 없다(실측: groupId/langCd/userId/userEngNm/userNm/div/menus 뿐).
//   -> 이름만 세션에서 채우고 부서는 `fetchRequestorDept()`(로그인 사용자 부서 콤보)로 보완한다.
const sessionUserName = (): string => {
  const session = useSessionStore.getState().session;
  const name = session.langCd === 'KO' ? session.userNm : (session.userEngNm ?? session.userNm);
  return String(name ?? session.userId ?? '');
};

export const useShipmentChangeRequestPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    // F10(조회조건 초기화) 전용 — MotherStore.resetSearchCondition 이 이 reset() 을 부른다.
    //   item2(사용자 지시 2026-10-07): 조회된 그리드(filters/hasSearched)는 비우지 않는다 — 조회조건만
    //     초기화하고 조회 데이터는 유지한다. staticColumns/initialized 는 MotherStore 가 별도 보존한다.
    //   item3: Shipment Date 는 삭제만 하지 말고 기본값으로 초기화한다(initSearch 기간 '' → fetchDayRange 재산출).
    reset: () => {
      const { filters, hasSearched, staticColumns, initialized } = get();
      set({ ...initState, filters, hasSearched, staticColumns, initialized });
      void get().fetchDayRange('');
    },

    setSearchParams: p =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...p };
      }),

    setPeriod: (fromYyyymmdd, toYyyymmdd) =>
      set(state => {
        state.searchParams.fromYyyymmdd = fromYyyymmdd;
        state.searchParams.toYyyymmdd = toYyyymmdd;
      }),

    changeDivision: divisionId => {
      set(state => {
        // Div 변경 = Division 제외 나머지 조회조건 초기값 reset(사용자 지시 2026-10-07 item1).
        //   **단 기간(Shipment Date)은 유지한다**(사용자 지시 2026-10-08): Division 을 바꿨다고
        //   사용자가 직접 고른 조회 기간이 날아가면 안 된다. 공통 요건(apply-division-reset)도
        //   "유지 대상 = Division + 기간/날짜 필드" 로 같은 규약이다 — 종전 구현이 그 규약을 어겼다.
        const { fromYyyymmdd, toYyyymmdd } = state.searchParams;
        state.searchParams = { ...initSearch, divisionId, fromYyyymmdd, toYyyymmdd };
        state.fromSiteAllCodes = [];
        // 그리드 초기화 — Div 변경 시 조회결과/조회상태를 비운다(apply-division-reset TO-BE 공통 요건,
        //   사용자 결정 2026-10-07: 공통 요건 우선 적용). 재조회(Search) 전까지 그리드는 빈 상태가 된다.
        state.filters = {};
        state.hasSearched = false;
        // JVFlag 는 Division ATTRIBUTE1 원천 SP 미이관이라 재판정할 수 없다 — false 고정 유지.
        state.jvFlag = false;
      });
      // 컬럼 메타는 div 변경 시 재요청하지 않는다(사용자 지시 2026-10-07): SSP0200 컬럼 메타는 division
      //   스코프가 아니라(DB DIVISION_ID 공란 실측) 같은 컬럼을 돌려주고, 재요청 응답이 가드를 뚫으면
      //   컬럼 재빌드→그리드 깜빡임이 난다. 컬럼 가시성(End Customer↔Project)은 화면이 '조회된 division'
      //   기준으로 토글한다. 메타는 mount·조회(handleSearch) 시점에만 fetch 한다.
      // 기간 재산출(fetchDayRange)도 하지 않는다 — 위에서 기간을 그대로 들고 왔으므로 재산출하면
      //   사용자가 고른 날짜를 기본값으로 덮어쓴다(사용자 신고 2026-10-08 "Shipment Date 가 초기화된다").
    },

    setFromSiteAllCodes: codes =>
      set(state => {
        state.fromSiteAllCodes = codes;
      }),

    setSingleProcess: checked =>
      set(state => {
        state.singleProcess = checked;
      }),

    setFilter: () => {
      set(state => {
        const p = state.searchParams;
        const session = useSessionStore.getState().session;
        // 키명 = SCM_ADM_PROC_M.COL_NM 실측(2026-09-27 ora.py, 대조 완료).
        //   PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST IN 12 (SORT_ORD 1~12)
        const fromSite = state.jvFlag
          ? // C5 — JV/VP 법인은 선택을 무시하고 권한 전체 코드를 콤마 전개한다(cs:1471 3-arg !JVFlag).
            state.fromSiteAllCodes.join(',')
          : joinOrAll(p.fromSiteIds);
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: p.divisionId, // 1  cs:1468
            fromSite, // 2  cs:1471 (C5)
            erpSoNo: multiLine(p.erpSoNo), // 3  cs:1479
            itemId: multiLine(p.itemId), // 4  cs:1476 txtRequest
            fromYyyymmdd: p.fromYyyymmdd, // 5  cs:1477
            toYyyymmdd: p.toYyyymmdd, // 6  cs:1478
            status: oneOrAll(p.status), // 7  cs:1475 ALL -> 'ALL'
            changeType: p.changeType, // 8  cs:1474
            language: String(session.langCd ?? ''), // 9  cs:1540
            debugMode: 'F', // 10 cs:1541 고정
            toSite: joinOrAll(p.toSiteIds), // 11 cs:1473 ALL -> 'ALL'
            confirmId: multiLine(p.confirmId), // 12 cs:1482
          },
          // detail(FindData_Sub_Draft cs:1995~2050)은 조회조건을 거의 쓰지 않는다 — Div 하드코딩('40'),
          //   From/To Site·Item·SO No·Confirm Id 전부 ''. 기간과 changeType 만 조회조건에서 가져온다.
          //   WHERE 가 SHIPMENT_STATUS='D' AND LAST_UPDATED_BY=요청자 라 "내 초안"만 나온다(0행 정상).
          [SHEETS.SUB]: {
            divisionId: '40',
            fromSite: '',
            toSite: '',
            erpSoNo: '',
            itemId: '',
            bodId: '',
            incoterms: '',
            transportMode: '',
            projectCode: '',
            fcstType: '',
            confirmId: '',
            fromYyyymmdd: p.fromYyyymmdd,
            toYyyymmdd: p.toYyyymmdd,
            changeRequestNo: '',
            requestUserId: String(session.userId ?? ''),
            requestStatus: 'D',
            language: String(session.langCd ?? ''),
            changeType: p.changeType,
            debugMode: 'F',
          },
        };
        state.hasSearched = true;
      });
    },

    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.hasSearched = false;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    setRequestInfo: p =>
      set(state => {
        state.requestInfo = { ...get().requestInfo, ...p };
      }),

    clearRequestInfo: () => {
      set(state => {
        state.requestInfo = { ...emptyRequestInfo };
      });
      // AS-IS ClearRequestInfo 직후 SetUserInfo 로 요청자·요청부서가 다시 채워진다(cs:517~526).
      get().initSessionFields();
      void get().fetchRequestorDept();
    },

    fillApprovalIfEmpty: (approval, approvalId, dept, deptId) =>
      set(state => {
        // L-152 — txtApproval.Text == "" 일 때만 채운다. 사용자가 고른 값을 덮지 않는다.
        if (state.requestInfo.approval) return;
        state.requestInfo.approval = approval;
        state.requestInfo.approvalId = approvalId;
        state.requestInfo.appDeptName = dept;
        state.requestInfo.appDeptId = deptId;
      }),

    initSessionFields: () =>
      set(state => {
        state.requestInfo.requestor = sessionUserName();
      }),

    fetchRequestorDept: async () => {
      // 1) 로그인 사용자 부서ID — @sesUserId 는 BE 가 주입한다(화면이 싣지 않는다).
      //    조회 실패·0행이면 빈 값으로 남긴다. 임의 대체값(모델 담당자 부서 등)으로 채우지 않는다 —
      //    그 값이 요청확정 payload 의 requestDeptId(SP 45 IN 중 5번)로 그대로 저장된다.
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
        // 콤보 미등록/권한 오류 — 요청부서는 빈 값으로 남는다(04 정직 보고 대상).
      }
    },

    fetchStaticColumns: async divisionId => {
      // 시트별 2셋 — mount + 매 Search + Division 변경 시 refetch(CLAUDE.md §2 체크 3항).
      const division = divisionId ?? get().searchParams.divisionId;
      for (const sheet of [SHEETS.MAIN, SHEETS.SUB]) {
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId: division }
          );
          // 인터셉터가 500/403 도 resolve 한다 — 실패 응답을 "컬럼 0건" 으로 흡수하지 않는다.
          if (res.status >= 400 || Number(res.data.code)) continue;
          const next = res.data.result ?? [];
          if (next.length > 0) {
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          }
        } catch {
          // 미등록/조회 실패 = 빈 배열 유지(console 금지). 그리드 공백으로 드러난다.
        }
      }
      // item4(사용자 지시 2026-10-07): 저장된 조회조건 복원(최초 1회). F6 personalizeCondition 저장은
      //   되나 복원 경로가 없어 재진입 시 사라지던 것 보완(SCP0028/SCP0001 동형). 다중선택
      //   (fromSiteIds/toSiteIds)은 저장 시 콤마 join 되므로(gridAction personalizeCondition) 배열로
      //   되돌린다. 직접 set 이라 division cascade 미발동(복원값 그대로). 복원 divisionId 는 Form 의
      //   '첫 권한 division' 기본(!divisionId 조건)보다 우선한다. 실패 시 무시(명시 Search 전 조회 안 나감).
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
            set(state => {
              state.searchParams = { ...get().searchParams, ...restored };
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

    fetchDayRange: async fromDate => {
      // PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — IN fromDate/offsetDay/timeZone, OUT o_rc1 1행 1열
      //   "YYYYMMDD:YYYYMMDD". SCM_SYS_CALENDAR_M 기준이라 dayjs 근사로는 경계가 어긋난다.
      //   timeZone: TO-BE UserSession 에 타임존 필드가 없다 — 빈 값으로 보내 SP 기본 처리에 맡긴다.
      //   (AS-IS 는 클라 타임존을 명시 전달했다. 차이는 04 확인필요로 남긴다.)
      try {
        const res = await apiClient.post<Record<string, Record<string, string>[]>>(
          `/${MENU_ID}/${SHEETS.MAIN}/${BTN_DAY_PERIOD}/call-proc`,
          {
            fromDate,
            offsetDay: PERIOD_OFFSET_DAY,
            timeZone: '',
          }
        );
        if (res.status >= 400 || Number(res.data.code)) return;
        const first = res.data.result?.o_rc1?.[0];
        const raw = first ? String(Object.values(first)[0] ?? '') : '';
        const [from, to] = raw.split(':');
        if (!from || !to) return;
        set(state => {
          state.searchParams.fromYyyymmdd = from;
          state.searchParams.toYyyymmdd = to;
        });
      } catch {
        // SP/권한 미배포 시 기간 기본값 없음 — 사용자가 직접 지정한다. 클라 근사로 대체하지 않는다.
      }
    },
  }),
  'shipment-change-request-plan-store'
);
