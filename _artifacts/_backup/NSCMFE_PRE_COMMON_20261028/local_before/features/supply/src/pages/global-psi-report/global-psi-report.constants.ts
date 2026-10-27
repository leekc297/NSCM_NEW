export const MENU_ID = 'SCP0100' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL/Report/SCP0100_Global_PSI_Report (2,056줄) — read-only Global PSI 조회 리포트.
//   저장/입력 없음(INSERT/DELETE/SAVE/UPLOAD/MANUAL 미배선). 툴바 override = FindButton/ExcelButton 2종.
//   설계 근거: .atlas/gscm-design/SCP0100/design/00_checklist.md ~ 03_grid-columns.md (DB 실측 PASS).
//   - 메인 GET   : PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT (17 IN + O_RC1 + O_RESULT_CURSOR)
//                  dispatcher: MONTHLY -> _MM_DATAONLY / WEEKLY -> _WW_DATAONLY (design 03 §4.2)
//   - Site       : PKG_SCP0100.P_SCP0100_GET_SITE (IN P_SITE_TPYE, P_DIVISION_ID, P_BUCKET / O_RC1)
//   - Plan Date  : PKG_SCP0100.P_SCP0100_GET_PLAN_DATE (IN P_DIVISION_ID, P_BUCKET, P_PROGRAM_ID / O_RC1)
//   - Calendar   : PKG_SCP0100.GET_SHEET_CALENDAR_3SPAN (IN P_START_YYYYMMDD, P_END_YYYYMMDD / O_RC1)
//   SP 배포 완료(PKG_SCP0100 PACKAGE + BODY VALID, ora.py 2026-09-24). 메뉴 1행 등록(design 02 부록 B-6).
export enum SHEETS {
  // 3개 FpSpread 가 SearchLevel 상태로 상호 show/hide (design 01 §2 R1~R3). Panel2 오버레이 -> sheet 스위칭.
  REPORT = 'report', // spdDetail — Main REPORT 그리드 (고정 15열 + 동적 M_/W_ 기간칼럼)
  SEARCH_LEVEL = 'searchLevel', // spdSearchLevel — SearchLevel 집계 뷰 (고정 9열 + 동적 pivot)
  SEARCH_LEVEL_DETAIL = 'searchLevelDetail', // spdSearchLevelDetail — CELL_GROUP_DETAIL 집계 뷰 (9열 + pivot)
}

// 조회조건 콤보 원천 보조 SP 시트 — SCM_ADM_CMBO_SQL_M 미등록(콤보 SQL 아님)이라 useTabProcQuery(SEARCH)로
//   호출한다(design 02 §5.2 "useTabProcQuery(SP, sheet 별도)"). SHEETS(그리드 3시트)와 별개 네임스페이스 —
//   ADMIN_SHEET_NAME/StaticColumns/filters 대상 아님. 05_register.sql 에 API_M+MNU_BTN(SEARCH)+권한 등록(Task#5).
//   반환 커서는 표준 O_RC1(부록 B-3). setListBox(..., "CODE","NAME") 로 CODE/NAME 컬럼 명시(design 02 §2.2·§2.3).
export const AUX_SHEET = {
  SITE: 'site', // P_SCP0100_GET_SITE (IN P_SITE_TPYE, P_DIVISION_ID, P_BUCKET). From/To 공용 — p_site_tpye 로 분기
  PLAN_DATE: 'planDate', // P_SCP0100_GET_PLAN_DATE (IN P_DIVISION_ID, P_BUCKET, P_PROGRAM_ID='SCP0100')
  CALENDAR: 'calendar', // GET_SHEET_CALENDAR_3SPAN (IN P_START_YYYYMMDD, P_END_YYYYMMDD). 동적 pivot 기간칼럼 3단 헤더 원천
} as const;
export type AuxSheet = (typeof AUX_SHEET)[keyof typeof AUX_SHEET];

// P_SCP0100_GET_PLAN_DATE 의 IN P_PROGRAM_ID 고정값(design 02 §2.3 cs:1357 GetPlanDate p_program_id="SCP0100").
export const PLAN_DATE_PROGRAM_ID = MENU_ID;

