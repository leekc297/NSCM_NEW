export const MENU_ID = 'SSP0021' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0021_ShipmentPlan (Shipment Plan, 6,557줄 정본 — 00_checklist.md §0):
//   설계 근거: .atlas/gscm-design/SSP0021/design/00_checklist.md ~ 03_grid-columns.md, 매핑 __asis-mapping__.md
//   - 자매 SSP0060(Shipment Plan(Auto & ESS))과 동일 계열 화면(PSI pivot + SCP0009 3span + bucket +
//     멀티시트 detail + drill-down). 다만 SSP0021 은 Product Level·Tot PSI 가 없고, Main 직접 저장이
//     없다(편집 SHIP_PLAN → Simulation → Detail Confirm 저장, design 03 §4.1 / 01 §2 SaveData_Detail).
//   - Main 동적 컬럼: 서버 wide pivot(D_/W_/M_) + calendar 시트(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)
//     3단 헤더 메타. 편집 대상 measure = SHIP_PLAN(design 03 §1.2 편집 유일).
//   - Division/Company = 전용 SP 2-cursor(P_SSP0021_GET_SHIPMENT_DIVISION — VP UNION·NERP 제외·81_UC
//     제외를 서버에서 재현. design 02 §7-1 의 "전용 콤보" 격차를 배포된 GET SP 로 해소, 04_react-gap §2).
//   - 편집 화이트리스트: shtPlanDetail 7컬럼(design 03 §3). Hold stock 은 AS-IS 임시 hold(표시전용) —
//     TO-BE PKG 에 SAVE/Detail SP 미배포(goal.md ②) → 편집 미구현.
//   - 툴바 5버튼: Find/Save/Insert = 실동작, Delete = NO-OP `() => undefined`(design 01 §2 확정 — 재판단 금지),
//     Edit = 미이식(convert-core §2.4 — 편집 기본 ON, canEdit=hasButton('EDIT')).
export enum SHEETS {
  MAIN = 'main', // spdMain "Shipment Plan" (PSI pivot)
  DIVISION = 'division', // P_SSP0021_GET_SHIPMENT_DIVISION 2-cursor (Division/Company — 콤보 레지스트리 아님)
  CALENDAR = 'calendar', // PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (3단 헤더 메타)
  PLAN_DETAIL = 'planDetail', // shtPlanDetail "Shipment Plan Detail" (69컬럼, 편집 7)
  STOCK_DETAIL = 'stockDetail', // "Stock Location Detail" (20컬럼, 읽기전용)
  OWMS_DETAIL = 'owmsDetail', // "oWMS Detail" (25컬럼, 읽기전용)
  HOLD_STOCK = 'holdStock', // "Hold stock" (12컬럼, 표시전용 — SAVE SP 미배포)
  MES_STOCK = 'mesStock', // "MES Stock" (9컬럼, 읽기전용)
  MES_STOCK_DETAIL = 'mesStockDetail', // "MES Stock Detail" (13컬럼, 읽기전용)
  SHIPMENT_RESULT = 'shipmentResult', // "Shipment Result" (18컬럼, 읽기전용)
}

// NSCM cursor 표준 — Main/division 은 2-cursor.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  DIVISION_LIST: 'o_rc1',
  COMPANY_LIST: 'o_rc2',
  CALENDAR: 'o_rc1',
  DETAIL: 'o_rc1',
} as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측 9 sheetNm(191컬럼) 그대로 (design 03 §1).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Plan',
  [SHEETS.PLAN_DETAIL]: 'Shipment Plan Detail',
  [SHEETS.STOCK_DETAIL]: 'Stock Location Detail',
  [SHEETS.OWMS_DETAIL]: 'oWMS Detail',
  [SHEETS.HOLD_STOCK]: 'Hold stock',
  [SHEETS.MES_STOCK]: 'MES Stock',
  [SHEETS.MES_STOCK_DETAIL]: 'MES Stock Detail',
  [SHEETS.SHIPMENT_RESULT]: 'Shipment Result',
};

