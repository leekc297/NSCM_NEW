export const MENU_ID = 'SSP0017' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

// admin UI Category Setup 의 SHEET_NAME 은 AS-IS 원본명 그대로(design/03_grid-columns.md §0 —
//   'Inventory Raw(Mobility & IT)' 단일 시트, 중복 등록된 'Inventory Raw(IT & Mobile)' 는 미사용).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Inventory Raw(Mobility & IT)',
};

// clbDivision.ControlValues="40" 고정 + Enabled=false(design/02_search-combo.md §4).
export const DIVISION_FIXED = '40';

export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  // Plant Site 는 Division 값의 'EE' 포함 여부로 SQL_ID 2종 상호배타 스위칭(design 02 §3#1).
  PLANT_SITE_NON_EE: 'ShipmentRequestPlantSite_SCP',
  PLANT_SITE_EE: 'ShipmentPlanPlantSite_SCP',
} as const;

export const LOOKUP = {
  // AS-IS Data.Common(Type.LookupCommon, false, "INV_TYPE") — useTabLookupQueries 로 직접 조회
  //   (LookupCommon 콤보 브리지와 동일 원천, shipment-model-pic OPERATION_GROUP 선례와 동일 패턴).
  INVENTORY_TYPE: 'INV_TYPE',
} as const;

// 확인 필요(FAIL 후보, design/02_search-combo.md §2 주1 · §7 요약): AS-IS `PlanDateShip` 콤보와
// 의미가 일치하는 TO-BE SQL_ID 가 SCM_ADM_CMBO_SQL_M 에 없다. 이름이 비슷한 `PlanDateShipReq40_SCP`
// 는 호출 계열(_SCP 접미)·원천 테이블(SSP_MST_SHIP_REQ)이 달라 재사용 금지(convert-core §2.6).
// AS-IS MSSQL(asis.py) 접속도 이번 세션 ERROR(로그인 타임아웃)라 원본 SQL 대조 불가 — 신규 등록
// 전까지 목록 데이터 없이 빈 슬롯만 렌더한다(임의 SQL_ID 대체 금지, anti-simplification §1).
export const PLAN_DATE_COMBO_UNRESOLVED = true;

// Footer 합계 대상 5컬럼(design/03_grid-columns.md §3 규칙#9 — SPECIAL_YN 다음 ~ CUSTOMER 이전).
//   SCM_MST_SHEET_COLUMNS 에는 집계 여부 자체가 없어(DB 메타는 컬럼 정의만) 화면에서 후처리로 얹는다.
export const AGGREGATE_COLUMNS = [
  'STOCK_QTY',
  'AVAILABLE_QTY',
  'HOLD_QTY',
  'LONG_QTY',
  'EXPIRATION_QTY',
] as const;

export const MSG = {
  // AS-IS DataUtil.checkRequiredOfSearch(cs:377) — "Plan-date*" 필수조건 공백 alert.
  //   SCM_ADM_MSG_M 역조회(ora.py, 2026-09-26): MSG00614 = "The {0} value is required."(EN, PASS).
  REQUIRE_PLAN_DATE: 'MSG00614',
} as const;