// NSCM 단일 cursor 표준. GET SP 는 O_RC1(PIVOT 데이터) + O_RESULT_CURSOR(상태봉투) 반환 —
//   O_RC1 을 그리드로 바인딩(hook#80 cursor 이름 매핑). 표준 response key 'o_rc1'.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup 시트명 — SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0100') sheetNm 3종 실측
//   (design 03 §1 REPORT 15 / SEARCH_LEVEL 9 / SEARCH_LEVEL_DETAIL 9). admin 등록본이 authoritative
//   (fetchStaticColumns). 미등록 시 빈 배열(하드코딩 fallback 없음).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.REPORT]: 'REPORT',
  [SHEETS.SEARCH_LEVEL]: 'SEARCH_LEVEL',
  [SHEETS.SEARCH_LEVEL_DETAIL]: 'SEARCH_LEVEL_DETAIL',
};

// SCM_MST_SHEET_MEASURE 등록 시트명 — measure 36행 메타(design 03 §1 실측).
//   주의(design 03 §6.2): 메인 데이터 SP 는 p_sheet_name='Global PSI Report' 지만 SHEET_MEASURE 는
//   'Global PSI New' 로 표기가 다르다. measure fetch 는 SHEET_MEASURE 실측 sheetNm 을 정본으로 쓴다.
export const MEASURE_SHEET_NAME = 'Global PSI New';

// 조회조건 콤보 SQL_ID — SCM_ADM_CMBO_SQL_M 등록 실측(design 02 부록 B-1). USE_YN='Y'.
export const COMBO = {
  // cboDivision — 권한 division. Division_SCP 는 공유 콤보(SCP0100 전용 WHERE 없음, 부록 B-1).
  //   AS-IS BLUtils.GetDivisionWithoutEE + DBUtils.Filter(CODE<>'40')(CODE<>'82') = EE/40/82 3중 제외.
  //   공유 SQL 수정 금지 -> 3중 제외는 FE 후처리(DIVISION_EXCLUDE)로 재현(design 02 §2.7).
  DIVISION: 'Division_SCP',
} as const;

// 조회기간 종료일(HORIZON_END_DATE) 산출 콤보 — AS-IS GetPlanEndDate(cs:2029~2050) =
//   Data_REPORT.CallBizCommonData(PLAN_END_DATE, false, "81", _plan_start_yyyymmdd, "WEEKLY").
//   DB 실측 SQL(SCM_ADM_CMBO_SQL_M.SQL_ID='PLAN_END_DATE_REPORT', ora.py 2026-10-14):
//     SELECT HORIZON_END_DATE FROM SCM_MST_PLAN WHERE DIVISION_ID=@divisionId AND PLAN_NAME=@planName
//     AND PLAN_CYCLE=@planCycle (ROWNUM<=1). 바인드 @divisionId/@planName/@planCycle.
export const PLAN_END_DATE_COMBO_ID = 'PLAN_END_DATE_REPORT';
export const PLAN_END_DATE_DIVISION = '81'; // AS-IS 하드코딩(cs:2038) — 선택 division 아님
export const PLAN_END_DATE_PLAN_CYCLE = 'WEEKLY'; // AS-IS 하드코딩(cs:2040)
export const PLAN_END_DATE_COL = 'HORIZON_END_DATE';

// EE division 제외 필터값 (SCM_MST_DIVISION.ATTRIBUTE3='EE' — 전극 6종, 부록 B-2). FE 후처리 대상.
export const DIVISION_EE_EXCLUDE = 'EE';
// 완제품 division 제외 코드 (부록 B-2): 40=Mobility & IT Battery, 82=ESS Battery. 셀 단위 division 만 남김.
export const DIVISION_EXCLUDE_CODES = ['40', '82'] as const;

// Division "ALL"(전체) 센티넬 — AS-IS clbDivision 은 멀티 CheckedList 로 setListBox(dtMyDivision,clbDivision,true)
//   가 맨 앞 전체선택 항목을 추가하고 기본선택한다(cs:586). getDivision() 은 전체선택이면 "" 로 정규화해
//   SP 에 넘긴다(cs:468) → 메인 SP 의 TRIM(P_DIVISION_ID) IS NULL 분기(전체 division)로 조회된다(ora.py 실측).
export const DIVISION_ALL = 'ALL';
// Division 값 → SP 파라미터 정규화: ALL/빈값이면 '' (전체), 특정 division 이면 그 CODE.
export const normalizeDivision = (v: string): string => (v && v !== DIVISION_ALL ? v : '');

