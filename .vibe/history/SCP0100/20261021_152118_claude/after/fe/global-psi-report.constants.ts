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

// 조회기간 종료일 원천 — AS-IS GetPlanEndDate(SCP0100_Global_PSI_Report.cs:2029~2052)
//   Data_REPORT.CallBizCommonData(PLAN_END_DATE, '81', _plan_start_yyyymmdd, "WEEKLY")
//   → UP_FX_GetCommonDataList_REPORT: SELECT TOP 1 HORIZON_END_DATE FROM SCM_MST_PLAN
//     WHERE DIVISION_ID=@param1 AND PLAN_NAME=@param2 AND PLAN_CYCLE=@param3 (As-is DB 원문 2026-10-20 실측).
//   To-Be 등록 콤보 SCPPlanPeriod_SCP(SCM_ADM_CMBO_SQL_M, 자매 global-psi SCP0031 사용 중)가 같은 표·같은 조건
//   (PLAN_NAME=@planName · DIVISION_ID=@divisionId · PLAN_CYCLE='WEEKLY' 고정)이라 그대로 재사용한다.
//   사내 (DIVISION_ID, PLAN_NAME, PLAN_CYCLE) 중복 0건 실측 → 첫 행 = TOP 1 과 동등.
export const PLAN_END_COMBO_ID = 'SCPPlanPeriod_SCP';
export const PLAN_END_COL = 'HORIZON_END_DATE';
// AS-IS .cs:2037~2038 — `//, CommonUtils.GetValue(_division)` 주석 처리 후 `CommonUtils.GetValue("81")` 고정 호출.
//   선택 division 과 무관하게 '81' 의 WEEKLY horizon 종료일을 쓴다(As-is 동작 그대로).
export const PLAN_END_DIVISION = '81';

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

// EE division 제외 필터값 (SCM_MST_DIVISION.ATTRIBUTE3='EE' — 전극 6종, 부록 B-2). FE 후처리 대상.
export const DIVISION_EE_EXCLUDE = 'EE';
// 완제품 division 제외 코드 (부록 B-2): 40=Mobility & IT Battery, 82=ESS Battery. 셀 단위 division 만 남김.
export const DIVISION_EXCLUDE_CODES = ['40', '82'] as const;

// lookup TYPE (SCM_ADM_LOOKUP_MASTER_DETAIL — design 02 부록 B-4). useTabLookupQueries 로 조회.
//   반환은 소스 index 가 아니라 code(SEGMENT1) 기반, VALID_YN='Y' + DISPLAY_SEQ 순.
export const LOOKUP = {
  DISPLAY: 'STOCK_TREND_DISPLAY', // ALL(All) / CHART(Chart) / GRID(Grid) — 3종 VALID
  SEARCH_LEVEL: 'PRODUCT_LEVEL', // CELL_GROUP / CELL_GROUP_DETAIL / PRODUCT_LEVEL1..3 — 5종 VALID
  PLAN_TYPE: 'PLAN_TYPE', // PR/MA/SE/FN/TE — 5종 VALID, 기본 FN='Final Plan'
  // cboUnitQty — AS-IS ScpUtils.GetUnitQty()(SheetUtils.cs:1856) = LookupCommon 'SCP_UNIT_QTY'.
  //   사내 SCM_ADM_LOOKUP_MASTER_DETAIL 실측(2026-10-21) Q1/Q1000/Q1000000/Q100000000 4종 VALID, DISPLAY_SEQ 순.
  //   배율은 AS-IS SetUnitQty(.cs:1697) 처럼 선택 index 로 정한다(UNIT_QTY_SCALE).
  UNIT_QTY: 'SCP_UNIT_QTY',
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
  // rgrpSearchLevel=Detail 일 때 P_SEARCH_LEVEL 로 보내는 값 — AS-IS getSearchLevel(.cs:414-417) `res = "DETAIL"`.
  //   PKG_SCP0100 BODY 의 DETAIL 분기(L849·L1493)가 이 값으로 REPORT 상세 데이터를 만든다(콤보 lookup 코드 아님).
  DETAIL: 'DETAIL',
} as const;

