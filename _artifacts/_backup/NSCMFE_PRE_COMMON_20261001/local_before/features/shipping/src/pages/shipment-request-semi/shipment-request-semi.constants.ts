// AS-IS GSCM.SSP.Plan.UIL SSP0045_ShipmentRequest (단일 그리드 spdMain "Shipment Request", 1,468행).
//   설계 근거: .atlas/gscm-design/SSP0045/design/00_checklist.md ~ 03_grid-columns.md
//   반제품(SEMI) 출하요청 — 고정 19칼럼(Action 1 + DB 메타 18) + SP 구동 동적 기간칼럼(M_/W_/D_) PIVOT.
//   코드 접두어 SSP = Shipping 도메인 → features/shipping (00 §0 도메인 판정).
//   - GET      SP : PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUEST  (10 IN — design 02 §1 / 03 §4.2)
//   - SAVE     SP : PKG_SSP0045.P_SSP0045_SAVE_SHIPMENT_REQUEST (15 IN, 13개가 '^' 구분 — design 03 §4.3)
//   - CALENDAR SP : SCP0009_GET_SHEET_CALENDAR_3SPAN 상당 (3단 헤더 메타 — design 03 §2.1)
//   - BOD POPUP SP: SCM0002_GetBODItemPrjRoutePopup 상당 (신규행 BOD 선택 — design 03 §3.2 R10)
//   주의: `PKG_SSP0045` 는 all_objects 0행(미배포, goal ②) — 조회/저장 런타임 체인은 convert-sp 후속이다.
export const MENU_ID = 'SSP0045' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (자매 SSP0012/SSP0019 표준 SHT_NM — design 01 §2.7 D4)
  CALENDAR = 'calendar', // 3단 헤더 메타(GET_SHEET_CALENDAR_3SPAN) — 자매 SCP0100 global-psi-report 배선 미러
  BOD_POPUP = 'bodPopup', // PU04 BOD Item/Project/Route 팝업 (design 00 §4e)
}

// NSCM 단일 cursor 표준 'o_rc1'. 실제 OUT cursor 이름은 PKG 배포 후 all_arguments 로 확정한다(hook #80).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  CALENDAR: 'o_rc1',
  BOD_POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS/SCM_MST_SHEET_MEASURE) SHEET_NAME — AS-IS 시트명 그대로.
//   실측: PROGRAM_ID='SSP0045' SHEET_NAME='Shipment Request' 컬럼 18행 / measure 9행 (design 03 §0).
//   SP 파라미터 p_sheet_name 도 같은 값이다 — 잘못 넘기면 SHEET_MEASURE INNER JOIN 이 어긋나 0행(design 03 §4.2).
export const ADMIN_SHEET_NAME = 'Shipment Request';

// PU04 BOD 팝업 그리드의 컬럼 메타 SHEET_NAME. `SHEETS.BOD_POPUP` 과 같은 문자열을 쓴다
//   (proc 호출 URL 의 시트명 = 컬럼 메타 시트명). 원천은 05_register.sql 8번 블록(AS-IS InitSpread 22칸).
export const POPUP_SHEET_NAME = 'bodPopup';

// ── 조회조건 콤보 SQL_ID (design 02 §5.1 — 5층 의미대조 완료, 신규 등록 0건) ──
//   MyDivision            : 권한 division(ATTRIBUTE3<>'EE' 제외). @mnuId 전달 필수(§5.3).
//   OperationGroup_SCP    : LOOKUP 'OPERATION_GROUP' IN ('P','A') — 파라미터 없음. `OperationGroup`(무접미) 부재.
//   PlantByDivisionOperation : 토큰 4개(@divisionId/@operationGroup/@param3/@plantId) 전부 전달(§5.2).
//   BucketType            : LOOKUP 'BUCKET_TYPE_CODE' (DAILY/WEEKLY/MONTHLY) — 파라미터 없음.
// ── 그리드 셀 콤보 SQL_ID (design 03 §1.4 — 메타 미이관 4건의 TO-BE 조치) ──
//   PlantSiteByDivision   : FROM_SITE/TO_SITE 공통 후보. PARAM1 = 리터럴 '40,81,82'(AS-IS cs:299, U2).
//   FcstType              : FCST_TYPE 정본. 메타값 `FCST_TYPE` 은 이름만 같고 SQL 이 달라 WS/WSF 2건이 조용히 빠진다(K18).
//   BODItemProjectRoute_SCP : 신규행 ITEM_ID 전용(PARAM9 축). @divisionId/@operationGroup 2파라미터.
export const COMBO = {
  DIVISION: 'MyDivision',
  OPERATION_GROUP: 'OperationGroup_SCP',
  FROM_SITE: 'PlantByDivisionOperation',
  BUCKET: 'BucketType',
  CELL_PLANT_SITE: 'PlantSiteByDivision',
  CELL_FCST_TYPE: 'FcstType',
  CELL_BOD_ITEM: 'BODItemProjectRoute_SCP',
} as const;

