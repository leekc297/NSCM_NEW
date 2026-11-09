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

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색 (forecast-price(DMF0082) 선례 1:1). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
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
  // ColumnLayoutModal OK 결과 보관 (null = 미설정) — 표시/순서 + 폭/색.
  //   모달 재진입 복원 + fetchStaticColumns 재조회 시 override 재적용에 사용.
  userColumnLayout: ColumnLayoutSetting[] | null;
  // ⭐ 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 덮이므로 별도 스냅샷이 필요하다 (forecast-price 선례).
  originalStaticColumns: StaticColumnsBySheet;
  dayRangeApplied: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  // ⭐ 화면 진입 시 저장된 개인화(SCM_MST_TITLESET_USER) 복원 — userColumnLayout 세팅.
  //   반환값 = 복원된 개인화(없으면 null). fetchStaticColumns 가 await 후 override 적용.
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  clearUserColumnLayout: () => void;
  fetchSearchConditions: () => Promise<void>;
  // main query 응답의 O_RC2/O_RC3 보관 (cutoff 산출용).
  setCalendarInfo: (bucketInfo: BucketInfo | null, currentWeekInfo: CurrentWeekInfo | null) => void;
  // ⭐ P1-③ — W/S Planner 여부 반영 (CMBO 응답). true 시 asYn 강제 + 체크박스 잠금.
  setWsPlannerYn: (yn: boolean) => void;
  // ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영.
  applyColumnLayout: (
    sheetName: keyof StaticColumnsBySheet,
    settings: ColumnLayoutSetting[]
  ) => void;
  // ⭐ #3 — MeasureSelectModal onSave — 표시할 measure 코드 목록 적용 (null = 전체).
  applyVisibleMeasures: (
    sheetName: keyof VisibleMeasuresBySheet,
    measureCodes: string[] | null
  ) => void;
  applyDayRange: (range: string | undefined) => void;
}

const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
// Period 조회조건 초기값 — dayRange(PR_GET_DAY_RANGE) 응답 도착 전까지의 자리값.
//   Div/Team 변경 시에는 리셋하지 않는다 (2026-08-20 사용자 결정 — 사용자가 지정한 기간 유지).
const MKT_FCST_INIT_PERIOD = {
  start: yyyymmdd(new Date()),
  end: yyyymmdd(new Date(Date.now() + 180 * 24 * 3600 * 1000)),
};
const { start: today, end: sixMonthsAhead } = MKT_FCST_INIT_PERIOD;

