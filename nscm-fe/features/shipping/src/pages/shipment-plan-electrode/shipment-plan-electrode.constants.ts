export const MENU_ID = 'SSP0023' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0023_ShipmentPlanElectrode (Shipment Plan - Electrode / 출하계획-전극):
//   설계 근거: .atlas/gscm-design/SSP0023/design/00_checklist.md ~ 03_grid-columns.md, 매핑 __asis-mapping__.md
//   - 3 spread / 5 sheetNm / 148 컬럼(26+71+28+17+6). 이중 pivot: 행=Measure(11) × 열=기간(3 span X_/Y_/Z_ × 3 bucket D_/W_/M_).
//   - Main 동적 기간칼럼은 PKG_SSP0023.P_SSP0023_GET_SHEET_CALENDAR_3SPAN 이 런타임 공급(SCM_MST_SHEET_COLUMNS 에 없음).
//     칼럼 tag = [X_|Y_|Z_][D_|W_|M_]yyyyMMdd. span prefix 는 rdButton(1→X_/2→Y_/3→Z_)이 활성 span 선택, bucket prefix 는 cboBucketType.
//   - 편집 대상 측정치 = P_SHIP_PLAN_SIMU_ETD 행만(siMain), [plan_start~confirm_day] 비-SUM 칼럼(03 §3.1).
//   - siDetail(shtPlanDetail) 편집: SHIPMENT_STATUS=='C' && ERP_STATUS!='C' 행만 화이트리스트 컬럼 unlock(03 §3.1).
//   - 편집 화이트리스트는 DB INPUT_TP_CD 전건 'S' 갭(§6-5)이라 코드 상수로 재현. admin 이 INPUT_TP_CD 정비 시 메타 기준으로 전환.
//   - 툴바: Find/Insert/Save = 실동작, Delete = 미저장 신규행(CRUD_TYPE='I')만 제거(AS-IS 빈 NO-OP 는 Insert 행 되돌림 불가 버그 → 사용자 지시 2026-11-09 실동작 부여), Edit = SwitchLock 미이식(edit default ON).
//   - 확정 SAVE SP PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(27 IN + O_RC1/O_RC2) 배포·VALID(ora.py 실측 2026-10-16) → Detail 저장 실배선. siMain 시뮬레이션 저장 SAVE_SHIPMENT_PLAN_SIMU 도 배포됨.
export enum SHEETS {
  MAIN = 'main', // spdMain "Shipment Plan(Electrode)" (Measure pivot 11 × 기간 pivot)
  CALENDAR = 'calendar', // PKG_SSP0023.P_SSP0023_GET_SHEET_CALENDAR_3SPAN (동적 기간칼럼 메타 공급)
  PLAN_DETAIL = 'planDetail', // shtPlanDetail "Shipment Plan Detail" (71컬럼, 셀콤보 5, 편집 상태조건)
  STOCK_DETAIL = 'stockDetail', // shtStockDetail "Stock Detail" (28컬럼, 읽기전용)
  SHIPMENT_RESULT = 'shipmentResult', // shtShipmentResult "Shipment Result" (17컬럼, 읽기전용)
  EXCEL = 'excel', // siSub "Shipment Plan Detail Excel" (6컬럼, 엑셀 업로드 양식)
}

// NSCM cursor 표준 — 전 시트 단일 cursor(o_rc1). Division/Company 는 조회콤보(전용 SP 아님, 02 §5-1).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  CALENDAR: 'o_rc1',
  DETAIL: 'o_rc1',
} as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측 5 sheetNm 그대로 (03 §1, DB 배포 케이싱 정본).
//   주의: BE 버튼권한 검증은 대소문자 구분 — 이 값을 DB 배포 SHEET_NAME 케이싱에 맞춘다([[sht-nm-case-sensitive-per-screen]]).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Plan(Electrode)',
  [SHEETS.PLAN_DETAIL]: 'Shipment Plan Detail',
  [SHEETS.STOCK_DETAIL]: 'Stock Detail',
  [SHEETS.SHIPMENT_RESULT]: 'Shipment Result',
  [SHEETS.EXCEL]: 'Shipment Plan Detail Excel',
};