// AS-IS `Data.Common(PlantSiteByDivision, false, "40,81,82")` 리터럴(cs:299). 선택 division 을 넘기면
//   AS-IS 와 셀 콤보 후보집합이 달라진다 — 화이트리스트 "신설"이 아니라 AS-IS 이식이다(U2 / hook #92·#113).
//   전달 경로: `DataGrid comboParams.divisionId` → 메타 콤보 `PlantSiteByDivision` 의 `@divisionId`.
//   주의: `ATTRIBUTE1` 로는 전달되지 않는다 — TO-BE 셀 콤보 파라미터 축은 PARAM2/9/10 뿐이다
//   (docs/dev-manual/04_콤보_TO-BE.md §4.1). 05_register.sql 6-6 참조.
export const CELL_PLANT_SITE_DIVISIONS = '40,81,82';

export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}
// AS-IS DefineProperty `cboBucketType.SelectedValue = BucketType.Daily`(cs:187, G17).
export const DEFAULT_BUCKET_TYPE = BUCKET_TYPE.DAILY;

// AS-IS GetDayRange — SP02 `SCM0001_GET_SCP_DAY_PERIOD(p_from_date='', p_offset_day='55', p_timezone='AS054')`.
//   결과는 '오늘(KST) ~ 오늘+55일' 을 달력 마스터 존재일로 clamp 한 값이다(design 02 §2.5).
export const PERIOD_OFFSET_DAY = 55;

// 동적 기간칼럼 접두 (design 03 §2.2). `B_` 는 판정식이 `IndexOf("B_") > 0` 이라 도달 불가 — 구현하지 않는다.
export const PIVOT_PREFIX = {
  MONTH: 'M_',
  WEEK: 'W_',
  DAY: 'D_',
} as const;

// ── measure 축 (design 03 §1.3 — SCM_MST_SHEET_MEASURE 9행 실측) ──
export const EDITABLE_MEASURE = 'SHIP_REQ'; // 편집 가능한 유일 measure
export const NEW_ROW_MEASURE_LABEL = 'Ship Req'; // 신규행 MEASURE_LABEL 리터럴(cs:758)
// SUM 칸에 합계가 아니라 "뒤따르는 첫 D_ 값"(기초재고)을 복사하는 measure (R16 / G09).
export const BOH_MEASURES: readonly string[] = ['WH_BOH_PLAN', 'WH_BOH_REQ'];
// MEASURE_COLOR 배경의 시작열이 MEASURE_LABEL 이 아니라 TO_SITE 인 measure 6종 (R14, cs:1057-1061).
export const MEASURE_BG_FROM_TO_SITE: readonly string[] = [
  'CUST_PLAN',
  'CUST_REQ',
  'INTN_MOVEMENT',
  'INSP_PLAN',
  'WH_BOH_PLAN',
  'WH_BOH_REQ',
];
// 모델/공장 전환 경계선(BevelBorder)의 기준 measure — 각 그룹의 첫 measure (R15).
//   음영 3종의 색상값은 SCSS Module(`ShipmentRequestSemiGrid.module.scss`)이 소유한다 —
//   `MEASURE_COLOR`(행마다 다른 RGB)만 예외로 formatItem 이 inline 으로 칠한다.
export const GROUP_HEAD_MEASURE = 'SCP_PLAN';

// ── 고정 컬럼 binding (design 03 §0.3 런타임 인덱스) ──
export const COLUMN = {
  DIVISION_ID: 'DIVISION_ID',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  FROM_SITE: 'FROM_SITE',
  TO_SITE: 'TO_SITE',
  TR_MODE: 'TR_MODE',
  INCOTERMS: 'INCOTERMS',
  PROJECT_CODE: 'PROJECT_CODE',
  FCST_TYPE: 'FCST_TYPE',
  LT_DAY: 'LT_DAY',
  LAST_UPDATED_BY: 'LAST_UPDATED_BY',
  MEASURE_LABEL: 'MEASURE_LABEL',
  BOD_ID: 'BOD_ID',
  MEASURE_COLOR: 'MEASURE_COLOR',
  FROZEN_YYYYMMDD: 'FROZEN_YYYYMMDD',
  MEASURE: 'MEASURE',
  BOD_FROM_YYYYMMDD: 'BOD_FROM_YYYYMMDD',
  BOD_TO_YYYYMMDD: 'BOD_TO_YYYYMMDD',
} as const;