// 컬럼 개인화/Measure 저장 구분값 (조회/저장/복원 3점 일치 필수, np §5-9)
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// ====================================================================================
// 조회조건 콤보/lookup (design 02 §2 — SCM_ADM_CMBO_SQL_M 실측). cascade 전량 재조회 방식(02 §3).
//   Division/Company 는 콤보가 아니라 2-cursor GET SP(SHEETS.DIVISION) — 아래 COMBO 에 없음.
// ====================================================================================
export const COMBO = {
  FROM_SITE: 'Com_FromSite_SCP', // @divisionId @companyId → clbPlantSite (다중, 전극·제외company SQL 내재)
  PLAN_INFOR: 'Plan_Infor_SCP', // @companyId → cboPlanDate (CODE/NAME/FROM_DATE/TO_DATE/TO_DATE1/PLAN_YN)
  BUCKET_TYPE: 'BucketType', // lookup BUCKET_TYPE_CODE (기본 DAILY, 02 §2-4)
  // Requestor 사용자검색 — AS-IS UserInfoPopup(SystemManager DB)은 접근 불가로 원문 실측 실패.
  //   §2.3 임의 등록 금지 — 등록 전까지 팝업 목록은 빈 리스트(메타 정비 대기, 04_react-gap.md 확인필요).
  REQUESTOR_USER: 'SSP0021_UserInfoList',
  // Simulation Container 단위수량 (AS-IS Data_SCP.Common(Container_Size) — SCP 접미 규약, design 02 §2.3).
  CONTAINER_SIZE: 'Container_Size_SCP',
} as const;

export const LOOKUP = {
  SHIPMENT_RESULT_TYPE: 'SSP_SHIPMENT_RESULT_TYPE', // clbResultType (VALID_YN='Y' = P/O/E/R, design 02 §2-6)
} as const;

// Detail 셀 콤보 — CELL_COMBO_DATA_TYPE(SQL_ID) + @lookupType (design 03 §6-1/2).
//   ATTRIBUTE1(=@lookupType) 이 DB 상 공란이라 공용 DataGrid 자동 셀콤보가 @lookupType 를 싣지 못한다
//   → 코드 원문 노출/필수 사유 선택불가(저장 차단). 화면이 useTabComboQueries 로 @lookupType 를 직접 실어
//   조회한 뒤 col.dataMap 으로 주입한다([[grid-cell-combo-lookuptype-token-not-transmitted]], SSP0014 패턴).
//   CMBO SQL 실측: CHANGE_REASON_CODE_ALL = '-' 선두행 + CODE/NAME('CODE : 명'), LookupCommon = CODE/명,
//   LookupCommon3 = CODE/'CODE : 명'. 전건 WHERE LOOKUP_TYPE=@lookupType.
export const CELL_COMBO = {
  LOOKUP_COMMON: 'LookupCommon', // 표시전용 코드→명 (SHIPMENT_STATUS/FCST_TYPE)
  LOOKUP_COMMON3: 'LookupCommon3', // 표시전용 (oWMS STOCK_STATUS)
  CHANGE_REASON_CODE_ALL: 'CHANGE_REASON_CODE_ALL', // 편집 콤보 ('-' 포함, 필수 사유)
} as const;

export const CELL_LOOKUP_TYPE = {
  SHIPMENT_STATUS: 'SHIPMENT_STATUS', // Shipment Plan Detail SHIPMENT_STATUS (4코드)
  SALES_TYPE_CODE: 'SALES_TYPE_CODE', // Shipment Plan Detail FCST_TYPE (14코드)
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE', // Shipment Plan Detail CHANGE_REASON_CODE (편집 필수)
  // oWMS STOCK_STATUS — DB LOOKUP_TYPE 부재(0행, design 03 §6-2 확인필요). 주입하되 빈 목록이면 원문 노출.
  STOCK_STATUS: 'STOCK_STATUS',
} as const;

// Bucket Type — AS-IS cboBucketType (BucketType lookup BUCKET_TYPE_CODE 3코드). PSI 화면 기본 Daily.
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

