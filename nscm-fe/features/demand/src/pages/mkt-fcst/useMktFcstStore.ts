import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './mkt-fcst.constants';
import type { SearchCondition } from './mkt-fcst.types';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
//   MAIN = DMF0003_GET_MKT_FCST_DATA / SPREAD_TITLE = DMF0003_GET_SPREAD_TITLE (동적 PIVOT 헤더)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
};

// ⭐ #3 — SCM_MST_SHEET_MEASURE 동적 fetch row 형태.
//   ⚠️ BE `/admin/menu/{mnuId}/measure`(MenuController.retrieveGridMeasures → GridMeasure DTO)는
//      Jackson default 직렬화로 *camelCase* 키를 반환한다(colNm/colLblNm/sClsLblNm/lClsLblNm/personalizable/display).
//      과거 UPPER_SNAKE(COLUMN_NAME 등) 가정은 전부 undefined → Measure 모달 그리드 컬럼/값 미표시 사고의 원인.
//   필드 매핑(SP PR_GET_SHEET_MEASURE_LIST OUT cursor → GridMeasure):
//     colNm          = COLUMN_NAME            (measure 코드)
//     colLblNm       = COLUMN_LABEL_NAME      (measure 표시명)
//     sClsLblNm      = SMALL_CLASS_LABEL_NAME (소분류, 예: MKT/RTF/CUST)
//     lClsLblNm      = LARGE_CLASS_LABEL_NAME (대분류, 현재 사내 데이터 공란)
//     personalizable = USER_SELECTABLE_FLAG='Y' (사용자 토글 허용 여부)
//     display        = DEFAULT_FLAG='Y'        (초기 표시 기본값 — SP 가 DEFAULT_FLAG AS DISPLAY_FLAG 반환)
//   SP 가 이미 VALID_YN='Y' 필터 + SORT_ORDER_NO ORDER BY 처리 → FE 는 별도 정렬/필터 불필요.
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
}

// ⭐ DMF0003_GET_MKT_FCST_DATA O_RC2 — "7주 후 주"(SYSDATE+49d) SCM_SYS_CALENDAR_M 단일 row.
//   BASIS_YYYYMM = Division 40 Monthly 8주차 잠금 cutoff 월 (보강스펙 §5, SP L4277~4283).
export interface BucketInfo {
  BASIS_YYYYMMDD?: string;
  BASIS_YYYYMM?: string;
  ISO_YYYYWW?: string;
  ISO_WEEK?: string;
}

// ⭐ DMF0003_GET_MKT_FCST_DATA O_RC3 — 현재/전주 주차 정보 (SP L4290~4302).
//   THIS_YYYYMM('M_'+yyyymm) / THIS_YYYYMMWW('W_'+yyyymm+ISO_WEEK) = 현재 월/주 binding.
export interface CurrentWeekInfo {
  THIS_YYYYMM?: string;
  THIS_YYYYMMWW?: string;
  PRE_YYYYMM?: string;
  PRE_YYYYMMWW?: string;
  BASIS_YYYYMM?: string;
  ISO_WEEK?: string;
}

type StaticColumnsBySheet = { [key in SHEETS]: RawFlexGridColumnConfig[] };
type StaticMeasuresBySheet = { [key in SHEETS]: MeasureMeta[] };
// ⭐ #3 — 사용자가 MeasureSelectModal 에서 선택한 표시 measure 코드 목록(sheet 별).
//   null = 미설정(전체 표시). string[] = 선택된 measure 코드만 그리드 표시.
type VisibleMeasuresBySheet = { [key in SHEETS]: string[] | null };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  // ⭐ #3 — MeasureSelectModal 선택 measure(표시 대상). null = 전체 표시.
  visibleMeasures: VisibleMeasuresBySheet;
  // ⭐ Phase 2b — main query O_RC2(8주 bucket) / O_RC3(현재 주차) 보관 (편집 cutoff 산출 입력).
  bucketInfo: BucketInfo | null;
  currentWeekInfo: CurrentWeekInfo | null;
  // ⭐ P1-③ — 로그인 사용자 W/S Planner 그룹 소속 여부 (CMBO MktFcstWsPlannerYn 실측).
  //   AS-IS L1679: NowGroupID=='DM Planner (W/S)' → p_as_yn 'Y' 강제. TO-BE 는 세션 groupId 부재로
  //   USER_ID→그룹 소속(SCM_ADM_USER_GR_MPG_M) 실측값을 사용. true = AS 강제(체크박스 잠금).
  wsPlannerYn: boolean;
  // ⭐ [E20260402-001736] GET_SPREAD_TITLE p_type — 'LOAD' = 첫 진입/Division 변경 직후 첫 조회
  //   (SP 가 DM Planner·W/S 에 AS_FROM_SITE 컬럼 자동추가), 이후 조회는 'COLUMN'.
  //   AS-IS InitSpread(sType) 호출부 5곳 1:1: CreateSpread·Division 변경='LOAD' / 조회·컬럼/메저 팝업=''.
  spreadTitleLoadPending: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  // main query 응답의 O_RC2/O_RC3 보관 (cutoff 산출용).
  setCalendarInfo: (bucketInfo: BucketInfo | null, currentWeekInfo: CurrentWeekInfo | null) => void;
  // ⭐ P1-③ — W/S Planner 여부 반영 (CMBO 응답). true 시 asYn 강제 + 체크박스 잠금.
  setWsPlannerYn: (yn: boolean) => void;
  // ColumnSettingModal onSave — 사용자 선택 column 만 visible='Y', 나머지 'N'.
  applyColumnVisibility: (sheetName: keyof StaticColumnsBySheet, visibleKeys: string[]) => void;
  // ⭐ #3 — MeasureSelectModal onSave — 표시할 measure 코드 목록 적용 (null = 전체).
  applyVisibleMeasures: (sheetName: keyof VisibleMeasuresBySheet, measureCodes: string[] | null) => void;
}

