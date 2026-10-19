export const MENU_ID = 'SSP0022' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0022_ShipmentRequestElectrode (4시트: spdMain 피벗 + spdDetail 2탭(요청상세/재고상세)
//   + spdSub 엑셀전용). 설계 근거: .atlas/gscm-design/SSP0022/design/00_checklist.md ~ 03_grid-columns.md.
//   - GET  SP (4): PKG_SSP0022.P_SSP0022_GET_SHIPMENT_PSI / P_SSP0022_GET_REQUEST_DETAIL /
//     P_SSP0022_GET_STOCK_DETAIL / P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
//   - SAVE SP    : PKG_SSP0022.P_SSP0022_SAVE_SHIPMENT_REQUEST (spdMain/spdDetail 공용, 호출 컨텍스트로 분기)
//   - 보조 SP    : P_SSP0022_GET_SHEET_CALENDAR_3SPAN(동적 pivot 헤더) / P_SSP0022_GET_ITEM_POPUP(BOD/Item 팝업)
//     / P_SSP0022_GET_BOD_ITEM_VALID_CHECK(현재 호출부 비활성 — dead code, 신규 구현 보류)
//   - 콤보 SP    : PKG_DM0003.P_DM0003_GET_BUCKET_TYPE_CODE(Bucket Type) / PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST(Edit 권한체크)
//   - SP 미배포(design 00 §0 / goal.md): PKG_SSP0022·PKG_DM0003·PKG_SSP0002 all_objects 0건
//     → 런타임 조회/저장/권한체크/Bucket 콤보 전부 실행체인 미완(convert-sp 후속). FE 배선만 완비한다.
export enum SHEETS {
  MAIN = 'main', // spdMain — Shipment Request(Electrode), pivot 34칼럼 + 동적 X_/Y_/Z_×D_/W_/M_
  REQUEST_DETAIL = 'requestDetail', // spdDetail.shtRequestDetail — 요청상세, 31칼럼, 유일한 편집 대상
  STOCK_DETAIL = 'stockDetail', // spdDetail.shtStockDetail — 재고상세, 29칼럼, 읽기전용
  REQUEST_DETAIL_EXCEL = 'requestDetailExcel', // spdSub.shtRequestDetail_Excel — 엑셀 다운로드 전용, 9칼럼
  SPREAD_TITLE = 'spreadTitle', // P_SSP0022_GET_SHEET_CALENDAR_3SPAN — 동적 기간 헤더(3-span)
  BOD_ITEM_POPUP = 'bodItemPopup', // SSP0022_BodItemPopup 원천(P_SSP0022_GET_ITEM_POPUP)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  REQUEST_DETAIL: 'o_rc1',
  STOCK_DETAIL: 'o_rc1',
  REQUEST_DETAIL_EXCEL: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  BOD_ITEM_POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 원본명 그대로(design 03 §1).
//   실측(ora.py, 2026-09-26): 4개 SHEET_NAME 103행 전건 배포 완료(34+31+29+9).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Request(Electrode)',
  [SHEETS.REQUEST_DETAIL]: 'Shipment Request Detail',
  [SHEETS.STOCK_DETAIL]: 'Stock Detail',
  [SHEETS.REQUEST_DETAIL_EXCEL]: 'Shipment Request Detail Excel',
};

// Measure 정의(SCM_MST_SHEET_MEASURE, PROGRAM_ID=SSP0022, SHEET_NAME=ADMIN_SHEET_NAME.MAIN) — 10건 실측 배포됨.
//   design 03 §1.5 — R_SHIP_REQ_ETA 는 코드 특별분기(lock 범위·BackColor) 대상.
export const MEASURE = {
  SCP_PROD_PLAN: 'R_SCP_PROD_PLAN',
  SCP_SHIP_PLAN_ETA: 'R_SCP_SHIP_PLAN_ETA',
  SHIP_REQ_ETA: 'R_SHIP_REQ_ETA',
  FP_NPC_ASSY_PLAN: 'R_FP_NPC_ASSY_PLAN',
  FP_COATER_PLAN: 'R_FP_COATER_PLAN',
  FP_COATER_POST_PLAN: 'R_FP_COATER_POST_PLAN',
  SHIP_PLAN_ETD: 'R_SHIP_PLAN_ETD',
  INTRANSIT_ETA: 'R_INTRANSIT_ETA',
  INV_SHIP_REQ: 'R_INV_SHIP_REQ',
  INV_SHIP_PLAN: 'R_INV_SHIP_PLAN',
} as const;

// 조회조건 콤보 SQL_ID (design 02 §2 — TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y').
//   cascade: Division(필터) → Company(재조회 PlantSite/PlanDate).
export const COMBO = {
  DIVISION: 'MyDivision', // ATTRIBUTE3<>'EE' 내장(확실성 높음, design 02 §2.2)
  COMPANY: 'Div_CompanyEE_SCP', // OPERATION_GROUP='E'+@divisionId(확실성 높음)
  PLANT_SITE: 'PlantEE', // OPERATION_GROUP='E'+OSP_YN='N' 내장(재사용 판정 완료, convert-core §2.6 5층 대조 PASS)
  PLAN_DATE: 'Plan_InforElectrode_SCP', // CURRENT_PLAN_DATE_YN='Y'+@companyId
  CELL_TYPE: 'CellTypeGr_SCP', // 확실성 중간(design 02 §2.2 — convert 단계 반환값 대조 권고, 확인 필요로 유지)
  // 신규행 FROM_SITE/TO_SITE 셀콤보 — admin PARAM9 미배선 확인(design 03 §1.6). 옵션(b) FE 직접조회 채택
  //   (AS-IS 도 InsertRow() 코드에서 직접 Data.Common 호출 — admin PARAM9 경로 자체가 AS-IS에 없었다).
  CELL_FROM_SITE: 'PlantByElectordeShipFromSite',
  CELL_TO_SITE: 'PlantByElectordeShipToSite',
  CELL_INCOTERMS: 'Incoterms',
  CELL_TRANSPORT_MODE: 'TransportMode',
} as const;

// 팝업 트리거 버튼 → 대상 텍스트 필드 (design 02 §4.6).
//   btnModelId(#27) 는 AS-IS Click 핸들러 미배선(dead button 의심) — TO-BE 신규 팝업 미신설(사용자 확인 대상).
export const SEARCH_POPUP = {
  ITEM_ID: 'ITEM_ID_1', // btnItemId → SCM0002_ItembyDivisionPopup → txtItemId
  ITEM_ID_2: 'ITEM_ID_2', // btnItemID2 → SCM0002_ItembyDivisionPopup → txtItemId2
  REQUESTOR: 'REQUESTOR', // btnRequestor → UserInfoPopup → txtRequestor
} as const;

// EDIT_FLAG 값에 따른 요청상세 편집가능 컬럼 범위 분기(design 01 R10 / 03 §3 규칙#11).
//   N(신규 미확정행) = REQUEST_DATE만 / 그외 = SHIPMENT_DATE + REQUESTOR~REQUEST_DATE 범위.
export const REQUEST_DETAIL_EDIT_COLUMNS_BY_FLAG: Readonly<Record<'N' | 'DEFAULT', readonly string[]>> = {
  N: ['REQUEST_DATE'],
  DEFAULT: ['SHIPMENT_DATE', 'REQUESTOR', 'REQUEST_DATE'],
};

// Insert(신규행) 직후 편집불가(lock) 5컬럼(design 01 R6 / 03 §3 규칙#8, cs:1466-1470).
export const INSERT_LOCK_COLUMNS: readonly string[] = [
  'MODEL_ID',
  'NICK_NAME',
  'DIVISION_ID',
  'REQUESTOR',
  'REQUEST_DATE',
];

// Insert 시 편집 가능(콤보 배선 대상) 2컬럼 — FROM_SITE/TO_SITE(design 03 §1.6).
export const INSERT_EDITABLE_COMBO_COLUMNS: readonly string[] = ['FROM_SITE', 'TO_SITE'];

// 그리드 셀 콤보 컬럼(요청상세, design 03 §1.2 FPComboBox 2 + 런타임 부여 2).
export const CELL_COMBO_COLUMNS = ['INCOTERMS', 'TRANSPORT_MODE', 'FROM_SITE', 'TO_SITE'] as const;

// 동적 pivot 컬럼 태그 패턴 — X_/Y_/Z_(BOH표시모드) × D_/W_/M_(Bucket) × yyyyMMdd(design 03 §2.2).
export const DYNAMIC_COLUMN_TAG_PATTERN = /^([XYZ])_([DWM])_(\d{8})$/;

// rdButton(BOH 표시모드) → 동적컬럼 태그 접두 매핑(design 01 R4 / 03 §2.2).
export const BOH_MODE_PREFIX = {
  rdButton1: 'X',
  rdButton2: 'Y',
  rdButton3: 'Z',
} as const;
export type BohMode = keyof typeof BOH_MODE_PREFIX;

// rdButton 3-way 합계컬럼 세트(design 01 R4 매핑표) — 9칼럼×3세트 중 1세트만 노출.
export const BOH_SUM_COLUMN_SETS: Readonly<Record<BohMode, readonly string[]>> = {
  rdButton1: ['TOT_BOH_QTY', 'JR_BOH_QTY', 'PC_BOH_QTY'],
  rdButton2: ['TOT_BOH_QTY_PCM', 'JR_BOH_QTY_PCM', 'PC_BOH_QTY_PCM'],
  rdButton3: ['TOT_BOH_QTY_CELL', 'JR_BOH_QTY_CELL', 'PC_BOH_QTY_CELL'],
};

export const BUCKET_TYPE = {
  DAILY: 'D',
  WEEKLY: 'W',
  MONTHLY: 'M',
} as const;

// TO-BE MSG 코드 — SCM_ADM_MSG_M 문구 역조회로 확정된 항목만(Hook #114). AS-IS 번호(MSG00251/312/042/324 등)는
//   ora.py 실측 결과 TO-BE 에 존재하지 않는다(2026-09-26 확인, 0행) — "확인 필요"로 남기고 임의 채번하지 않는다.
export const MSG = {
  // 공용 확인된 코드만 등재. 나머지(Edit 권한없음/bRealFlag 불일치/저장확인/저장결과 S·N·X 등)는
  //   TO-BE 정확 대응 ID 미확정 — 화면 코드에서 영문 리터럴 fallback으로 처리하고 04_react-gap.md 에 명시.
} as const;