// 컬럼/Measure 개인화 저장 구분값 (SCM_MST_TITLESET_USER — 조회/저장/복원 3점 일치)
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// ====================================================================================
// 조회조건 콤보/lookup (design 02 §5-1 — CMBO_SQL 6종 미배포 → 05_register.sql 등록, 접속 PASS).
//   cascade: Division→(client filter)Company→(refetch)FromSite+PlanDate→(date-set)drpPeriod (02 §3).
// ====================================================================================
export const COMBO = {
  DIVISION: 'MyDivisionInEE', // @groupId @userId → Division (FE 후필터 CODE!='EE', 02 §5-1)
  COMPANY: 'Div_Company', // +DIVISION_ID 축 → Company (FE filter-cascade by Division CODE)
  FROM_SITE: 'Com_FromSitePlantEE', // @divisionId @companyId → From Site (PLANT + OP_GROUP='E')
  PLAN_INFOR: 'Plan_InforElectrode', // @companyId → Plan Date (TOP50, CURRENT_PLAN_DATE_YN='Y' 축)
  BUCKET_TYPE: 'BUCKET_TYPE_CODE', // Bucket (lookup 재사용, CODE=DAILY/WEEKLY/MONTHLY 완전어)
  RESULT_TYPE: 'SSP_SHIPMENT_RESULT_TYPE', // Result Type (P/O/E/R — FE 후필터 R 제외)
  // 셀콤보(siDetail) — 03 §1.6
  LOOKUP_COMMON: 'LookupCommon', // SHIPMENT_STATUS 셀콤보 (@lookupType='SHIPMENT_STATUS')
  DOM_EXP: 'DomExpTypeCode', // DOM_EXP 셀콤보 (정적 lookup)
  PACKAGE_TYPE: 'ElectrodePackageType', // PACKAGE_TYPE 셀콤보 (정적 lookup BX/SC/SR)
  BUILDING: 'BuildingByPlantSite', // FACTORY_ID 셀콤보 (@pPlantSiteId 앞4자=PLANT_ID, @divisionId cascade + 'ALL'행)
  CHANGE_REASON: 'CHANGE_REASON_CODE_ALL', // CHANGE_REASON_CODE 셀콤보 (lookup + '-' 선두행)
} as const;

export const LOOKUP = {
  RESULT_TYPE: 'SSP_SHIPMENT_RESULT_TYPE',
  // My Model 초기 auto-check(R09) — 사용자 Company 가 이 목록(VALID_YN='Y' 행)에 있으면 chkMyModel 초기 checked.
  //   AS-IS InitControls L502·L505~512 dtMyModelChk. 응답 행 키=CODE(LOOKUP_MASTER SEGMENT1 헤더).
  MY_MODEL_DEFAULT_CHECK: 'MY_MODEL_DEFAULT_CHECK',
  // 출하일 변경요청 기준일수(dDay) — AS-IS dtBaseDay(cs:455~458). 1행의 NAME(=SEGMENT2) 열이 기준일수.
  //   ora.py 실측: SEGMENT1(CODE)='D' / SEGMENT2(NAME)='-56'. 하드코딩 금지 — lookup 실값만 쓴다.
  //   자매 shipment-change-request 와 동일 lookupType·해석(useShipmentChangeRequestValidation).
  CHANGE_REQ_DAY: 'CHANGE_REQ_DAY',
} as const;

// 변경행 CHANGE_REASON_CODE 가 비었거나 '-' 일 때 저장 전 자동으로 채우는 기본 사유코드.
//   AS-IS strChangeReasonCode="T07"(cs:298) — 사용자 입력을 강제하지 않고(MSG00285 검증 주석처리) 자동 세팅.
export const DEFAULT_CHANGE_REASON_CODE = 'T07';

// Bucket Type — SSP0023 는 CODE 가 완전어('DAILY'/'WEEKLY'/'MONTHLY', 02 §5-1 실측 — SSP0060 의 D/W/M 과 다름).
//   변경 시 컬럼 표시 규칙만 전환(03 §2.2 — 재조회 없음).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// BOH 3-radio 배타 토글 (03 §2.1) — span prefix 도 동시 선택(rdButton1→X_ / rdButton2→Y_ / rdButton3→Z_).
export enum BOH_RADIO {
  GENERAL = 'rdButton1', // TOT/JR/PC_BOH_QTY + X_ span
  CELL = 'rdButton2', // TOT/JR/PC_BOH_QTY_CELL + Y_ span
  PCM = 'rdButton3', // TOT/JR/PC_BOH_QTY_PCM + Z_ span
}

// BOH 9칸 3-radio 매핑 (03 §1.1 / §2.1) — 한 시점 3칸만 표시.
export const BOH_COLUMNS: Record<BOH_RADIO, readonly [string, string, string]> = {
  [BOH_RADIO.GENERAL]: ['TOT_BOH_QTY', 'JR_BOH_QTY', 'PC_BOH_QTY'],
  [BOH_RADIO.CELL]: ['TOT_BOH_QTY_CELL', 'JR_BOH_QTY_CELL', 'PC_BOH_QTY_CELL'],
  [BOH_RADIO.PCM]: ['TOT_BOH_QTY_PCM', 'JR_BOH_QTY_PCM', 'PC_BOH_QTY_PCM'],
};

