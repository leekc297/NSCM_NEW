export const MENU_ID = 'SSP0060' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0060_ShipmentPlan (Shipment Plan, 8,036줄 정본 — 00_checklist.md §0):
//   설계 근거: .atlas/gscm-design/SSP0060/design/00_checklist.md ~ 03_grid-columns.md, 매핑 __asis-mapping__.md
//   - 듀얼 그리드: Main(PSI pivot, 18 base + D_/W_/M_ 동적) + Detail 8-sheet (탭 전환 + 2차 조회조건 필드셋 6갈래).
//   - Main 동적 컬럼: TO-BE SP 가 서버 pivot(wide) 으로 반환(PKG BODY L3376~3495 실측) — 클라 pivot 불요.
//     3단 헤더 메타는 calendar 시트(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) 별도 조회.
//   - 편집 화이트리스트 10컬럼(Detail 7 + HoldStock 3, design 03 §1) — DB INPUT_TP_CD 전건 'S' 갭(#1)이라
//     코드 화이트리스트로 재현. admin 이 INPUT_TP_CD 를 정비하면 메타 기준으로 전환한다.
//   - 툴바 5버튼: Find/Save/Insert/Edit = 실동작, Delete = NO-OP `() => undefined` (00 §4d 확정 — 재판단 금지).
export enum SHEETS {
  MAIN = 'main', // spdMain "Shipment Plan" (PSI pivot)
  DIVISION = 'division', // P_SSP0060_GET_SHIPMENT_DIVISION 2-cursor (Division/Company — 콤보 레지스트리 아님)
  CALENDAR = 'calendar', // PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (3단 헤더 메타)
  PLAN_DETAIL = 'planDetail', // shtPlanDetail "Shipment Plan Detail" (71컬럼, 편집 7)
  STOCK_DETAIL = 'stockDetail', // "Stock Location Detail" (20컬럼, 읽기전용)
  OWMS_DETAIL = 'owmsDetail', // "oWMS Detail" (25컬럼, 읽기전용)
  HOLD_STOCK = 'holdStock', // "Hold stock" (12컬럼, 편집 3)
  MES_STOCK = 'mesStock', // "MES Stock" (9컬럼, 읽기전용)
  MES_STOCK_DETAIL = 'mesStockDetail', // "MES Stock Detail" (13컬럼, 읽기전용)
  SHIPMENT_RESULT = 'shipmentResult', // "Shipment Result" (16컬럼, 읽기전용)
  CONFIRM_DETAIL = 'confirmDetail', // 팝업 공용 GET (GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING)
  REQUEST_DRAFTING_MAIN = 'requestDraftingMain', // Request 팝업 실행 (SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN)
}

// NSCM cursor 표준 — Main/division/confirmDetail 은 2-cursor.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  DIVISION_LIST: 'o_rc1',
  COMPANY_LIST: 'o_rc2',
  CALENDAR: 'o_rc1',
  DETAIL: 'o_rc1',
} as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측 9 sheetNm 그대로 (design 03 §1).
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

// 컬럼 개인화/Measure 저장 구분값 (SCM_MST_TITLESET_USER — 조회/저장/복원 3점 일치 필수, §5-9)
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// ====================================================================================
// 조회조건 콤보/lookup (design 02 §2 — SCM_ADM_CMBO_SQL_M 4건 전건 배포 실측, ora.py 2026-09-25)
//   cascade 전량 재조회 방식(Filter 없음, 02 §3) — 재조회 응답에 클라 축 필터 금지.
// ====================================================================================
export const COMBO = {
  FROM_SITE: 'Com_FromSite_SCP', // @divisionId @companyId → clbPlantSite (다중)
  TO_SITE: 'ShipmentPlanToSite_SCP', // @divisionId @__GROUP__(session.groupId) @sesUserId(BE주입) → Detail TO_SITE 셀콤보용
  PLAN_INFOR: 'Plan_Infor_SCP', // @companyId → cboPlanDate (CODE/NAME/FROM_DATE/TO_DATE/TO_DATE1/PLAN_YN)
  CELL_GROUP: 'CellGroup_SCP', // @divisionId (@itemId @nickName 미전달='') → ProductLevel11/12 동시
  // Requestor 사용자검색 — AS-IS UP_FX_GetUserInfoList(SystemManager DB)는 접근 불가로 원문 실측 실패.
  //   §2.3 임의 등록 금지 — 등록 전까지 팝업 목록은 빈 리스트(메타 정비 대기, 04_react-gap.md 확인필요).
  REQUESTOR_USER: 'SSP0060_UserInfoList',
  // Simulation Container 단위수량 (AS-IS Data_SCP.Common(Container_Size) L7488 — SCP 접미 규약).
  //   반환 DIVISION_ID/FROM_SITE/ITEM_ID/CONTAINER_QTY — 등록 여부는 ora.py 실측(04_react-gap.md).
  CONTAINER_SIZE: 'Container_Size_SCP',
} as const;