// SetLayout(.cs:1490-1542) — Search Level 별 Product Level 컬럼 표시. Detail 모드는 사용자 정의 컬럼 기준이라 미적용.
//   AS-IS 는 cboSearchLevel.SelectedIndex 로 분기하므로 lookup PRODUCT_LEVEL 의 VALID·DISPLAY_SEQ 순서(사내 실측
//   CELL_GROUP / CELL_GROUP_DETAIL / PRODUCT_LEVEL1 / 2 / 3)로 index→code 를 대응시킨다. 목록에 없는 코드 = default(전부 숨김).
export const PRODUCT_LEVEL_COLUMNS = ['PRODUCT_LEVEL1', 'PRODUCT_LEVEL2', 'PRODUCT_LEVEL3'] as const;
export const PRODUCT_LEVEL_VISIBLE: Record<string, readonly string[]> = {
  CELL_GROUP_DETAIL: ['PRODUCT_LEVEL1', 'PRODUCT_LEVEL2'], // case 1
  PRODUCT_LEVEL1: ['PRODUCT_LEVEL1'], // case 2
  PRODUCT_LEVEL2: ['PRODUCT_LEVEL2'], // case 3
  PRODUCT_LEVEL3: ['PRODUCT_LEVEL1', 'PRODUCT_LEVEL2', 'PRODUCT_LEVEL3'], // case 4
};

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

// rgrpSearchLevel 대응 — 공유 UI 에 RadioGroup 이 없어 2지선다 CustomDropdown 으로 재현(design 01 §2 R1/R4).
//   value = SEARCH_MODE. idx0 Search Level(기본) / idx1 Detail(REPORT 시트 show, SearchLevel 콤보 disable R4).
//   항목 문구 = AS-IS RadioGroupItem(designer:239-240) "Search Level"/"Detail" → 등록 LBL(LBL00050/LBL00316)로 표시.
export const SEARCH_MODE_OPTIONS = [
  { lbl: 'LBL00050', label: 'Search Level', value: SEARCH_MODE.SEARCH },
  { lbl: 'LBL00316', label: 'Detail', value: SEARCH_MODE.DETAIL },
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
  // 조회 시작일 > Plan 시작일 (DCalendar_ValueChanged .cs:2013-2015). AS-IS 리터럴 "[조회 시작일] Plan Date 이전으로
  //   설정해야 합니다." -> 사내 SCM_ADM_MSG_M 역조회(2026-10-21) MSG01186 EN 'Begin Date is early or equal to Plan Date.'
  //   (같은 규칙). 주의: 같은 코드의 KO 문구는 '크거나 같아야' 로 의미가 반대 — 기존 MSG 문구 수정은 사용자 결정 사항.
  PLAN_DATE_RANGE: 'MSG01186',
  // 권한 Division 0건 (design 01 A1 cs:583). AS-IS MSG00097 "권한을 가진 Division이 없습니다".
  //   SCP0100 은 권한조인 2행 등록으로 실발동 안 함(부록 B-6)이나 A1 규칙 재현을 위해 코드 보존.
  NO_DIVISION_AUTH: 'MSG00097',
} as const;