// rdButton → 활성 기간 span prefix (03 §2.2)
export const RADIO_SPAN_PREFIX: Record<BOH_RADIO, 'X_' | 'Y_' | 'Z_'> = {
  [BOH_RADIO.GENERAL]: 'X_',
  [BOH_RADIO.CELL]: 'Y_',
  [BOH_RADIO.PCM]: 'Z_',
};

export const ALL = 'ALL';
export const PROGRAM_ID = MENU_ID;

// ERP_SO_NO(PO No) 더블클릭 → SSP0300 Order Detail 팝업.
//   AS-IS SpdDetail_CellDoubleClick(cs L1788~1810 상당, shtPlanDetail 의 ERP_SO_NO 분기)
//   `SSP0300_OrderDetailPopup.Form_Load(DIVISION_ID, ERP_SO_NO, CONFIRM_ID, ITEM_ID, "Y")`.
//   5번째 electrode_yn 은 이 화면에서 상수 "Y"(전극) — SSP0300.InitSpread 가 Y 면 첫 3컬럼 라벨을
//   SO -> PO(PO No / PO Item No / PO Item Qty)로 바꾼다(SSP0300_OrderDetailPopup.cs:133~145).
//   데이터 컬럼명(SO_NO/SO_ITEM_NO/SO_ITEM_QTY)과 조회 proc 은 비전극과 동일 — 라벨만 다르다.
//   조회 proc P_SSP0300_GET_ORDER_DETAIL 은 standalone PROCEDURE, VALID 배포 + API_M 등록 상태
//   (자매 SSP0015/0060/0200 공유, 2026-10-08 ora.py 실측). SHT_NM='main' 으로 호출한다(자매 통일)
//   — 06_register_order_detail_btn_auth.sql.
export const ORDER_DETAIL_BTN = 'GET_ORDER_DETAIL';

// ====================================================================================
// 편집 화이트리스트 (design 03 §3.1 — DB INPUT_TP_CD 전건 'S' 갭#5이라 코드 상수로 재현.
//   admin 메타(INPUT_TP_CD) 정비 시 이 상수를 제거하고 메타 기준으로 전환할 것)
// ====================================================================================
// Main 편집 대상 측정치 (03 §3.1): MEASURE=='P_SHIP_PLAN_SIMU_ETD' 행만 [plan_start~confirm_day] 비-SUM 편집.
export const MAIN_EDITABLE_MEASURE = 'P_SHIP_PLAN_SIMU_ETD';
// Plan-Confirm 불일치 LightPink 비교 대상 측정치 (03 §3.3)
export const MAIN_CONFIRM_MEASURE = 'P_SHIP_CONFIRM_ETD';

// shtPlanDetail — Edit 시 SHIPMENT_STATUS=='C' && ERP_STATUS!='C' 행에서 unlock 되는 컬럼 (03 §3.1 cs:2244~2269).
export const PLAN_DETAIL_EDITABLE_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'DOM_EXP',
  'PACKAGE_TYPE',
  'FACTORY_ID',
  'TRANSPORT_MODE',
  'REMARKS2',
  'REMARKS',
  // AS-IS cs:2289 CONFIRM_QTY_PANCAKE~SHIPTO_DESCRIPTION 잠금 범위라 편집 제외 (2026-10-23)
  // 'CHANGE_REASON_CODE',
  // 'CHANGE_REASON_DETAIL',
  // 'CONFIRM_QTY_PANCAKE',
  // 'CONFIRM_QTY_JR',
  // 'CONFIRM_QTY_CELL',
] as const;

// shtPlanDetail — 신규행(InsertRow)에서 편집 가능한 컬럼 (03 §3.2 cs:2024~2029 LockRange 실측).
//   AS-IS 는 신규행에 값 복사 후 4개 LockRange 로 아래 구간을 잠근다(메타행 인덱스 기준):
//     DIVISION_ID(1)~DAYOFWEEK_NAME(11) · SHIPPING_PLAN_QTY(13) ·
//     GAP(15)~ELECTRODE_POST_OPER(22) · CONFIRM_QTY_PANCAKE(24)~MERGE_NUM(69).
//   잠금 구간 밖의 편집 셀만 신규행에서 열린다 = 아래 3개뿐이다.
//   필수: PACKAGE_TYPE(17)·REMARKS2(19)·REMARKS(20)·FACTORY_ID(21)·DOM_EXP(10)·CHANGE_REASON 계열·
//     CONFIRM_QTY 계열은 기존행(EditButton 선택적 unlock)에선 열리지만 신규행에선 LockRange 로 잠긴다 —
//     PACKAGE_TYPE(메타행17)은 GAP(15)와 ELECTRODE_POST_OPER(22) 사이라 세 번째 LockRange 구간 안 =
//     신규행 편집 불가. 03 §3.2 서술("나머지 ... 편집")은 LockRange 를 컬럼 인덱스에 대입하지 않은 추정이라 소스로 교정(2026-10-15).
//   단 PACKAGE_TYPE·FACTORY_ID 는 아래 PLAN_DETAIL_REQUIRED_COLUMNS(라벨 `*`) 필수라, 복사 원본 행이 NULL 이면
//   신규행이 영구히 MSG00429 로 저장 불가였다(결함 B5 — 필수인데 편집 불가인 자기모순). 그래서 신규행에서
//   두 필수 콤보와 같은 SO 그룹 전파 대상인 DOM_EXP 를 연다(gscm-3c 최종 판정 2026-10-27).
export const PLAN_DETAIL_INSERT_EDITABLE_COLUMNS = [
  'SHIPMENT_DATE',
  'SHIPMENT_CONFIRM_QTY',
  'TRANSPORT_MODE',
  'PACKAGE_TYPE',
  'FACTORY_ID',
  'DOM_EXP',
] as const;