// BOD 팝업 확정 시 신규행에 채우는 7칸 → 팝업 반환 프로퍼티 (design 03 §3.2 R10, S47~S54).
//   주의: `ITEM_ID` 는 여기에 없다 — AS-IS cs:1264 는 팝업 반환값이 아니라 **클릭한 행의 기존 ITEM_ID**
//   (`p_item_id`)를 다시 써 넣는다. 애초에 팝업 `retList`(SCM0002_GetBODItemPrjRoutePopup.cs:315-332)에
//   `c_item_id` 자체가 없다. iter-1 의 `C_ITEM_ID` 매핑은 존재하지 않는 프로퍼티라 ITEM_ID 를 ''로
//   덮어써 신규행을 무효화했다.
export const BOD_FILL_MAP: Record<string, string> = {
  [COLUMN.FROM_SITE]: 'C_FROM_SITE',
  [COLUMN.TO_SITE]: 'C_TO_SITE',
  [COLUMN.TR_MODE]: 'C_TRANSPORT_MODE',
  [COLUMN.INCOTERMS]: 'C_INCOTERMS',
  [COLUMN.LT_DAY]: 'C_LT_DAY',
  [COLUMN.FROZEN_YYYYMMDD]: 'C_FROZEN_YYYYMMDD',
  [COLUMN.BOD_ID]: 'C_BOD_ID',
};

// Model(ITEM_ID) 재선택 시 비우는 종속 5칸 (R11, S58~S62).
//   주의: `BOD_ID`·`FROZEN_YYYYMMDD` 는 AS-IS 가 지우지 않는다(U4) — 목록에 넣지 말 것.
export const MODEL_DEPENDENT_CLEAR_COLUMNS: readonly string[] = [
  COLUMN.FROM_SITE,
  COLUMN.TO_SITE,
  COLUMN.TR_MODE,
  COLUMN.INCOTERMS,
  COLUMN.LT_DAY,
];

// 저장 전 중복검사 9키 (`checkValidN0` cs:1372-1462, V09). MEASURE='SHIP_REQ' 행만 대상.
export const DUP_KEY_COLUMNS: readonly string[] = [
  COLUMN.DIVISION_ID,
  COLUMN.TO_SITE,
  COLUMN.ITEM_ID,
  COLUMN.INCOTERMS,
  COLUMN.TR_MODE,
  COLUMN.FROM_SITE,
  COLUMN.BOD_ID,
  COLUMN.PROJECT_CODE,
  COLUMN.FCST_TYPE,
];

// 3단 헤더 총높이 48px 규약(hook #93) — 1단 16 × 3. AS-IS 20/30px 는 FarPoint 좌표라 이식하지 않는다.
export const HEADER_ROW_HEIGHT = 16;
// AS-IS AddNumColumn width 70 (design 03 §2.2).
export const PIVOT_COLUMN_WIDTH = 70;

// 기간셀 입력 상·하한 — AS-IS `SetReNumerCellType(spdInfo, idx, -9999999999, 0)`(cs:355·359)이
//   프레임워크 4-인자 오버로드(`SpreadInfo.cs:11005-11018`)에서 `NumberCellType.MaximumValue = 9999999999`
//   / `MinimumValue = lMinValue` 로 **셀 입력 자체를 클램프**한다. 소수자리 0(`DecimalPlaces`)은
//   `format:'n0'` 이, 천단위 구분(`ShowSeparator`)은 `n` 포맷이 각각 담당한다.
//   주의: 음수 자체는 입력을 허용한다(하한이 -9,999,999,999) — 저장 시 R13/V02 가 차단한다.
export const PIVOT_QTY_MAX = 9_999_999_999;
export const PIVOT_QTY_MIN = -9_999_999_999;