export const ALL = 'ALL';
export const PROGRAM_ID = MENU_ID;

// drpPeriod3(Shipment Date, ShipmentResult 전용) 기본 = 오늘-9 ~ 오늘-1 (AS-IS ShipmentResult_GetDayRange, 02 §2)
export const PERIOD3_FROM_OFFSET = -9;
export const PERIOD3_TO_OFFSET = -1;

// ====================================================================================
// 편집 화이트리스트 (design 03 §1.3/§3 — DB INPUT_TP_CD 전건 'S'(잠금)라 코드 상수로 재현.
//   admin 메타(INPUT_TP_CD) 정비 시 이 상수를 제거하고 메타 기준으로 전환할 것, 03 §5-5)
// ====================================================================================
// Shipment Plan Detail — SHIPMENT_STATUS=='C' && ERP_STATUS!='C' 행만 unlock (design 03 §3.3)
export const PLAN_DETAIL_EDITABLE_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'REMARKS',
  'REMARKS2',
] as const;

// SO그룹 전파 대상 (design 03 §3.2 — ERP_SO_NO 동일 행 전파)
export const SO_GROUP_PROPAGATE_COLUMNS = PLAN_DETAIL_EDITABLE_COLUMNS;

// PlanDetail Insert 복사 필드 — AS-IS InsertRow defaultData(design 01 §2 InsertButton).
//   ERP_SO_NO/SHIPMENT_STATUS 등은 신규행에 복사하지 않는다. SHIPMENT_CONFIRM_QTY=0/ERP_STATUS='' 는 handleInsert 강제.
export const PLAN_DETAIL_INSERT_COPY_COLUMNS = [
  'DIVISION_ID',
  'ITEM_ID',
  'NICK_NAME',
  'PROJECT_CODE',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'REMARKS',
  'REMARKS2',
  'FROM_SITE',
  'TO_SITE',
  'CONFIRM_ID',
  'FCST_TYPE',
] as const;

// Detail Footer 합계 범위 (design 03 §1.4~1.10 — 시트별 anchor 다음 ~ break 직전 수치 구간 집계)
export const FOOTER_SUM_RANGE: Partial<
  Record<SHEETS, { afterCol: string; beforeCol: string | null }>
> = {
  [SHEETS.STOCK_DETAIL]: { afterCol: 'STORAGE_DESCRIPTION', beforeCol: 'WIPHOLD_YN' },
  [SHEETS.OWMS_DETAIL]: { afterCol: 'PALLET_ID', beforeCol: 'PACKING_STATUS' },
  [SHEETS.HOLD_STOCK]: { afterCol: 'RELEASE_YYYYMMDD', beforeCol: 'REMARKS' },
  [SHEETS.MES_STOCK]: { afterCol: 'NICK_NAME', beforeCol: null },
  [SHEETS.MES_STOCK_DETAIL]: { afterCol: 'LOTID', beforeCol: 'PROD_VALID_DATE' },
  [SHEETS.SHIPMENT_RESULT]: { afterCol: 'END_CUSTOMER', beforeCol: 'YYYYMMDD' },
};

// Main 편집 대상 행 판정 (design 03 §1.2/§2.3): MEASURE=='SHIP_PLAN'(편집 유일) + D_ 일자창
export const MAIN_EDITABLE_MEASURE = 'SHIP_PLAN';