// SO# 그룹 EDIT_MAIN 동기 트리거 컬럼 (03 §3.2 — 같은 ERP_SO_NO 전행 EDIT_MAIN='Y').
export const SO_GROUP_PROPAGATE_COLUMNS = [
  'TRANSPORT_MODE',
  'DOM_EXP',
  'FACTORY_ID',
  'PACKAGE_TYPE',
] as const;

// 신규행 필수(`*`) 컬럼 (03 §1.2 — 라벨 `*` 가 필수 원천, INPUT_TP_CD 전건 'S').
//   TRANSPORT_MODE 는 라벨 필수이나 콤보 미배선(§6-3) — 저장부 공백검증으로 재현.
export const PLAN_DETAIL_REQUIRED_COLUMNS = [
  'SHIPMENT_DATE',
  'SHIPMENT_CONFIRM_QTY',
  'PACKAGE_TYPE',
  'FACTORY_ID',
  'TRANSPORT_MODE',
] as const;

// PlanDetail Insert 복사 필드 — AS-IS InsertRow defaultData 명시 목록(03 §3.2 cs:1866~2033, 이전행 복제).
//   AS-IS defaultData.Add 순서 그대로 전건 복사한다(cs:1953~2019). 주석처리된 필드
//   (ERP_SO_NO/SHIPMENT_STATUS/EDIT_MAIN/ORIGIN_*/MERGE_NUM)는 신규행에 복사하지 않는다.
//   REMARKS='I'(Insert 마커)·ERP_STATUS=''(신규라 ERP 미생성)는 복사가 아닌 강제값이라
//   이 목록에서 빼고 handleInsert 가 별도 세팅한다(AS-IS cs:1899/1927).
//   ATTRIBUTE10 은 AS-IS defaultData 엔 없으나 TO-BE FACTORY_ID 파라미터 매핑용으로 유지한다.
export const PLAN_DETAIL_INSERT_COPY_COLUMNS = [
  'DIVISION_ID',
  'MODEL_ID',
  'MODEL_ID_NICK_NAME',
  'ITEM_ID',
  'ITEM_ID_NICK_NAME',
  'TO_SITE_DESCRIPTION',
  'DOM_EXP',
  'DAYOFWEEK_NAME',
  'SHIPMENT_DATE',
  'SHIPPING_PLAN_QTY',
  'SHIPMENT_CONFIRM_QTY',
  'GAP',
  'CONFIRM_QTY_ROLL_LENGTH',
  'PACKAGE_TYPE',
  'PACKAGE_QTY',
  'REMARKS2',
  'FACTORY_ID',
  'ELECTRODE_POST_OPER',
  'TRANSPORT_MODE',
  'CONFIRM_QTY_PANCAKE',
  'CONFIRM_QTY_JR',
  'CONFIRM_QTY_CELL',
  'CELL_TYPE',
  'FROM_SITE_DESCRIPTION',
  'REQUESTOR',
  'REMARKS3',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'INCOTERMS',
  'LT_DAY',
  'ETD',
  'ETA',
  'UPDATED_BY',
  'UPDATED_DATE',
  'CHANGE_REQ_NO',
  'MODEL_USER',
  'CONFIRM_ID',
  'FROM_SITE',
  'SOLDTO_DESCRIPTION',
  'SHIPTO_DESCRIPTION',
  'TO_SITE',
  'BOD_ID',
  'CHANGE_TYPE',
  'NEW_ROUTE_ID',
  'NEW_BOD_ID',
  'NEW_INCOTERMS',
  'NEW_D_COUNTRY',
  'NEW_D_PORT_CODE',
  'NEW_A_COUNTRY',
  'NEW_A_PORT_CODE',
  'NEW_CUSTOMER_LT',
  'NEW_TO_COUNTRY',
  'NEW_TO_CITY',
  'NEW_ETA',
  'NEW_ETD',
  'NEW_LT_DAY',
  'NEW_TRANSPORT_MODE',
  'NEW_SHIPMENT_DATE',
  'EDIT_REMARKS',
  'ELECTRODE_YN',
  'ELECTRODE_TYPE',
  'ATTRIBUTE10',
] as const;