// i18n LBL — SCM_ADM_MSG_M 문구 역조회 실측(design 02 §4.5 / 03 §5.3). AS-IS 번호 답습 금지(hook #114).
//   `LBL00505`(공용 PeriodField 기본 라벨)는 SCM_ADM_MSG_M 에 없다 — Period 는 LBL00013 을 명시 전달한다.
export const LBL = {
  DIVISION: 'LBL00641',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00669',
  FROM_SITE: 'LBL00022',
  BUCKET: 'LBL00710',
  PERIOD: 'LBL00013',
  SUM: 'LBL00687',
  SEARCH: 'LBL00664',
  NO: 'LBL00674',
  OK: 'LBL00716',
  CLOSE: 'LBL00627',
} as const;

// PU04 팝업 제목 — AS-IS 시트명 `SpdSheet.shtMain = "BOD Item Master"`
//   (SCM0002_GetBODItemPrjRoutePopup.cs:49)의 TO-BE 실측 대응 코드다(문구 완전 일치).
//   MSG_TP_CD 가 'MNU' 라 `LBL`/`MSG` 접두는 아니지만 5자리 표준형이고 `public/locales/EN.json` 에
//   실재하는 등록 코드다 — iter-1 의 자유 형식 키(`_ssp0045.bodPopupTitle`, convert-core §2.4 금지)를 대체한다.
export const BOD_POPUP_TITLE_KEY = 'MNU00158';

// i18n MSG — 전건 TO-BE 실측 역조회(design 02 §4.5.1 / 03 §5.3).
//   AS-IS 번호 5종 중 MSG00108 만 문구가 일치한다. 나머지는 뜻이 다르거나 미등록이다.
//     MSG00002(필수) → MSG00429 / MSG00049(기간 미입력) → MSG00665 / MSG00172(371일) → MSG01187
//     MSG00097(권한 0건) → MSG00667 / MSG00004(저장 성공) → MSG00672 / MSG00005(변경 없음) → MSG00676
//     MSG00042(시스템 오류) → MSG01075 / MSG00084(음수) → MSG00699 / MSG00098(먼저 선택) → MSG01126
export const MSG = {
  REQUIRED: 'MSG00429', // "{0} value is required."
  PERIOD_EMPTY: 'MSG00665', // "Please enter the search period."
  PERIOD_ORDER: 'MSG00108', // "Invalid period (start > end)."
  PERIOD_MAX: 'MSG01187', // "Maximum Period is From Date + {0}."
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (권한 division 0건 게이트)
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved."
  NO_CHANGE: 'MSG00676', // "There is no data to save."
  SYSTEM_ERROR: 'MSG01075', // "System error. Capture the screen and pass it on to the system manager."
  NEGATIVE_QTY: 'MSG00699', // "Please enter an integer greater than 0."
  SELECT_FIRST: 'MSG01126', // "First, select {0}." (TR_MODE 클릭 시 Model 미선택 — V08)
  // AS-IS `MSG00260` 의 의도는 소스 주석 실측상 "입력 데이터 중 중복된 데이터가 있습니다."
  //   (cs:1449). TO-BE `MSG00260` 은 "Duplicate combination (Division/Project/Item/Date/Measure)." 로
  //   **축이 다른 별개 문구**라 그대로 쓰면 9축 중복을 5축으로 잘못 안내한다(hook #114 함정).
  //   문구 기준 역조회 결과 정확히 일치하는 TO-BE 코드는 `MSG00428`
  //   ("There are duplicate entries among the newly entered data.") 다.
  DUPLICATE: 'MSG00428',
  // PU04 팝업 OK 시 선택 0건 안내. AS-IS `MSG00071`(SCM0002_GetBODItemPrjRoutePopup.cs:337-340)과
  //   **번호·문구가 모두 일치**하는 드문 경우다 — TO-BE `SCM_ADM_MSG_M`/`public/locales` 실측
  //   'No rows selected.' / '선택된 행이 없습니다.'(hook #114 역조회 확인).
  NO_ROWS_SELECTED: 'MSG00071',
} as const;

// AS-IS `DateUtil.Check_PeriodDate` 3분기 중 최대 기간 = "from + 1 캘린더 연도 + 7일".
//   실제 경계 계산은 `DateUtil.cs:122 GetDateAdd(date1,1,'Y')` → `:140 GetDateAdd(...,7,'D')` 이고,
//   `:144` 의 `(364+7)` 은 **메시지 인자일 뿐**이다 — 윤년(2/29 포함 구간)에는 실경계가 373일이 된다.
//   따라서 경계는 dayjs `add(1,'year').add(7,'day')` 로 계산하고, 이 상수는 `MSG01187` 의 {0} 인자로만 쓴다.
export const MAX_PERIOD_LABEL_DAYS = 371;