// lookup TYPE (SCM_ADM_LOOKUP_MASTER_DETAIL — design 02 부록 B-4). useTabLookupQueries 로 조회.
//   반환은 소스 index 가 아니라 code(SEGMENT1) 기반, VALID_YN='Y' + DISPLAY_SEQ 순.
export const LOOKUP = {
  DISPLAY: 'STOCK_TREND_DISPLAY', // ALL(All) / CHART(Chart) / GRID(Grid) — 3종 VALID
  SEARCH_LEVEL: 'PRODUCT_LEVEL', // CELL_GROUP / CELL_GROUP_DETAIL / PRODUCT_LEVEL1..3 — 5종 VALID
  PLAN_TYPE: 'PLAN_TYPE', // PR/MA/SE/FN/TE — 5종 VALID, 기본 FN='Final Plan'
  // Bucket — AS-IS GetBucketType("CODE='DAILY'")(cs:603) = DM0003_GET_BUCKET_TYPE_CODE SP =
  //   lookup BUCKET_TYPE_CODE(VALID_YN='Y')에서 DAILY 행 제거. DB 실측(ora.py 2026-10-14):
  //   DAILY(seq1)/WEEKLY(seq2)/MONTHLY(seq3) → DAILY 제외 후 DISPLAY_SEQ 순 [Weekly, Monthly].
  BUCKET: 'BUCKET_TYPE_CODE',
} as const;

// lookup code 상수 — 화면 로직 분기용(부록 B-4 실측 code).
export const DISPLAY_CODE = {
  ALL: 'ALL', // All (Grid + Chart)
  CHART: 'CHART', // Only Chart
  GRID: 'GRID', // Only Grid — 화면 기본(design 01 D4 cboDisplay.SelectedIndex=2)
} as const;

export const SEARCH_LEVEL_CODE = {
  CELL_GROUP: 'CELL_GROUP', // idx0 기본 — SearchLevel 그리드
  CELL_GROUP_DETAIL: 'CELL_GROUP_DETAIL', // SearchLevelDetail 그리드 분기 키(design 01 R2)
  PRODUCT_LEVEL1: 'PRODUCT_LEVEL1',
  PRODUCT_LEVEL2: 'PRODUCT_LEVEL2',
  PRODUCT_LEVEL3: 'PRODUCT_LEVEL3',
} as const;

// PlanType 기본값 — AS-IS InitControlsAfter cboPlanType.SelectedValue="FN"(design 02 §4.2 cs:628).
export const PLAN_TYPE_DEFAULT = 'FN';

// BucketType — AS-IS 콤보 목록은 CODE='DAILY' 필터 로드하나 선택 기본은 Monthly(design 02 §4.2 cs:606).
//   Monthly/Weekly 토글이 M_/W_ pivot 컬럼 visible 을 전환(design 03 §2.5). 정적 select(BucketField 등가).
export const BUCKET_CODE = {
  MONTHLY: 'MONTHLY', // 기본 — M_ 컬럼 visible
  WEEKLY: 'WEEKLY', // W_ 컬럼 visible
  DAILY: 'DAILY',
} as const;
export const BUCKET_DEFAULT = BUCKET_CODE.MONTHLY;

// searchMode 라디오 (rgrpSearchLevel) — idx0='Search Level' / idx1='Detail'(design 01 §2 R).
export const SEARCH_MODE = {
  SEARCH: 'SEARCH', // rgrpSearchLevel.SelectedIndex=0 기본
  DETAIL: 'DETAIL', // rgrpSearchLevel.SelectedIndex=1 — spdDetail show, SearchLevel 콤보 disable(R4)
} as const;
export type SearchMode = (typeof SEARCH_MODE)[keyof typeof SEARCH_MODE];

// rgrpSearchLevel 대응 — AS-IS 라디오그룹 원형 그대로 공용 @shared/lges RadioGroup/Radio 로 재현(design 01 §2 R1/R4).
//   value = SEARCH_MODE. idx0 Search Level(기본) / idx1 Detail(REPORT 시트 show, SearchLevel 콤보 disable R4).
export const SEARCH_MODE_OPTIONS = [
  { label: 'Search Level', value: SEARCH_MODE.SEARCH },
  { label: 'Detail', value: SEARCH_MODE.DETAIL },
] as const;

// 컬럼/measure 개인화 titleSet columnType — SalesPlan(DMF0021) 선례 동일('C'/'M'). saveTitleSet 3점 일치
//   (menuId/sheetName/columnType) 중 columnType 축. 조회·저장·복원이 반드시 같은 값을 써야 재진입 복원된다.
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// Unit(Qty) 로컬 표시배율 — 서버 재조회 없이 그리드 값 클라 나눗셈(design 02 §2.5 cs:1697-1714).
//   index 0=1 / 1=1e3 / 2=1e6 / 3=1e8. 기본 index0(배율 1).
export const UNIT_QTY_SCALE = [1, 1_000, 1_000_000, 100_000_000] as const;

