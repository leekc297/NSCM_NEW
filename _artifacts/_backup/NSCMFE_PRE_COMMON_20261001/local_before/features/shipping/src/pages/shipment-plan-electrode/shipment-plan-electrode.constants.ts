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
//   - 툴바: Find/Insert/Save = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지·행삭제 불가), Edit = SwitchLock 미이식(edit default ON).
//   - 초안작성/확정 SAVE SP 는 PKG 미배포(§6-1) → 배선 보류·미완 표기(convert-sp 후속). siMain 시뮬레이션 저장 SAVE_SHIPMENT_PLAN_SIMU 는 배포됨.
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
} as const;

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
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'CONFIRM_QTY_PANCAKE',
  'CONFIRM_QTY_JR',
  'CONFIRM_QTY_CELL',
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
//   여기 없는 필드(ERP_SO_NO/SHIPMENT_STATUS 등)는 신규행에 복사하지 않는다(전 필드 스프레드 금지).
//   SHIPMENT_CONFIRM_QTY=0, ERP_STATUS='' 강제는 handleInsert 가 별도 적용.
export const PLAN_DETAIL_INSERT_COPY_COLUMNS = [
  'DIVISION_ID',
  'MODEL_ID',
  'ITEM_ID',
  'ITEM_ID_NICK_NAME',
  'TO_SITE_DESCRIPTION',
  'TO_SITE',
  'DOM_EXP',
  'DAYOFWEEK_NAME',
  'SHIPMENT_DATE',
  'SHIPPING_PLAN_QTY',
  'PACKAGE_TYPE',
  'PACKAGE_QTY',
  'REMARKS2',
  'REMARKS',
  'FACTORY_ID',
  'ELECTRODE_POST_OPER',
  'TRANSPORT_MODE',
  'CELL_TYPE',
  'FROM_SITE_DESCRIPTION',
  'FROM_SITE',
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
  'CONFIRM_ID',
  'MODEL_USER',
  'ATTRIBUTE10',
] as const;

// Detail Footer 합계 범위 — 시트별 (anchor 다음 ~ break 직전) SumIgnoreHidden 집계(03 §3.4 SetAggregationFormat).
export const FOOTER_SUM_RANGE: Partial<
  Record<SHEETS, { afterCol: string; beforeCol: string | null }>
> = {
  [SHEETS.PLAN_DETAIL]: { afterCol: 'DAYOFWEEK_NAME', beforeCol: 'PACKAGE_TYPE' },
  [SHEETS.STOCK_DETAIL]: { afterCol: 'CHANGE_STATUS', beforeCol: 'AVAILABLE_YN' },
  [SHEETS.SHIPMENT_RESULT]: { afterCol: 'END_CUSTOMER', beforeCol: 'YYYYMMDD' },
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

// ====================================================================================
// TO-BE MSG 코드 — SCM_ADM_MSG_M 문구 역조회 기준(SSP0060 전환 실측 재사용 — 동일 도메인 공통 메시지).
//   AS-IS 번호 답습 금지: 문구 의미 기준 매핑. 주석 = (AS-IS MSG) → TO-BE EN 문구.
// ====================================================================================
export const MSG = {
  // (MSG00189) ERP D/O 생성 행 편집 차단 → "ERP D/O has been created for the plan, so the plan cannot be changed."
  ERP_DO_BLOCK: 'MSG01401',
  // (MSG00278) 운송수단 등 필수값 → "{0} value is required."
  REQUIRED_VALUE: 'MSG00429',
  // (MSG00287) 변경사유코드 미선택 시 상세 입력 차단 → "Please enter Reason Code."
  REASON_CODE_FIRST: 'MSG01291',
  // (MSG00285/00286) 행별 변경사유 필수 → "There is a shipment change. Please enter Change_Reason."
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
  // (MSG00324) Detail Confirm 저장 확인창 → "Are you sure you want to confirm the shipping plan change requests?"
  CONFIRM_SAVE: 'MSG01201',
  // (MSG00133) 변경 없음 → "No modifications have been made."
  NO_MODIFICATION: 'MSG00133',
  // (MSG00703) 미저장 변경 존재 시 재조회 확인 → "There are unsaved changes. Do you want to search again?"
  CONFIRM_RESEARCH_UNSAVED: 'MSG00703',
  // 초안/확정 SAVE SP 미배포 안내 (§6-1) — 배선 보류를 명시 안내
  SAVE_NOT_DEPLOYED: 'MSG00003',
  // 저장 성공/실패 — 공용 훅 표준값
  SAVED: 'MSG00002',
  SAVE_FAILED: 'MSG00003',
} as const;

// ====================================================================================
// LBL — DB 실측 15건(02 §5-2) + 신규 6그룹(05_register.sql 등록 전 영문 fallback).
// ====================================================================================
export const LBL = {
  // 실측 존재 (02 §5-2)
  DIVISION: 'LBL00641',
  COMPANY: 'LBL00047',
  FROM_SITE: 'LBL00022',
  PLAN_DATE: 'LBL00039',
  BUCKET: 'LBL00710',
  MATERIAL: 'LBL00021',
  MODEL: 'LBL00669',
  NICK_NAME: 'LBL00767',
  PERIOD: 'LBL00013',
  MY_MODEL: 'LBL01093',
  PART_LEADER: 'LBL01101',
  TEAM_LEADER: 'LBL01124',
  DELEGATEE_MODEL: 'LBL01070',
  RESULT_TYPE: 'LBL01109',
  REQUESTOR: 'LBL01108',
  // 공용 버튼/라벨 (SSP0060 재사용 실측)
  SEARCH: 'LBL00664',
  EDIT: 'LBL00783',
  NEW: 'LBL01028',
  CLOSE: 'LBL00627',
  OK: 'LBL00716',
  MEASURE: 'LBL00310',
  SHIPMENT_DATE: 'LBL01115',
  // 신규 6그룹 — 05_register.sql 등록 전 영문 fallback (defaultValue 로 커버)
  SUM: 'LBL_SSP0023_SUM',
  PAST_PERIOD: 'LBL_SSP0023_PAST_PERIOD',
  BOH_UOM: 'LBL_SSP0023_BOH_UOM', // rdButton1 (일반 UOM)
  BOH_CELL: 'LBL_SSP0023_BOH_CELL', // rdButton2 (Cell)
  BOH_PCM: 'LBL_SSP0023_BOH_PCM', // rdButton3 (Pancake m)
  LOT_ID: 'LBL_SSP0023_LOT_ID', // drpPeriod2/3 Shipment Date · Lot ID
} as const;