// ⭐ 2026-07-23 조회조건 AS-IS 정합(전건 보완) — Period 기본값 = AS-IS PR_GET_DAY_RANGE(p_month=6) 1:1:
//   "해당 월 1일 ~ (+6개월 시점 월의 1일 - 1일)" (예: 07-23 → 0701~1231).
//   구현: 클라 달력 계산 (SP 재호출 불요 — 결정적). ⚠ toISOString 은 UTC 라 KST 자정 부근 하루 밀림 → 로컬 포맷.
const yyyymmddLocal = (d: Date) =>
  `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
const now = new Date();
const periodStart = yyyymmddLocal(new Date(now.getFullYear(), now.getMonth(), 1)); // 해당 월 1일
const periodEnd = yyyymmddLocal(new Date(now.getFullYear(), now.getMonth() + 6, 0)); // +6개월 구간 마지막 날

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  bizTypes: [],
  senderCodes: [],
  startYyyymmdd: periodStart,
  endYyyymmdd: periodEnd,
  bucketType: BUCKET_TYPE.WEEKLY, // 조회조건 Bucket 초기값 = Weekly (사용자 지정 2026-06-29)
  projectCodes: [],
  itemIds: [],
  nickName: '',
  plantSiteIds: [],
  itemTypes: [],
  owners: [],
  sumYn: false,
  // (Color 체크박스 제거 — 2026-07-03 사용자 결정. AS-IS 실행 UI 미표시·초기 false → 고정 false 경로
  //  = 과거 Gray 없음 + 현재 주/월 헤더 초록 강조. MktFcstGrid formatItem 에 고정 반영.)
  qtyOverZero: false,
  cellQtyYn: false,
  // ⭐ Invalid(MKT FCST 미등록 제외) — AS-IS checkInvalidExec 1:1 (.cs L469~477): Div82 전용,
  //   82 선택 시 기본 checked(true). 초기 division=40 이므로 false.
  invalidYn: false,
  asYn: false,
};

const emptyCols: StaticColumnsBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, RawFlexGridColumnConfig[]>)[k] = [];
  return acc;
}, {} as StaticColumnsBySheet);

const emptyMeasures: StaticMeasuresBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, MeasureMeta[]>)[k] = [];
  return acc;
}, {} as StaticMeasuresBySheet);

const emptyVisibleMeasures: VisibleMeasuresBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, string[] | null>)[k] = null;
  return acc;
}, {} as VisibleMeasuresBySheet);

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: emptyCols,
  staticMeasures: emptyMeasures,
  visibleMeasures: emptyVisibleMeasures,
  bucketInfo: null,
  currentWeekInfo: null,
  wsPlannerYn: false,
  spreadTitleLoadPending: true,
};

export const useMktFcstStore = createPersistedStoreWithTab<State & Action>((set, get) => ({
  ...initState,
  reset: () => set(initState),
  setSearchCondition: p =>
    set(state => {
      // ⭐ [E20260402-001736] Division 변경 = AS-IS cboDivision_SelectedIndexChanged 의 InitSpread("LOAD")
      //   대응 — 다음 조회의 GET_SPREAD_TITLE p_type 을 'LOAD' 로 (AS_FROM_SITE 자동추가 분기 재실행).
      if (p.divisionId !== undefined && p.divisionId !== get().searchCondition.divisionId) {
        state.spreadTitleLoadPending = true;
      }
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
  setFilter: () => {
    // BE makeProcedure (BaseService.java) 가 SCM_ADM_PROC_M.COL_NM 기준 positional 매핑.
    //   누락/이름불일치 시 BE 가 NULL 전달 → 권한 V_GROUP_ID 매칭 실패 → 0 row.
    //   ⭐ 키명 = DMF0003_GET_MKT_FCST_DATA / _GET_SPREAD_TITLE PROC_M COL_NM (ora.py 실측, camelCase).
    //   createdBy / sesUserId / mnuId 는 BE 세션·메뉴 컨텍스트 자동 채움 (보강 전송).
    //   ⚠️ userGroup 은 BE 자동 채움 대상이 아님 (2026-07-02 사고 — '' 전송 시 SP GET_ADMIN_GROUP
    //   판정(SEGMENT1 = P_USER_GROUP, 019 SP L279) 실패 → EDIT_FLAG 전행 'N' → 편집 Yellow 0).
    //   AS-IS L1268 p_user_group = UserInfoContext["NowGroupID"] (로그인 시 선택한 단일 그룹).
    //   To-Be 는 그룹 선택 개념/세션 groupId 미구현(BE UserSession 실측: userId/userNm/langCd/menus 만)
    //   → fallback = USER_ID 전달. 클라우드 lookup GET_ADMIN_GROUP 에 USER_ID row 운영 등록됨
    //   (실측 2026-07-02: SEGMENT1='minyonglee1'/ALL/Y). 신규 사용자 온보딩 시 lookup 에
    //   USER_ID row 추가 필요 (감사 보고서 참조). BE groupId 제공 시 자동 우선 사용.
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    const userGroup = useSessionStore.getState().session.groupId || sesUserId;
    set(state => {
      // ⭐ persist(sessionStorage) 로 rehydrate 된 searchCondition 이 구버전 shape 라 일부 필드(배열/division)
      //   가 누락(undefined)될 수 있음 → initSearch 기본값 머지로 항상 완전한 조회조건 보장.
      //   (누락 시 j(undefined) 예외 → setFilter 중단 → stale filters 재사용 → SP NULL payload → ORA-00936 사고 차단)
      const c: SearchCondition = { ...initSearch, ...state.searchCondition };
      // 멀티선택(^delim). 빈/미정의 배열 = 'ALL' (AS-IS 전체 조회 sentinel).
      const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join('^'));
      state.filters = {
        // ── DMF0003_GET_MKT_FCST_DATA (22 IN, PROC_M SORT_ORD 순) ──────────────
        [SHEETS.MAIN]: {
          divisionId: c.divisionId, // 1
          scmSiteId: j(c.scmSiteIds), // 2  Sales Site
          plantSiteId: j(c.plantSiteIds), // 3
          teamId: j(c.deptIds), // 4  Team
          customer: j(c.endCustomers), // 5  End Customer
          bizType: j(c.bizTypes), // 6
          projectCode: j(c.projectCodes), // 7
          itemId: j(c.itemIds), // 8
          fromYyyymmdd: c.startYyyymmdd, // 9
          toYyyymmdd: c.endYyyymmdd, // 10
          createdBy: sesUserId, // 11 BE 자동(보강 전송)
          userGroup, // 12 세션 groupId (AS-IS NowGroupID 1:1 — '' 시 EDIT_FLAG 전행 'N' 사고)
          itemType: j(c.itemTypes), // 13
          owner: j(c.owners), // 14
          qtyYn: c.qtyOverZero ? 'Y' : 'N', // 15 Qty ≥ 0 (⚠ SP 실측: 선언만 있고 미사용 — AS-IS 변환 1:1 산출물도 동일. 전달만 유지)
          cellYn: c.cellQtyYn ? 'Y' : 'N', // 16 Cell Qty — Div40, QTY×FORECAST_INFO_CELL_PACK_COUNT 환산 (SP L3701 실측)
          // ⭐ 2026-07-03 오배선 교정: invalidExec 는 별도 체크박스(Invalid — AS-IS checkInvalidExec,
          //   'MKT FCST 미등록 제외', Div82 전용 기본 checked). qtyOverZero 연동은 잘못 — 실측 div82
          //   Y=175행 vs N=1,165행 (극적 차이 — Sales Price 미등록 조합 제외 필터).
          invalidExec: c.invalidYn ? 'Y' : 'N', // 17
          // ⭐ P1-③ — AS-IS L1679: W/S Planner 그룹이면 asYn 'Y' 강제(체크박스 무관). 그 외 체크박스 값.
          asYn: c.asYn || get().wsPlannerYn ? 'Y' : 'N', // 18
          userDeptId: '', // 19 BE 세션 부서 자동
          senderCode: j(c.senderCodes), // 20
          sesUserId, // 21 BE 자동
          mnuId: MENU_ID, // 22 BE 자동
        },
        // ── DMF0003_GET_SPREAD_TITLE (6 IN) — 동적 PIVOT 기간 헤더 ──────────────
        //   ⭐ [E20260402-001736] type: 첫 진입/Division 변경 후 첫 조회 = 'LOAD'
        //   (SP 가 DM Planner·W/S 권한에 AS_FROM_SITE 컬럼 자동추가 — standalone SP L28~48 실측),
        //   이후 조회 = 'COLUMN' (기존 컬럼 메타 유지).
        [SHEETS.SPREAD_TITLE]: {
          startYyyymmdd: c.startYyyymmdd,
          endYyyymmdd: c.endYyyymmdd,
          createdBy: sesUserId, // BE 자동(보강 전송)
          divisionId: c.divisionId,
          userGroup, // 세션 groupId (AS-IS NowGroupID 1:1)
          type: state.spreadTitleLoadPending ? 'LOAD' : 'COLUMN',
        },
      };
      state.spreadTitleLoadPending = false;
    });
  },
  // mount 시 sessionStorage 의 이전 filters cache 무효화 — incomplete payload 재사용 회피.
  clearFilters: () =>
    set(state => {
      state.filters = {};
    }),
  setOpenSearchArea: open =>
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),

  // ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch
  //   SCM_MST_SHEET_COLUMNS 의 admin 변경 즉시 반영 (mount + Search 시 호출). 하드코딩 금지.
  fetchStaticColumns: async () => {
    try {
      const sheets: SHEETS[] = [SHEETS.MAIN];
      const responses = await Promise.all(
        sheets.map(sheetNm =>
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm, // = SHEETS.MAIN value('Mkt Fcst') 등록명 직접 사용 (corp handoff 42~45 정합)
            divisionId: get().searchCondition.divisionId,
          })
        )
      );
      set(state => {
        sheets.forEach((s, i) => {
          state.staticColumns[s] = responses[i].data.result ?? [];
        });
      });
    } catch {
      // BE 메타 미등록 시 화면이 안 깨지도록 silent fallback — MAIN_COLUMNS 하드코딩 유지 (console 금지 룰)
    }
  },

  // ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무)
  fetchStaticMeasures: async () => {
    try {
      const sheets: SHEETS[] = [SHEETS.MAIN];
      const responses = await Promise.all(
        sheets.map(sheetNm =>
          apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
            sheetNm, // = SHEETS.MAIN value('Mkt Fcst') 등록명 직접 사용 (corp handoff 42~45 정합)
          })
        )
      );
      set(state => {
        sheets.forEach((s, i) => {
          state.staticMeasures[s] = responses[i].data.result ?? [];
        });
      });
    } catch {
      // silent fallback (console 금지 룰) — MEASURE_FALLBACK hardcode fallback
    }
  },

  // ⭐ Phase 2b — main query O_RC2/O_RC3 보관. 편집 cutoff(현재월/주, Div40 8주 잠금 월) 산출 입력.
  setCalendarInfo: (bucketInfo, currentWeekInfo) =>
    set(state => {
      state.bucketInfo = bucketInfo;
      state.currentWeekInfo = currentWeekInfo;
    }),

  // ⭐ P1-③ — W/S Planner 여부 반영 (AS-IS L1679). W/S Planner 이면 asYn 강제 checked
  //   (구 cboAS.Checked=true·Enabled=false 이식). 조회/저장 payload 가 sc.asYn 을 공유하므로
  //   searchCondition.asYn 자체를 true 로 고정한다.
  setWsPlannerYn: yn =>
    set(state => {
      state.wsPlannerYn = yn;
      if (yn) state.searchCondition.asYn = true;
    }),

  // ColumnSettingModal OK — 사용자 선택 column 만 visible (visible='Y'), 나머지 'N'.
  //   서버 영구 저장은 MktFcst.saveTitleSet('C') 가 SCM0002_SET_TITLESET_POPUP 으로 수행(구현 완료).
  applyColumnVisibility: (sheetName, visibleKeys) => {
    set(state => {
      const cur = state.staticColumns[sheetName];
      if (!cur || cur.length === 0) return;
      const visibleSet = new Set(visibleKeys);
      state.staticColumns[sheetName] = cur.map(c => ({
        ...c,
        visible: visibleSet.has(c.colNm),
      }));
    });
  },

  // ⭐ #3 — MeasureSelectModal OK — 표시할 measure 코드만 보관 (null = 전체 표시).
  applyVisibleMeasures: (sheetName, measureCodes) => {
    set(state => {
      state.visibleMeasures[sheetName] = measureCodes;
    });
  },
}), 'mkt-fcst');