// Site SP 파라미터 p_site_tpye 값 (design 02 §2.2 / 부록 B-3). 인자명 오타 P_SITE_TPYE 그대로 배포됨.
export const SITE_TYPE = {
  FROM: 'FROM_SITE',
  TO: 'TO_SITE',
} as const;

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114). AS-IS 리터럴 문구를 그대로 쓰지 않는다.
//   {0} 자리표시자는 i18next 자동치환 안 함 — 호출부에서 .replace 로 넣는다.
export const MSG = {
  // dStart>dPlan 검증 문구는 AS-IS 가 카탈로그 미사용 한국어 하드코딩(cs:2014)이라 TO-BE 도 호출부
  //   (GlobalPsiReport.tsx)에서 AS-IS 원문 그대로 하드코딩 — MSG 상수 미사용(2026-10-19 사용자 지시).
  // 권한 Division 0건 (design 01 A1 cs:583). AS-IS MSG00097 "권한을 가진 Division이 없습니다".
  //   SCP0100 은 권한조인 2행 등록으로 실발동 안 함(부록 B-6)이나 A1 규칙 재현을 위해 코드 보존.
  NO_DIVISION_AUTH: 'MSG00097',
} as const;

// i18n 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 LBL ID(design 02 부록 B-5). t(LBL.KEY, '_Fallback').
//   값 = LBL 코드. DB 미매칭 라벨(Item ID / Search Mode)은 코드 미할당 — 호출부에서 리터럴 유지.
export const LBL = {
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  DIVISION: 'LBL00001', // Div. — 조회조건 Division 표준 코드(shipment-working-day 선례 동일)
  FROM_SITE: 'LBL00022', // From Site
  TO_SITE: 'LBL00023', // To Site
  PLAN_DATE: 'LBL00039', // Plan Date
  BUCKET: 'LBL00710', // Bucket
  DISPLAY: 'LBL01073', // Display
  SEARCH_LEVEL: 'LBL00050', // Search Level
  PLAN_TYPE: 'LBL00040', // Plan Type
  PROJECT: 'LBL00012', // Project
  CELL_GROUP: 'LBL00049', // Cell Group
  // Scale — 로컬 표시배율 콤보. 라벨 LBL01163('Scale')로 유지(사용자 지시 2026-10-23, Unit(Qty)→Scale 재복귀).
  //   AS-IS 원문은 'Unit (Qty)'(LBL01129)이나 Scale 표기를 쓴다. 둘 다 KO/EN/CN 등록 확인(SCM_ADM_MSG_M).
  SCALE: 'LBL01163',
  NICK_NAME: 'LBL00767', // Nick Name
  CELL_QTY: 'LBL00690', // Cell Qty 체크박스
  AS: 'LBL01167', // A/S 체크박스 — DB 신규 등록(LBL01167). 미싱크 시 fallback 'A/S'(AS-IS 원문)
  MONTHLY: 'LBL00684', // Monthly — Bucket 옵션
  WEEKLY: 'LBL00683', // Weekly — Bucket 옵션
  COLUMN: 'LBL00605', // Column Setting — 개인화 팝업 버튼
  MEASURE: 'LBL00310', // Measure — 개인화 팝업 버튼
} as const;

// Unit(Qty) 로컬 표시배율 콤보 표시 항목 (design 02 §2.5). 서버 조회 없는 정적 select — index=UNIT_QTY_SCALE.
//   라벨 = AS-IS ScpUtils.GetUnitQty() = lookup SCP_UNIT_QTY 의 NAME(SEGMENT2) 실측(ora.py 2026-10-14):
//   Q1 'QTY/1' / Q1000 'QTY/1,000' / Q1000000 'QTY/1,000,000' / Q100000000 'QTY/100,000,000' (DISPLAY_SEQ 순).
//   value=index(배율) — AS-IS SetUnitQty(cs:1695) 는 cboUnitQty.SelectedIndex 0/1/2/3 으로 나눗셈(code 아닌 순번).
export const UNIT_QTY_OPTIONS = [
  { label: 'QTY/1', value: '0' },
  { label: 'QTY/1,000', value: '1' },
  { label: 'QTY/1,000,000', value: '2' },
  { label: 'QTY/100,000,000', value: '3' },
] as const;

// 동적 pivot 기간칼럼 접두 (design 03 §2). M_(월)/W_(주) 표시, B_(BOH 보조) 숨김(width 0).
//   InitSpreadDateColumn cs:714~817: B_ 포함 -> AddTextColumn 숨김 / 그 외 -> AddNumColumn width70.
export const PIVOT_PREFIX = {
  MONTHLY: 'M_',
  WEEKLY: 'W_',
  BOH_HIDDEN: 'B_',
} as const;