const initSearch: SearchCondition = {
  // 빈 값으로 시작 — 화면(MktFcst.tsx)의 division 자동선택 effect 가 세션/콤보 데이터로 채운다
  // (DMF0040/DMF0053 정본과 동일).
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  bizTypes: [],
  senderCodes: [],
  startYyyymmdd: today,
  endYyyymmdd: sixMonthsAhead,
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

// staticColumns / originalStaticColumns 는 각각 독립 객체여야 한다 (같은 참조를 공유하면
//   reset 이후 두 값이 얽힌다) — 매번 새로 만든다.
const makeEmptyCols = (): StaticColumnsBySheet =>
  Object.values(SHEETS).reduce((acc, k) => {
    (acc as Record<string, RawFlexGridColumnConfig[]>)[k] = [];
    return acc;
  }, {} as StaticColumnsBySheet);

const emptyCols: StaticColumnsBySheet = makeEmptyCols();

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
  userColumnLayout: null,
  originalStaticColumns: makeEmptyCols(),
  dayRangeApplied: false,
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다.
//   ⚠️ BE PR_GET_SHEET_COLUMN_LIST 는 SHEET_PRSL_YN 미등록 화면(DMF0003 실측)에 개인화를 반영하지
//     않으므로 titleSet 'C' 로 저장한 값을 FE 가 직접 얹는다 (forecast-price 선례 1:1).
//   ⚠️ DMF0003 은 MktFcstGrid 가 staticColumns 를 직접 merge 하며 표시 게이트가 `visible`
//     (MktFcstGrid.tsx `visibleColumns` 의 filter) — display 는 보지 않는다. 따라서 visible 을
//     양방향(선택 true / 미선택 false)으로 설정해야 실제로 컬럼이 사라진다.
//     display 도 함께 맞춰 공통 DataGrid(.filter(c => c.display)) 경로와도 정합.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      // 개인화 목록에 없는 컬럼 = 사용자가 비표시로 저장한 것.
      if (!s) return { ...c, visible: false, display: false };
      return {
        ...c,
        visible: s.visible,
        display: s.visible,
        colWth: s.width,
        cellColor: s.cellColor,
        textColor: s.textColor,
      };
    })
    .sort(
      (a, b) =>
        (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
        (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
    );
};

export const useMktFcstStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
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
            //   Division 82 는 체크박스와 무관하게 항상 'Y' 강제(사용자 요구).
            invalidExec: c.divisionId === DIVISION.ESS ? 'Y' : c.invalidYn ? 'Y' : 'N', // 17
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
        // ⭐ 진입 시 개인화 복원 — 저장된 TITLESET 을 먼저 조회해 override 를 확보한 뒤 메타에 적용.
        //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
        //   userColumnLayout 이 이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
        if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

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
            const fetched = responses[i].data.result ?? [];
            // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
            state.originalStaticColumns[s] = fetched;
            // 사용자 컬럼설정(OK) 이후 재조회(Search 등)가 선택을 덮지 않도록 override 재적용
            const layout = get().userColumnLayout;
            state.staticColumns[s] =
              layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
          });
        });
      } catch {
        // BE 메타 미등록 시 화면이 안 깨지도록 silent fallback — MAIN_COLUMNS 하드코딩 유지 (console 금지 룰)
      }
    },

    // ⭐ 저장된 개인화 복원 (진입 시 1회) — ColumnLayoutModal 이 쓰는 SP 와 동일 계약:
    //   DMF0002_GET_TITLESET_POPUP (sheetName='titleSet' 배선, columnType='C' = 컬럼 개인화).
    //   USER_FLAG='Y' 인 행 = 사용자가 표시로 저장한 컬럼. SORT_ORDER_NO 순으로 반환.
    //   저장 이력이 없으면(전 행 'N' 또는 0행) null → 서버 메타 기본값 그대로 사용.
    //   ⚠️ BE PR_GET_SHEET_COLUMN_LIST 는 SHEET_PRSL_YN 미등록 화면에 개인화를 반영하지 않으므로
    //     (DMF0003 미등록 실측) FE 가 직접 조회해 복원한다.
    //   ⚠️ COLUMN_WIDTH/CELL_COLOR/TEXT_COLOR 는 BE 확장(SCM_MST_TITLESET_USER 3컬럼)으로 내려오는
    //     사용자 값. 미지원/미저장이면 각각 기본 폭·빈 문자열로 떨어져 기존 동작과 동일하다.
    fetchUserColumnLayout: async () => {
      try {
        // URL = `${menuId}/${sheetName}/${action}/call-proc` (apiClient.callProc 규약, 앞 슬래시 없음).
        //   action='SEARCH' — SCM_ADM_MNU_BTN_MPG_M 의 titleSet 조회 매핑이 SEARCH (48_*_TitleSet_Meta.sql B3).
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: SHEETS.MAIN,
            columnType: 'C',
            divisionId: get().searchCondition.divisionId,
          }
        );
        const rows = res.data.result?.o_rc1 ?? [];
        // ⭐ 사용자 저장값 별칭 우선 — SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과
        //   사용자값(USER_COLUMN_WIDTH/USER_SORT_ORDER_NO)을 따로 내려준다(2026-07-27 실측).
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        const layout = rows
          .filter(r => String(r.USER_FLAG ?? '') === 'Y')
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map((r, i) => {
            const width = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
            return {
              colNm: String(r.COLUMN_NAME ?? ''),
              visible: true,
              width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
              cellColor: String(r.CELL_COLOR ?? ''),
              textColor: String(r.TEXT_COLOR ?? ''),
              order: i + 1,
            };
          })
          .filter(s => s.colNm);
        if (layout.length === 0) return null;
        set(state => {
          state.userColumnLayout = layout;
          // ⚠️ 이 조회는 fetchStaticColumns 와 독립 발사라 응답 순서가 보장되지 않는다.
          //   /column 이 먼저 도착했으면 그때는 userColumnLayout 이 없어 override 가 생략됐으므로
          //   여기서 이미 받아둔 컬럼에 소급 적용한다 (늦게 와도 개인화가 유실되지 않게).
          (Object.keys(state.staticColumns) as SHEETS[]).forEach(s => {
            const cur = state.staticColumns[s];
            if (cur && cur.length > 0) state.staticColumns[s] = applyLayoutToColumns(cur, layout);
          });
        });
        return layout;
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
        return null;
      }
    },
    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = null;
      }),
    // ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무)
    fetchStaticMeasures: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
              sheetNm, // = SHEETS.MAIN value('Mkt Fcst') 등록명 직접 사용 (corp handoff 42~45 정합)
              divisionId: get().searchCondition.divisionId,
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
    fetchSearchConditions: async () => {
      if (get().initialized) return;
      try {
        const res = await apiClient.get<{ paramNm: keyof SearchCondition; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length > 0) {
          // paramCtn 은 서버에서 항상 문자열. initSearch 의 필드 타입(배열/불리언/문자열)에 맞춰
          //   역직렬화 — 배열 필드가 문자열로 남으면 setFilter 의 j(arr) 가 깨지고, 불리언이 'false'
          //   문자열(truthy)로 남으면 체크박스/필터 로직이 오작동하므로 타입 복원이 필수.
          const restored: Partial<SearchCondition> = {};
          for (const { paramNm, paramCtn } of rows) {
            if (paramNm == null || !(paramNm in initSearch)) continue;
            const proto = (initSearch as unknown as Record<string, unknown>)[paramNm];
            if (Array.isArray(proto)) {
              // '["40","81"]'(JSON) / '40^81' / '40,40' / '' 모두 수용 → string[]
              const raw = String(paramCtn ?? '').trim();
              let arr: string[] = [];
              if (raw) {
                if (raw.startsWith('[')) {
                  try {
                    const parsed: unknown = JSON.parse(raw);
                    if (Array.isArray(parsed)) arr = parsed.map(v => String(v)).filter(Boolean);
                  } catch {
                    arr = [];
                  }
                } else {
                  arr = raw
                    .split(/[\^,]/)
                    .map(s => s.trim())
                    .filter(Boolean);
                }
              }
              (restored as Record<string, unknown>)[paramNm] = arr;
            } else if (typeof proto === 'boolean') {
              const raw = String(paramCtn ?? '')
                .trim()
                .toLowerCase();
              (restored as Record<string, unknown>)[paramNm] =
                raw === 'true' || raw === 'y' || raw === '1';
            } else {
              (restored as Record<string, unknown>)[paramNm] = paramCtn ?? '';
            }
          }
          set(state => {
            // 부분 병합 — 저장분에 없는 키는 initSearch 기본값 유지 (신규 키 유실 방지, metal-link-price 표준).
            state.searchCondition = { ...state.searchCondition, ...restored };
          });
        }
      } catch {
        // 저장 조건 미존재/미응답 = 기본값 유지 (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
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

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영 (서버 저장과 별개).
    //   결과는 userColumnLayout 으로 보관 → 모달 재진입 복원 + Search 재조회 후 재적용.
    //   서버 영구 저장은 MktFcst.saveTitleSet('C') 가 SCM0002_SET_TITLESET_POPUP 으로 수행(구현 완료).
    applyColumnLayout: (sheetName, settings) => {
      set(state => {
        // 표시 컬럼만 보관 — fetchStaticColumns 재조회 후 재적용 기준이자 팝업 재진입 복원값.
        const layout = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        state.userColumnLayout = layout;
        const cur = state.staticColumns[sheetName];
        if (!cur || cur.length === 0) return;
        state.staticColumns[sheetName] = applyLayoutToColumns(cur, layout);
      });
    },

    // ⭐ #3 — MeasureSelectModal OK — 표시할 measure 코드만 보관 (null = 전체 표시).
    applyVisibleMeasures: (sheetName, measureCodes) => {
      set(state => {
        state.visibleMeasures[sheetName] = measureCodes;
      });
    },

    applyDayRange: range => {
      if (!range || !/^\d{8}:\d{8}$/.test(range)) return;
      if (get().dayRangeApplied) return;
      const [start, end] = range.split(':');
      set(state => {
        state.searchCondition = {
          ...state.searchCondition,
          startYyyymmdd: start,
          endYyyymmdd: end,
        };
        state.dayRangeApplied = true;
      });
    },
  }),
  'mkt-fcst'
);