// Detail Footer 합계 범위 — StockDetail 만 (anchor 다음 ~ break 직전) SumIgnoreHidden 집계(03 §3.4).
//   필수: AS-IS 는 InitSpreadFooterSum() 을 shtStockDetail 일 때만 호출한다(.cs:688 활성) — PlanDetail
//   (.cs:667)·PlanDetail_Excel(.cs:677)은 호출이 주석처리, ShipmentResult·메인그리드는 호출 자체가 없다.
//   함수 본문도 SheetName==shtStockDetail 로 다시 가드(.cs:5651). 따라서 footer 는 재고상세 한 시트뿐이다
//   (사용자 지시 2026-10-12 — AS-IS 정합). 맵에 없는 시트는 DetailGrid footer effect 가 range 없음으로
//   early-return 해 footer row 를 만들지 않는다.
export const FOOTER_SUM_RANGE: Partial<
  Record<SHEETS, { afterCol: string; beforeCol: string | null }>
> = {
  [SHEETS.STOCK_DETAIL]: { afterCol: 'CHANGE_STATUS', beforeCol: 'AVAILABLE_YN' },
};

// 엑셀 업로드 양식 필수 6컬럼 (03 §1.5 — 전건 필수 `*`)
export const EXCEL_REQUIRED_COLUMNS = [
  'DIVISION_ID',
  'COMPANY_ID',
  'FROM_SITE',
  'ITEM_ID',
  'YYYYMMDD',
  'QTY',
] as const;

// 엑셀 업로드 결과(오류) 그리드의 데이터 컬럼 라벨 — 업로드 SP 결과 O_CUR_LIST 의 ATTRIBUTE1..6 과
//   위치가 1:1 대응한다(ATTRIBUTE1 = 배열[0]). PKG_SSP0023.P_SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD 의
//   검증이 ATTRIBUTE1=DIVISION / 2=COMPANY / 3=FROM_SITE / 4=ITEM(Material) / 5=YYYYMMDD / 6=QTY
//   순으로 읽는다(ora.py 소스 실측 2026-10-14, 주석 "ATTRIBUTE1 = DIVISION" 등). 필수표시 '*' 는 제거.
export const EXCEL_UPLOAD_HEADER_LABELS = [
  'Div',
  'Company',
  'FromSite',
  'Material',
  'YYYYMMDD',
  'Qty',
] as const;

