export const MENU_ID = 'SSP0015' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0015_ShipmentPSI (Shipment Plan(Mobility & IT), 9,856줄 정본 — 00_checklist §0):
//   설계 근거: .atlas/gscm-design/SSP0015/design/00_checklist.md ~ 03_grid-columns.md, 매핑 __asis-mapping__.md.
//   - master PSI pivot(2 시트: 일반 Mobility&IT / Packer) = 측정치×기간(D_/W_/M_/B_ 서버 wide) + detail 다중 sheet.
//   - Division 은 '40' 고정(disabled) — 검색 SP p_division_id 항상 '40'(design 02 §2.1).
//   - Plant Site 는 master 활성시트별 comboId 스왑(Main=ShipmentRequestPlantSite_SCP / Packer=FromSiteByDivisionOspPack).
//   - 편집 화이트리스트(design 03 §3) — DB INPUT_TP_CD 336건 전건 'S' 갭(#A)이라 코드 화이트리스트로 재현.
//   - 툴바 5버튼(Find/Insert/Delete/Save/Edit) 전부 실동작(NO-OP 없음, 00 §4d) — EditButton 모드토글은 미이식(편집 기본 ON).
export enum SHEETS {
  MAIN = 'main', // spdMain 일반 "Shipment PSI(Mobility & IT)" (PSI pivot) — P_SSP0015_GET_SHIPMENT_PSI
  MAIN_PACKER = 'mainPacker', // spdMain Packer "Shipment PSI(Packer)" — P_SSP0015_GET_SHIPMENT_PSI_PACKER
  CALENDAR = 'calendar', // PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (3단 헤더 메타)
  CONFIRM_DETAIL = 'confirmDetail', // shtDetail "Shipment Confirm Detail" (72열, 편집) — GET/SAVE_SHIPMENT_REQUEST_CONFIRM_40
  HOLD_STOCK = 'holdStock', // "Hold stock" (12열, 편집 insert) — GET_BLOCK_STOCK / SAVE_BLOCK_STOCK_DATA
  MES_STOCK = 'mesStock', // "MES Stock Detail" (24열, 편집) — GET_MES_STOCK / SAVE_MES_STOCK
  WH_STOCK = 'whStock', // "W/H stock" (19열, 읽기전용) — GET_WH_STOCK
  SCS_STOCK = 'scsStock', // "SCS Stock Detail" (9열, 읽기전용) — GET_SCS_STOCK
  STOCK_LOCATION_DETAIL = 'stockLocationDetail', // "Stock Location Detail" (20열, 읽기전용) — GET_STOCK_LOCATION_DETAIL
  SHIPMENT_RESULT = 'shipmentResult', // "Shipment Result" (19열, 읽기전용) — GET_SHIPMENT_RESULT
}

// NSCM cursor 표준 — main 은 3-cursor(o_rc1 PSI). 나머지는 o_rc1.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  CALENDAR: 'o_rc1',
  DETAIL: 'o_rc1',
} as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측 그대로 (design 03 §1, ora.py 2026-09-27).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment PSI(Mobility & IT)',
  [SHEETS.MAIN_PACKER]: 'Shipment PSI(Packer)',
  [SHEETS.CONFIRM_DETAIL]: 'Shipment Confirm Detail',
  [SHEETS.HOLD_STOCK]: 'Hold stock',
  [SHEETS.MES_STOCK]: 'MES Stock Detail',
  [SHEETS.WH_STOCK]: 'W/H stock',
  [SHEETS.SCS_STOCK]: 'SCS Stock Detail',
  [SHEETS.STOCK_LOCATION_DETAIL]: 'Stock Location Detail',
  [SHEETS.SHIPMENT_RESULT]: 'Shipment Result',
};

// 컬럼/Measure 개인화 저장 구분값 (SCM_MST_TITLESET_USER)
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// Division 고정값 (design 02 §2.1 — clbDivision.ControlValues='40' + Enabled=false)
export const FIXED_DIVISION = '40';

// ====================================================================================
// 조회조건 콤보/lookup (design 02 §2·§5 — SCM_ADM_CMBO_SQL_M 실측, ora.py 2026-09-27)
//   cascade 전량 재조회(Filter 없음, 02 §3) — 트리거는 master 활성시트(searchParams 바깥).
// ====================================================================================
export const COMBO = {
  // Plant Site — master 활성시트별 스왑 (design 02 §2.2). 이름유사 재사용 금지(convert-core §2.6).
  PLANT_SITE_MAIN: 'ShipmentRequestPlantSite_SCP', // @divisionId @operationGroup='P' @param3='E' (Pack·전극 제외)
  PLANT_SITE_PACKER: 'FromSiteByDivisionOspPack', // @divisionId @__GROUP__ @sesUserId(BE주입) (OSP Pack)
  BUCKET: 'BucketType', // lookup BUCKET_TYPE_CODE — AS-IS 완전 일치(DM0003_GET_BUCKET_TYPE_CODE)
  // Plan Date — AS-IS PlanDateShip(A/P) 미등록. Main("A")은 PlanDate 등가(design 02 §2.4).
  //   Packer("P")=SSP_ANL_SHIP_PLAN_P 등가는 미등록(확인필요·04_react-gap.md).
  PLAN_DATE: 'PlanDate', // @divisionId (+versionId 선택)
} as const;

export const LOOKUP = {
  SHIPMENT_RESULT_TYPE: 'SSP_SHIPMENT_RESULT_TYPE', // clbResultType (P/O/E/R 4행 — design 02 §2.6)
} as const;