// measure 행 조건부 배경색 8그룹 (design 03 §3-B, SetBackColor cs:819~1081). MEASURE_NAME 문자열 스위치.
//   SHEET_MEASURE 에 색상 메타 컬럼이 없어(확인필요 §6.2 #4) 코드 스위치로 재현 — cs 하드코딩 1:1 이식.
//   TOT_INV 는 sn81 2행 중복 실측(§6.2 #3) — 표시는 색상만 관여, dedup 은 measure fetch 가 담당.
export const MEASURE_BG = {
  INVENTORY: 'rgb(239, 239, 239)', // VMI Inventory/Intransit/Semi Intransit/Pack·Cell Inventory(Pack)/Cell Inv/AS Inv/Char. Available/Form. Progress
  DIO: 'rgb(219, 219, 219)', // DIO / STD_DIO
  TOT_INV: 'rgb(219, 219, 219)', // Total Inv
  BLUE: 'rgb(219, 229, 241)', // MKT FCST / Ship Plan / RTF
  ORANGE: 'rgb(252, 213, 180)', // Production / Production(PKG)
  PAST: 'rgb(234, 234, 234)', // plan_start 이전 기간칼럼(회색)
  PAST_INVENTORY: 'rgb(192, 192, 192)', // WEEKLY inventory measure x W_..A 칼럼(은색)
} as const;

// MEASURE_NAME -> 배경색 그룹 매핑 (design 03 §3-B cs:907~941 SetBackColor switch 이식). 행 라벨(MEASURE_NAME =
//   SCM_MST_SHEET_MEASURE.COLUMN_LABEL_NAME) 정확 일치. DB 실측(ora.py 2026-10-14)으로 라벨 문자열 확정 —
//   AS-IS cs 와 동일: 'VMI Inventory'·'Cell Inventory(Pack)'·'Char. Available'·'Form. Progress'(마침표 뒤 공백).
export const MEASURE_NAME_BG: Record<string, string> = {
  'VMI Inventory': MEASURE_BG.INVENTORY,
  Intransit: MEASURE_BG.INVENTORY,
  'Semi Intransit': MEASURE_BG.INVENTORY,
  'Pack Inventory': MEASURE_BG.INVENTORY,
  'Cell Inventory(Pack)': MEASURE_BG.INVENTORY,
  'Cell Inventory': MEASURE_BG.INVENTORY,
  'AS Inventory': MEASURE_BG.INVENTORY,
  'Char. Available': MEASURE_BG.INVENTORY,
  'Form. Progress': MEASURE_BG.INVENTORY,
  DIO: MEASURE_BG.DIO,
  STD_DIO: MEASURE_BG.DIO,
  'Total Inv': MEASURE_BG.TOT_INV,
  'MKT FCST': MEASURE_BG.BLUE,
  'Ship Plan': MEASURE_BG.BLUE,
  RTF: MEASURE_BG.BLUE,
  Production: MEASURE_BG.ORANGE,
  'Production(PKG)': MEASURE_BG.ORANGE,
};

// WEEKLY 과거 W_..A 셀 은색(PAST_INVENTORY) 대상 measure — AS-IS SetBackColor switch(cs:1055~1061)의 7개.
//   MEASURE_NAME_BG 의 INVENTORY 배경(9개)의 부분집합 — 'Cell Inventory(Pack)'·'AS Inventory' 는 제외(AS-IS
//   과거 회색 유지). 은색 조건을 INVENTORY 배경 전체로 걸면 이 2개가 과잉 은색이 되므로 명시 집합으로 한정.
export const PAST_INVENTORY_MEASURES: ReadonlySet<string> = new Set([
  'VMI Inventory',
  'Intransit',
  'Pack Inventory',
  'Cell Inventory',
  'Semi Intransit',
  'Char. Available',
  'Form. Progress',
]);

// 팝업 대상 텍스트 필드 (design 02 §4.6). btnItemId -> ItemByDivisionModal, btnProject -> ProjectByDivisionModal.
//   division 파라미터 cascade(현재 선택 division 으로 후보 필터, preSearchParams).
export const POPUP_TARGET = {
  ITEM: 'itemId',
  PROJECT: 'project',
  // btnColumn/btnMeasure 개인화 팝업(design 02 §4.6 B3/B4). ColumnLayoutModal / MeasureSelectModal 트리거.
  COLUMN: 'column',
  MEASURE: 'measure',
} as const;
export type PopupTarget = (typeof POPUP_TARGET)[keyof typeof POPUP_TARGET];