// ====================================================================================
// TO-BE MSG 코드 — SCM_ADM_MSG_M 문구 역조회 기준(SSP0060 전환 실측 재사용 — 동일 도메인 공통 메시지).
//   AS-IS 번호 답습 금지: 문구 의미 기준 매핑. 주석 = (AS-IS MSG) → TO-BE EN 문구.
// ====================================================================================
export const MSG = {
  // (MSG00189) ERP D/O 생성 행 편집 차단 → "ERP D/O has been created for the plan, so the plan cannot be changed."
  ERP_DO_BLOCK: 'MSG01401',
  // (AS-IS MSG00324 route 미등록) 저장결과 'X'(기준정보/BOD 미등록) 안내 — 자매 SSP0060·SSP0021 과 같은 MSG01321.
  STD_INFO_NOT_REGISTERED: 'MSG01321',
  // (MSG00278) 운송수단 등 필수값 → "{0} value is required."
  REQUIRED_VALUE: 'MSG00429',
  // (MSG00287) 변경사유코드 미선택 시 상세 입력 차단 → "Please enter Reason Code."
  REASON_CODE_FIRST: 'MSG01291',
  // (MSG00285/00286) 행별 변경사유 필수 → "There is a shipment change. Please enter Change_Reason."
  //   미사용: AS-IS 는 이 검증(MSG00285)을 주석처리하고 변경사유를 자동으로 'T07'(DEFAULT_CHANGE_REASON_CODE)
  //   세팅한다(cs:2949-2955). 사용자 입력을 강제하지 않으므로 알림을 띄우지 않는다. 카탈로그 참고용으로만 남김.
  ROW_REASON_REQUIRED: 'MSG01289',
  // (MSG00098) 팝업/저장 전 필수값 → "Please enter the required fields."
  REQUIRED_FIELDS: 'MSG00013',
  // (MSG00047) 조회결과 없음 → "No data has been inquired for this item."
  NO_DATA: 'MSG01244',
  // (MSG00007) Measure 설정 활성 그리드 없음 → "The grid is not ready."
  GRID_NOT_READY: 'MSG00284',
  // (MSG00312) 최신 아닌 Plan 편집 차단(EditButton 가드②) → "You can not edit the old Plan."
  OLD_PLAN_EDIT_BLOCK: 'MSG01185',
  // (MSG00084) Main 일자수량 음수 → "Quantity must be 0 or greater."
  NEGATIVE_QTY: 'MSG00225',
  // (AS-IS MSG00292) Simulation 저장 시 최신 Plan 아님 경고 — AS-IS 는 경고만 띄우고 저장은 계속 진행(cs:5949~5955, return 없음).
  //   문구 의미로 TO-BE 재매핑(ora.py 실측 2026-10-16, SCM_ADM_MSG_M) — Cutoff 컨테이너 수량 시뮬 미적용 경고.
  SIMU_NOT_APPLIED: 'MSG01295',
  // (MSG00324) Detail Confirm 저장 확인창 → "Are you sure you want to confirm the shipping plan change requests?"
  CONFIRM_SAVE: 'MSG01201',
  // (MSG00133) 변경 없음 → "No modifications have been made."
  NO_MODIFICATION: 'MSG00133',
  // 저장 변경 없음 표준 코드(MSG00133 은 TO-BE 미등록)
  NO_CHANGES: 'MSG00004',
  // (MSG00703) 미저장 변경 존재 시 재조회 확인 → "There are unsaved changes. Do you want to search again?"
  CONFIRM_RESEARCH_UNSAVED: 'MSG00703',
  // 저장 검증 — AS-IS 번호 답습 금지, 문구 의미로 TO-BE 재매핑(ora.py 실측 2026-10-16, SCM_ADM_MSG_M).
  //   (MSG00194) 출하일 D±기간 제한 → "Change requests are possible from the current D + {0} ship date."
  //     arg={0}=dDay(CHANGE_REQ_DAY NAME, -56). AS-IS Validation_Check cs:2895~2901 live(변종 cs:2887~2893 주석).
  DATE_OVER_MAX: 'MSG01206',
  //   (MSG00049) 유효하지 않은 날짜형식 → "This is not a valid date format. {0}". arg={0}=입력 날짜 문자열.
  //     AS-IS GetERPInterface cs:3123~3128 DateTime.TryParse 실패.
  INVALID_DATE_FORMAT: 'MSG01081',
  //   (MSG00286) 변경사항 없는데 사유 입력됨 → "{0}열 출하 변경사항이 없습니다.\n Change_Reason를 입력 할 수 없습니다."
  //     arg={0}=컬럼 헤더. AS-IS Validation_Check cs:3061 no-change branch. (MSG00285 입력요구는 주석=미이식.)
  REASON_WITHOUT_CHANGE: 'MSG01290',
  //   (MSG00325) Confirm Qty 0 PO 삭제 확인(Yes/No) → "Confirm Qty가 0인 PO가 삭제됩니다. 진행하시겠습니까?"
  //     AS-IS GetERPInterface cs:3136~3139 p_zero_count_chk>0. confirm=No 면 저장 abort.
  QTY_ZERO_PO_DELETE: 'MSG01322',
  // 저장 성공/실패 — 공용 훅 표준값. (success=MSG00002 "성공적으로 저장되었습니다" / fail=MSG00003 "저장에 실패하였습니다".)
  //   주의: 이전 세션이 "확정 SAVE SP 미배포"로 오판해 SAVE_NOT_DEPLOYED 안내로 저장을 종료했으나,
  //   PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM 는 실배포(VALID)다(ora.py 실측 2026-10-16). 실 저장 배선됨.
  SAVED: 'MSG00002',
  SAVE_FAILED: 'MSG00003',
  // 하단 저장 ERP 연쇄 사전검사 — AS-IS GetShipmentStatusChk(cs:3451~3514)·GetERPInterface(cs:3162~3200).
  //   AS-IS 002xx/004xx → TO-BE 코드는 자매 SSP0015 실측 매핑을 그대로 쓴다(SCM_ADM_MSG_M, 문구 동일).
  //   (MSG00248) 다른 사용자가 변경요청한 Confirm ID 존재. {0}=CONFIRM_ID 목록
  STATUS_OTHER_USER_REQUEST: 'MSG01258',
  //   (MSG00249) 확정계획이 삭제(Qty:0)된 Confirm ID 존재. {0}=CONFIRM_ID 목록
  STATUS_DELETED_QTY0: 'MSG01259',
  //   (MSG00189) ERP 에 DO 가 생성되어 변경요청 불가. {0}=CONFIRM_ID 목록
  STATUS_ERP_DO_CREATED: 'MSG01202',
  //   (MSG00247) 같은 SO 번호로 생성된 다른 건 존재 — SO 단위 일괄 변경 필요. {0}=SO NO
  SO_NO_COUNT_MISMATCH: 'MSG01257',
  //   (MSG00404) ERP I/F 로 이전 작업 2분 뒤 변경 가능(SCM_SSP_CHECK_CONFIRM_CHANGETIME 'X')
  CONFIRM_CHANGETIME_LOCK: 'MSG01395',
  // ERP 연쇄 단계 버튼 라우팅·권한 미등록 — "사용 권한이 없습니다." + 버튼 경로. 세 화면 공통 문구.
  //   (MSG00667 은 "권한을 가진 Division이 없습니다" 뜻이라 쓰지 않는다 — gscm-3c 확인 2026-10-27.)
  NO_BUTTON_AUTH: 'MSG01125',
  // (MSG00267) ERP 중단기간 — "하기 기간동안 ERP 시스템 중단으로 … 사용하실 수 없습니다." {0}=PERIOD.
  //   자매 SSP0060·SSP0200 과 같은 코드.
  ERP_BLOCK_PERIOD: 'MSG01275',
} as const;