// Bucket Type — 기본 Daily. AS-IS cboBucketType(DM0003_GET_BUCKET_TYPE_CODE 3코드).
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// Result Type 시트별 클라 행제거(design 02 §2.6) — Main [P,O,E] / Packer [P,R].
export const RESULT_TYPE_BY_SHEET = {
  MAIN: ['P', 'O', 'E'],
  PACKER: ['P', 'R'],
} as const;

export const ALL = 'ALL';
export const PROGRAM_ID = MENU_ID;

// drpPeriod/2 초기범위 offset (design 02 §2.5 — SCM0001_GET_SCP_DAY_PERIOD offset 31, Packer -1일)
export const PERIOD_OFFSET_DAY = 31;
// drpPeriod3(ShipmentResult 전용) 기본 = 오늘-9 ~ 오늘-1 (AS-IS ShipmentResult_GetDayRange)
export const PERIOD3_FROM_OFFSET = -9;
export const PERIOD3_TO_OFFSET = -1;

// ====================================================================================
// 편집 화이트리스트 (design 03 §3 — DB INPUT_TP_CD 전건 'S' 갭#A라 코드 상수로 재현.
//   admin 메타(INPUT_TP_CD) 정비 시 이 상수를 제거하고 메타 기준으로 전환)
// ====================================================================================
// Shipment Confirm Detail(shtDetail) — SHIPMENT_STATUS=='C' && ERP_STATUS!='C' 행만 unlock (03 §3.A/B)
export const CONFIRM_DETAIL_EDITABLE_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'REMARKS2',
  'REMARKS',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
] as const;

// SO그룹 전파 대상 (03 §3.B — ERP_SO_NO 동일 행 전파)
export const SO_GROUP_PROPAGATE_COLUMNS = CONFIRM_DETAIL_EDITABLE_COLUMNS;

// Hold stock — Edit 모드 전행 unlock 3컬럼 (design 03 §1.E)
export const HOLD_STOCK_EDITABLE_COLUMNS = ['RELEASE_YYYYMMDD', 'HOLD_QTY', 'REMARKS'] as const;

// MES Stock Detail — 편집 컬럼(design 03 §1.E — USER_MOD_RELEASE_DATE·REMARKS)
export const MES_STOCK_EDITABLE_COLUMNS = ['USER_MOD_RELEASE_DATE', 'REMARKS'] as const;

// master 편집 대상 측정치 (design 03 §1.A/§3.A) — MEASURE=='WH_IN' 행의 D_ 기간셀만 편집
export const MAIN_EDITABLE_MEASURE = 'WH_IN';

// ====================================================================================
// MSG — SCM_ADM_MSG_M 문구 역조회 실측 대상(Hook #114). 미역조회분은 AS-IS 번호 보존 + defaultValue fallback.
//   주의: SSP0060 이 역조회한 코드 다수는 재사용 가능하나, 이 화면 전용 재조회는 04_react-gap.md 확인필요로 남긴다.
// ====================================================================================
export const MSG = {
  // (MSG00007) Measure 활성 그리드 없음
  GRID_NOT_READY: 'MSG00284',
  // (MSG00084) Main 일자수량 음수
  NEGATIVE_QTY: 'MSG00225',
  // (MSG00133) 변경 없음
  NO_MODIFICATION: 'MSG00133',
  // (MSG00098) 팝업 오픈 전 필수값
  REQUIRED_FIELDS: 'MSG00013',
  // (MSG00278) 운송수단 필수
  REQUIRED_VALUE: 'MSG00429',
  // (MSG00287) 변경사유코드 미선택
  REASON_CODE_FIRST: 'MSG01291',
  // (MSG00286) 행별 변경사유 필수
  ROW_REASON_REQUIRED: 'MSG01289',
  // (MSG00251) SSP 사용자 미등록(Edit 가드 R7a)
  NO_AUTHORITY: 'MSG00667',
  // (MSG00170) 최신 아닌 Plan 편집 차단(Edit 가드 R7b)
  OLD_PLAN_EDIT_BLOCK: 'MSG01185',
  // (MSG00324) Detail Confirm 저장 확인창
  CONFIRM_SAVE: 'MSG01201',
  // (MSG00109) 읽기전용 sheet 편집 거부
  READONLY_SHEET: 'MSG00284',
  // 저장 성공/실패 — 공용 훅 표준값
  SAVED: 'MSG00002',
  SAVE_FAILED: 'MSG00003',
} as const;

// ====================================================================================
// LBL — SCM_ADM_MSG_M 실측(design 02 §4.5 — 전 라벨 매칭 존재, 신규 등록 0건).
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00641',
  PLANT_SITE: 'LBL00005',
  BUCKET: 'LBL00710',
  SUM: 'LBL00687',
  PLAN_DATE: 'LBL00039',
  PERIOD: 'LBL00013',
  ITEM: 'LBL01142',
  MODEL: 'LBL00669',
  LOT_ID: 'LBL01090',
  REQUESTOR: 'LBL01108',
  MY_MODEL: 'LBL01093',
  PART_LEADER: 'LBL01101',
  TEAM_LEADER: 'LBL01124',
  DELEGATEE: 'LBL01070',
  RESULT_TYPE: 'LBL01109',
  SHIPMENT_DATE: 'LBL01115',
  MEASURE: 'LBL00310',
  SEARCH: 'LBL00664',
  EDIT: 'LBL00783',
} as const;