// ====================================================================================
// TO-BE MSG 코드 — SCM_ADM_MSG_M 문구 역조회(Hook #114). AS-IS 번호 답습 금지.
//   자매 SSP0060 이 동일 의미로 역조회한 TO-BE 코드를 재사용(문구 = i18n 공용, 화면 비종속).
// ====================================================================================
export const MSG = {
  // (MSG00189) ERP DO 생성 행 편집 차단
  ERP_DO_BLOCK: 'MSG01401',
  // (MSG00278) 운송수단 필수
  REQUIRED_VALUE: 'MSG00429',
  // (MSG00287) 변경사유코드 미선택 시 상세 입력 차단
  REASON_CODE_FIRST: 'MSG01291',
  // (MSG00285) 행별 변경사유 필수
  ROW_REASON_REQUIRED: 'MSG01289',
  // (MSG00098) 팝업/조회 전 필수값
  REQUIRED_FIELDS: 'MSG00013',
  // (MSG00007) Measure 설정 활성 그리드 없음
  GRID_NOT_READY: 'MSG00284',
  // (MSG00324) Detail Confirm 저장 확인창
  CONFIRM_SAVE: 'MSG01201',
  // (MSG00133) 변경 없음
  NO_MODIFICATION: 'MSG00133',
  // (MSG00703) 미저장 변경 존재 시 재조회 확인
  CONFIRM_RESEARCH_UNSAVED: 'MSG00703',
  // 저장 성공/실패 — 공용 훅 표준값
  SAVED: 'MSG00002',
  SAVE_FAILED: 'MSG00003',
  // (MSG00251) R7a Edit 진입 가드① — GSCM 미등록 사용자. 자매 SSP0060 이 역조회한 코드를 재사용한다.
  //   번들 실측(EN/KO.json): "This user does not have permission to the SSP Planner.\n\rUser ID : {0}"
  //   / "SSP Planner 권한이 없는 사용자 입니다 .\n\rUser ID : {0}" — {0} 는 수동 치환 자리다.
  NO_AUTHORITY: 'MSG01261',
} as const;

// ====================================================================================
// 버튼 코드 — SCM_ADM_MNU_BTN_MPG_M 의 MNU_BTN_CD. 둘 다 SHT_NM='main' 으로 등록한다.
//   자매 SSP0060 실등록 실측(ora.py): main/USER_CHECK -> P_SSP0200_USER_CHECK,
//   main/GET_ORDER_DETAIL -> P_SSP0300_GET_ORDER_DETAIL. 두 API_ID 는 **화면 비종속 공용**이라
//   SCM_ADM_API_M 에 이미 등록돼 있다(신규 등록 불요 — 실측 확인).
//   SSP0021 분 버튼매핑·권한 등록: .atlas/gscm-design/SSP0021/design/21_register_sibling_port_btn_auth.sql
// ====================================================================================
/** R7a 사용자 체크(AS-IS GetSSPUserCheck) — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST. */
export const USER_CHECK_BTN = 'USER_CHECK';
/** ERP Order Detail 팝업(AS-IS SSP0300_OrderDetailPopup) — P_SSP0300_GET_ORDER_DETAIL. */
export const ORDER_DETAIL_BTN = 'GET_ORDER_DETAIL';

// ====================================================================================
// LBL — DB 실측(design 02 §4.5, 전건 존재 — 신규 0건)
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001',
  COMPANY: 'LBL00047',
  FROM_SITE: 'LBL00022',
  MODEL: 'LBL00669',
  // 1차·2차 Model 검색박스 라벨 — 팝업이 Model Code 뿐 아니라 Nickname 으로도 검색되는 것을
  //   라벨에 드러낸다(사용자 지시 2026-10-12). LBL00618 은 DB 기등록 코드이고 SCM_ADM_MSG_M 실측상
  //   KO/EN/CN 3개 언어 모두 'Model/Nickname' 이라 신규 등록이 필요 없다(public/locales 에도 기존재).
  //   자매 SSP0060 도 Form·DetailBar 양쪽에 같은 코드를 쓴다(shipment-plan.constants.ts MODEL_NICKNAME).
  MODEL_NICKNAME: 'LBL00618',
  PERIOD: 'LBL00013',
  PLAN_DATE: 'LBL00039',
  REQUESTOR: 'LBL01108',
  RESULT_TYPE: 'LBL01109',
  SHIPMENT_DATE: 'LBL01115',
  BOX_ID: 'LBL01057',
  BUCKET: 'LBL00710',
  SUM: 'LBL00687',
  MEASURE: 'LBL00310',
  SEARCH: 'LBL00112',
  CLOSE: 'LBL00627',
  OK: 'LBL00716',
  SIMULATION: 'LBL01119',
  LOT_ID: 'LBL01090',
} as const;