// AS-IS chkERPIFBlockYn — Data_SCP.Common(SSPBlockCheckIF, false, "SSP0023")(cs:2769). 자매 SSP0060·SSP0200 과 같은 콤보.
export const ERP_BLOCK_COMBO = 'SSPBlockCheckIF_SCP';

// ====================================================================================
// 하단 Plan Detail 저장 ERP 연쇄 — AS-IS SaveData_Detail(cs:2512~2757) → GetERPInterface(cs:3122~3353)
//   → NonSoNo/SoNo(cs:3742~4176) → GetErpIFCheckNew(cs:4293~4405). 버튼코드·본문 키는
//   DB 의뢰 00_README "적용 후 FE 쪽에서 쓰는 키" 표와 proc_meta(2026-10-27) 그대로다.
// ====================================================================================
// 이미 등록(USE_YN='Y'): GET_SHIPMENT_STATUS(P_SSP0023_GET_STATUS)·GET_ERP_SO_NO_CNT(P_SSP0023_GET_SO_CNT)·
//   requestDraftingMain/SAVE(P_SSP0023_SAVE_DRAFTING)·DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM·ERP_ERROR_CONFIRM.
// 01 SQL 적용 후: CHECK_CONFIRM_CHANGETIME(SCM_SSP_CHECK_CONFIRM_CHANGETIME)·IF_CHECK(P_SSP0003_GET_IF_CHECK).
export const ERP_CHAIN_BTN = {
  GET_SHIPMENT_STATUS: 'GET_SHIPMENT_STATUS',
  GET_ERP_SO_NO_CNT: 'GET_ERP_SO_NO_CNT',
  CHECK_CONFIRM_CHANGETIME: 'CHECK_CONFIRM_CHANGETIME',
  IF_CHECK: 'IF_CHECK',
  DELETE_DRAFTING_BY_CONFIRM: 'DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM',
  ERP_ERROR_CONFIRM: 'ERP_ERROR_CONFIRM',
} as const;
// 변경요청 초안 — AS-IS SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING(cs:3846/4081). 시트명이 main 이 아니다.
export const DRAFTING_SHEET = 'requestDraftingMain';
export const DRAFTING_BTN = 'SAVE';

// ERP 실시간 송신 — AS-IS CallClient.FN_ERP_UIWebService(RequestNo, "C", "")(cs:4301). 자매 SSP0015 와 같은
//   BE 공통 창구(serviceKey=erpIf → nscm-if NSD0100). 응답 { E_TYPE, E_MESSAGE } = AS-IS RtFlag·ReErrorMsg.
export const ERP_IF_PATH = '/common/web-service/erpIf/call';
export const ERP_IF_CHANGE_TYPE = 'C';
export const ERP_IF_SUCCESS = 'S';
export const ERP_IF_ERROR = 'E'; // 전건 거절
export const ERP_IF_PARTIAL_ERROR = 'S_E'; // 일부 거절
export const ERP_IF_PI_FAIL = 'C_E'; // PI 호출 실패(CallClient catch)
// 초안 되돌림 고정값 — AS-IS cs:4333~4337
export const ERP_DELETE_FLAG = 'D';
export const ERP_IF_SEND_ON = 'Y';
export const ERP_ERROR_E_TYPE = 'E'; // AS-IS cs:3282
// 2차 적재 — AS-IS PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('B', REQ_NO)(cs:4355/4385) 대신
//   PKG_SSP0003.P_SSP0003_SAVE_REQ_IF_CHECK 를 빌린다(SSP0015 선례, changeStatus 'A' + changeType 'C' → V_STATUS 'B').
export const IF_CHECK_STATUS_APPLY = 'A';
export const IF_CHECK_PARTIAL_OFF = 'F';
// ERP 결과 안내 — AS-IS MSG00197/MSG00204 → TO-BE(자매 SSP0015 실측).
export const MSG_ERP = {
  ISSUE: 'MSG01208', // (MSG00197) RtFlag E/S_E, {0}=confirmId:msg 목록
  SYSTEM_ERROR: 'MSG01215', // (MSG00204) RtFlag F/C_E, {0}=Request No
} as const;