export const LOOKUP = {
  SHIPMENT_RESULT_TYPE: 'SSP_SHIPMENT_RESULT_TYPE', // clbResultType (6코드 실측 — 02 §2-D)
} as const;

// Bucket Type — AS-IS cboBucketType (DM0003_GET_BUCKET_TYPE_CODE 3코드). PSI 화면 기본 Daily.
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

export const ALL = 'ALL';
export const PROGRAM_ID = MENU_ID;

// drpPeriod3(Shipment Date, ShipmentResult/MES 전용) 기본 = 오늘-9 ~ 오늘-1 (AS-IS ShipmentResult_GetDayRange L7943)
export const PERIOD3_FROM_OFFSET = -9;
export const PERIOD3_TO_OFFSET = -1;

// ====================================================================================
// 편집 화이트리스트 (design 03 §1 — DB INPUT_TP_CD 전건 'S' 갭#1이라 코드 상수로 재현.
//   admin 메타(INPUT_TP_CD) 정비 시 이 상수를 제거하고 메타 기준으로 전환할 것)
// ====================================================================================
// Shipment Plan Detail — Edit 모드에서 SHIPMENT_STATUS=='C' && ERP_STATUS!='C' 행만 unlock (03 §3-F)
export const PLAN_DETAIL_EDITABLE_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'REMARKS2',
  'REMARKS',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
] as const;

// Hold stock — Edit 모드에서 전행 unlock 3컬럼 (03 §1.3)
export const HOLD_STOCK_EDITABLE_COLUMNS = ['RELEASE_YYYYMMDD', 'HOLD_QTY', 'REMARKS'] as const;

// SO그룹 전파 대상 (03 §3-B/C — ERP_SO_NO 동일 행 전파 7컬럼)
export const SO_GROUP_PROPAGATE_COLUMNS = PLAN_DETAIL_EDITABLE_COLUMNS;

// PlanDetail Insert 복사 필드 — AS-IS InsertRow defaultData 명시 목록 그대로(L2644~2692, gap-audit I6).
//   여기 없는 필드는 신규행에 복사하지 않는다 — 특히 ERP_SO_NO/SHIPMENT_STATUS/SOLDTO/SHIPTO/
//   PROJECT_NAME/ELECTRODE_*/ORIGIN_* 는 AS-IS 가 복사하지 않는다(전 필드 스프레드 복사 금지).
//   SHIPMENT_CONFIRM_QTY=0, ERP_STATUS='' 강제는 handleInsert 가 별도 적용.
export const PLAN_DETAIL_INSERT_COPY_COLUMNS = [
  'DIVISION_ID',
  'ITEM_ID',
  'NICK_NAME',
  'TO_SITE_DESCRIPTION',
  'PROJECT_CODE',
  'SHIPMENT_DATE',
  'REMARKS2',
  'REMARKS',
  'TRANSPORT_MODE',
  'FROM_SITE_DESCRIPTION',
  'REQUESTOR',
  'REMARKS3',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'INCOTERMS',
  'LT_DAY',
  'ETD',
  'ETA',
  'FCST_TYPE',
  'UPDATED_BY',
  'UPDATED_DATE',
  'CHANGE_REQ_NO',
  'CONFIRM_ID',
  'FROM_SITE',
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
] as const;

// Detail Footer 합계 범위 — AS-IS InitSpreadFooterSum(L764~853): 시트별 (anchor 다음 컬럼 ~ break 직전)
//   구간에 SumIgnoreHidden 집계. afterCol=null 은 전 컬럼 시작, beforeCol=null 은 끝까지.
export const FOOTER_SUM_RANGE: Partial<
  Record<SHEETS, { afterCol: string; beforeCol: string | null }>
> = {
  [SHEETS.PLAN_DETAIL]: { afterCol: 'FCST_TYPE', beforeCol: 'SHIPMENT_DATE' },
  [SHEETS.STOCK_DETAIL]: { afterCol: 'STORAGE_DESCRIPTION', beforeCol: 'WIPHOLD_YN' },
  [SHEETS.OWMS_DETAIL]: { afterCol: 'PALLET_ID', beforeCol: 'PACKING_STATUS' },
  [SHEETS.HOLD_STOCK]: { afterCol: 'RELEASE_YYYYMMDD', beforeCol: 'REMARKS' },
  [SHEETS.MES_STOCK]: { afterCol: 'NICK_NAME', beforeCol: null },
  [SHEETS.MES_STOCK_DETAIL]: { afterCol: 'LOTID', beforeCol: 'PROD_VALID_DATE' },
  [SHEETS.SHIPMENT_RESULT]: { afterCol: 'END_CUSTOMER', beforeCol: 'YYYYMMDD' },
};

// Main 편집 대상 행 판정 (03 §3-F): MEASURE=='SHIP_PLAN_DETAIL' && TO_SITE 비공백 + D_ 일자창
export const MAIN_EDITABLE_MEASURE = 'SHIP_PLAN_DETAIL';