// i18n 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 LBL ID(design 02 부록 B-5). t(LBL.KEY, '_Fallback').
//   값 = LBL 코드. 명칭은 조회조건 카탈로그(search_conditions_scp_dm.md 'Global PSI New' To-Be 명칭) 기준 —
//   Div.(LBL00001) / PJT(LBL00012) / Model/Nickname(LBL00618) / Unit(LBL00045). 사내 MSG_M 역조회 2026-10-21.
export const LBL = {
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  DIVISION: 'LBL00001', // Div. — 조회조건 Division 표준 코드(shipment-working-day 선례 동일)
  FROM_SITE: 'LBL00022', // From Site
  TO_SITE: 'LBL00023', // To Site
  PLAN_DATE: 'LBL00039', // Plan Date
  PERIOD: 'LBL00013', // Period — AS-IS layPeriod "Period*"(dCalendar UsrDateRangePicker3)
  BUCKET: 'LBL00710', // Bucket
  DISPLAY: 'LBL01073', // Display
  SEARCH_LEVEL: 'LBL00050', // Search Level
  PLAN_TYPE: 'LBL00040', // Plan Type
  PROJECT: 'LBL00012', // PJT — 카탈로그 Project→PJT (자매 화면 사용 코드)
  MODEL_NICKNAME: 'LBL00618', // Model/Nickname — AS-IS layModel "Model / Nick Name"(txtItemId)
  CELL_GROUP: 'LBL00049', // Cell Group
  UNIT: 'LBL00045', // Unit — 카탈로그 Unit (Qty)→Unit. 로컬 표시배율 콤보
  AS: 'LBL01167', // A/S — AS-IS chkAS.Text "A/S"(designer:927)
  CELL_QTY: 'LBL00690', // Cell Qty 체크박스
  MONTHLY: 'LBL00684', // Monthly — Bucket 옵션
  WEEKLY: 'LBL00683', // Weekly — Bucket 옵션
  COLUMN: 'LBL00605', // Column Setting — 개인화 팝업 버튼
  MEASURE: 'LBL00310', // Measure — 개인화 팝업 버튼
} as const;

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
  INVENTORY: 'rgb(239, 239, 239)', // VMI/Intransit/Semi Intransit/Pack·Cell Inv/AS Inv/Char.Available/Form.Progress
  DIO: 'rgb(219, 219, 219)', // DIO / STD_DIO
  TOT_INV: 'rgb(219, 219, 219)', // Total Inv
  BLUE: 'rgb(219, 229, 241)', // MKT FCST / Ship Plan / RTF
  ORANGE: 'rgb(252, 213, 180)', // Production / Production(PKG)
  PAST: 'rgb(234, 234, 234)', // plan_start 이전 기간칼럼(회색)
  PAST_INVENTORY: 'rgb(192, 192, 192)', // WEEKLY inventory measure x W_..A 칼럼(은색)
} as const;

// 숫자 기간칼럼 음수 글자색 — AS-IS SetReNumerCellType(SpreadInfo.cs:13815) NumberCellType.NegativeRed=true.
export const NEGATIVE_FORE = '#ff0000';

// Measure Group 이 바뀌는 행의 상단 경계선 — AS-IS SetBackColor(.cs:877-904·947-954) complexBorderDarkGray
//   (ComplexBorder(left, top=DarkGray 2px, right, bottom)). 'AS Sales PSI' Black 경계는 적용 직전 Clear(.cs:955)라 실효 없음.
export const MEASURE_GROUP_BORDER_TOP = '2px solid rgb(169, 169, 169)';

// MEASURE_NAME -> 배경색 그룹 매핑 (SetBackColor .cs:922-940 switch 이식). 키 = 행 MEASURE_NAME 정확 일치 —
//   값 원천은 SCM_MST_SHEET_MEASURE('Global PSI New') COLUMN_LABEL_NAME(사내 실측: 'VMI Inventory'·'Char. Available'·
//   'Form. Progress'·'Cell Inventory(Pack)' — 공백·괄호 포함). 주석 처리된 case(MKT_FCST 등 코드형)는 이식하지 않는다.
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

// WEEKLY 과거재고 은색 대상 measure — SetBackColor WEEKLY 분기(.cs:1055-1061) case 7종. 배경색 INVENTORY 그룹과
//   다르다('Cell Inventory(Pack)'·'AS Inventory' 는 제외 — .cs:1062 주석 "PACK_CELL_EOH 와 CELL_EOH 는 동일한 명칭").
export const PAST_INVENTORY_MEASURES: ReadonlySet<string> = new Set([
  'VMI Inventory',
  'Intransit',
  'Pack Inventory',
  'Cell Inventory',
  'Semi Intransit',
  'Char. Available',
  'Form. Progress',
]);

// 팝업 대상 텍스트 필드 (design 02 §4.6). btnItemId -> MaterialByDivisionModal(Model/Nickname, 카탈로그 메1), btnProject -> ProjectByDivisionModal.
//   division 파라미터 cascade(현재 선택 division 으로 후보 필터, preSearchParams).
export const POPUP_TARGET = {
  ITEM: 'itemId',
  PROJECT: 'project',
  // btnColumn/btnMeasure 개인화 팝업(design 02 §4.6 B3/B4). ColumnLayoutModal / MeasureSelectModal 트리거.
  COLUMN: 'column',
  MEASURE: 'measure',
} as const;
export type PopupTarget = (typeof POPUP_TARGET)[keyof typeof POPUP_TARGET];