// ====================================================================================
// LBL — DB 실측 15건(02 §5-2) + 신규 6그룹(05_register.sql 등록 전 영문 fallback).
// ====================================================================================
export const LBL = {
  // 실측 존재 (02 §5-2)
  DIVISION: 'LBL00001',
  COMPANY: 'LBL00047',
  FROM_SITE: 'LBL00022',
  PLAN_DATE: 'LBL00039',
  BUCKET: 'LBL00710',
  MATERIAL: 'LBL00021',
  // MODEL: 'LBL00669',
  MODEL: 'LBL00618', // Model/Nickname 라벨 통일
  NICK_NAME: 'LBL00767',
  PERIOD: 'LBL00013',
  MY_MODEL: 'LBL01093',
  PART_LEADER: 'LBL01101',
  TEAM_LEADER: 'LBL01124',
  DELEGATEE_MODEL: 'LBL01070',
  RESULT_TYPE: 'LBL01109',
  REQUESTOR: 'LBL01108',
  // 공용 버튼/라벨 (SSP0060 재사용 실측)
  SEARCH: 'LBL00112', // 상단 SearchArea 검색(F5) — "Search(F5)"
  SEARCH_GRID: 'LBL00664', // 하위 detail bar 검색 — "Search" (자매 Mobility&IT 와 동일)
  EDIT: 'LBL00783',
  NEW: 'LBL01028',
  CLOSE: 'LBL00627',
  OK: 'LBL00716',
  MEASURE: 'LBL00310',
  SIMULATION: 'LBL01119', // btnSimulation — Main SIMU 저장 버튼(AS-IS 분리 버튼 복원, DB 실측 2026-10-16)
  EXCEL_FORM: 'LBL00762', // Excel Form (업로드 양식 다운로드 — 자매 SCP0005 실측)
  // Excel Upload 모달 라벨 (정본 distribution-route/SCP0005 와 동일 코드 — 공용 업로드 UI)
  EXCEL_UPLOAD: 'LBL00346',
  EXCEL_FILE: 'LBL00759',
  UPLOAD_RESULT: 'LBL00754',
  SUCCESS: 'LBL00755',
  ERROR: 'LBL00756',
  TOTAL: 'LBL00757',
  CANCEL: 'LBL00107',
  SHIPMENT_DATE: 'LBL01115',
  // DB 실측 매핑 (문구 기준 단일 매칭 — lbl-dict)
  SUM: 'LBL00687', // Sum
  BOH_UOM: 'LBL01126', // rdButton1 (UOM)
  BOH_CELL: 'LBL01059', // rdButton2 (Cell)
  BOH_PCM: 'LBL01099', // rdButton3 (Pancake m)
  LOT_ID: 'LBL01090', // drpPeriod2/3 Shipment Date · Lot ID
  UOM_TYPE: 'LBL01127', // usrLabel1 "UOM Type" (BOH 3-radio 그룹 라벨)
  // 미매칭 — 05_register.sql 등록 전 영문 fallback (defaultValue 로 커버)
  PAST_PERIOD: 'LBL_SSP0023_PAST_PERIOD',
} as const;

// BOH 3-radio 라벨 매핑 (01 §1 조회조건 영역 / 03 §2.1 동작). RadioGroup 미제공(@shared)이라
//   Button 배타토글로 재현 — 활성 radio 만 contained/primary. rdButton→span(X/Y/Z)은 activeSpanOf.
export const BOH_RADIO_ITEMS: { radio: BOH_RADIO; lbl: string; fallback: string }[] = [
  { radio: BOH_RADIO.GENERAL, lbl: LBL.BOH_UOM, fallback: 'UOM' },
  { radio: BOH_RADIO.CELL, lbl: LBL.BOH_CELL, fallback: 'Cell' },
  { radio: BOH_RADIO.PCM, lbl: LBL.BOH_PCM, fallback: 'Pancake m' },
];

// 저장결과 'X' → MSG01321 '예' 시 여는 SSP 기준정보 매뉴얼 — AS-IS AddHelpButton("Standard Information SSP Manual")
//   (BaseForm.cs L3501→FileDownLoad L3406)은 사내 Help 서버의 구 매뉴얼(구)SCM 화면 내용)을 받았으나, 신 매뉴얼을
//   FE 정적 호스팅(nscm-fe/public/manual/)에 동봉해 제공한다. 자매 SSP0060·SSP0021·SSP0022 상수와 같은 값.
export const STANDARD_MANUAL_URL = encodeURI('/manual/Standard Information SSP Manual.pptx');