// chkTotPSI 행 필터 (03 §2.3): 미체크 SEQ<12 / 체크 SEQ<21
export const TOT_PSI_SEQ_LIMIT = { OFF: 12, ON: 21 } as const;

// ====================================================================================
// TO-BE MSG 코드 — SCM_ADM_MSG_M 문구 역조회 실측(ora.py 2026-09-25, Hook #114).
//   AS-IS 번호 답습 금지: AS-IS 22개 MSG 중 TO-BE 동일 의미 존재는 5건뿐, 나머지는 문구 기준 재매핑.
//   각 항목 주석 = (AS-IS MSG) → TO-BE EN 실측 문구.
// ====================================================================================
export const MSG = {
  // (MSG00189) ERP DO 생성 행 편집 차단 → "ERP D/O (Delivery Order) has been created for the plan, so the SSP plan cannot be changed."
  ERP_DO_BLOCK: 'MSG01401',
  // (MSG00278) 운송수단 필수 → "{0} value is required."
  REQUIRED_VALUE: 'MSG00429',
  // (MSG00287) 변경사유코드 미선택 시 상세 입력 차단 → "Please enter Reason Code."
  REASON_CODE_FIRST: 'MSG01291',
  // (MSG00285/00286) 행별 변경사유 필수 → "There is a shipment change in {0} row.\n\rPlease enter Change_Reason."
  ROW_REASON_REQUIRED: 'MSG01289',
  // (MSG00098) 팝업 오픈 전 필수값 → "Please enter the required fields."
  REQUIRED_FIELDS: 'MSG00013',
  // (MSG00047) 조회결과 없음 가드 → "No data has been inquired for this item."
  NO_DATA: 'MSG01244',
  // (MSG00007) Measure 설정 활성 그리드 없음 → "The grid is not ready."
  GRID_NOT_READY: 'MSG00284',
  // (MSG00251) SSP 사용자 미등록(Edit 가드①) → "No authority assigned."
  NO_AUTHORITY: 'MSG00667',
  // (MSG00170/00312) 최신 아닌 Plan 편집 차단(Edit 가드②/④) → "You can not edit the old Plan."
  OLD_PLAN_EDIT_BLOCK: 'MSG01185',
  // (MSG00424) 다른 그리드 편집 중(Edit 가드③) → "You can not proceed in edit mode."
  OTHER_GRID_EDITING: 'MSG01274',
  // (MSG00084) Main 일자수량 음수 → "Quantity must be 0 or greater."
  NEGATIVE_QTY: 'MSG00225',
  // (MSG00425) 편집불가 구간 합계 미만 입력 경고 → "A value smaller than the actual quantity cannot be entered."
  BELOW_LOCKED_QTY: 'MSG00666',
  // (MSG00292) Simulation Real 모드 아님(경고 후 계속 진행) → "Cutoff Container Qty does not apply simulation."
  SIMULATION_NOT_REAL: 'MSG01295',
  // (MSG00313) PlanDate 최신 불일치 → "The changed Plan Date exists."
  PLAN_DATE_CHANGED: 'MSG01315',
  // (MSG00324) Detail Confirm 저장 확인창 → "Are you sure you want to confirm the shipping plan change requests?"
  CONFIRM_SAVE: 'MSG01201',
  // (MSG00133) 변경 없음 → "No modifications have been made." (TO-BE 동일 문구 존재)
  NO_MODIFICATION: 'MSG00133',
  // (MSG00703) 미저장 변경 존재 시 재조회 확인 → "There are unsaved changes. Do you want to search again?"
  //   UI 공통(통합테스트) UC-02 — EditTracker.hasChanges() 기준 재조회 가드
  CONFIRM_RESEARCH_UNSAVED: 'MSG00703',
  // 저장 성공/실패 — 공용 훅 표준값
  SAVED: 'MSG00002',
  SAVE_FAILED: 'MSG00003',
} as const;

// ====================================================================================
// LBL — DB 실측 10건 + 신규 2건(05_register.sql 로 등록: LBL01144 Product Level1 / LBL01145 Tot PSI)
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001',
  COMPANY: 'LBL00047',
  FROM_SITE: 'LBL00022',
  MODEL: 'LBL00669',
  PERIOD: 'LBL00013',
  PLAN_DATE: 'LBL00039',
  REQUESTOR: 'LBL01108',
  RESULT_TYPE: 'LBL01109',
  SHIPMENT_DATE: 'LBL01115',
  BOX_ID: 'LBL01057',
  BUCKET: 'LBL00710',
  SUM: 'LBL00687',
  MEASURE: 'LBL00310',
  NEW: 'LBL01028',
  SEARCH: 'LBL00112',
  EDIT: 'LBL00783',
  CLOSE: 'LBL00627',
  OK: 'LBL00716',
  SIMULATION: 'LBL01119',
  REQUEST: 'LBL00620',
  TITLE: 'LBL01125',
  PRODUCT_LEVEL1: 'LBL01144', // 신규 — 05_register.sql 등록 전 영문 fallback
  TOT_PSI: 'LBL01145', // 신규
} as const;
