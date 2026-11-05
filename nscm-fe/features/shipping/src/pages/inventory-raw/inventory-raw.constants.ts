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
  // Plan Date — AS-IS `Data.Common(Data.Type.PlanDateShip, false, pDivisionID)`
  //   (SSP0017_InventoryRaw.cs:365, param2=shipPlanType 미전달)와 **동일 SQL_ID**.
  //   SCM_ADM_CMBO_SQL_M 실측(ora.py, 2026-10-14): SQL_ID='PlanDateShip', USE_YN='Y',
  //   바인드 @shipPlanType·@divisionId — 'P' 면 SSP_ANL_SHIP_PLAN_P(Packer), 그 외면
  //   SSP_PLAN_VERSION_V 를 @divisionId 토큰으로 걸러 PLAN_START_YYYYMMDD 를 내린다.
  //   AS-IS 가 param2 를 안 넘기므로 비-'P' 분기가 정답 — 자매 SSP0015/shipment-plan-mobility-it
  //   의 Main 분기와 같은 'A' 를 명시한다(convert-core §2.6 이름유사 재사용 아님, 동명 실측).
  PLAN_DATE: 'PlanDateShip',
} as const;

export const LOOKUP = {
  // AS-IS Data.Common(Type.LookupCommon, false, "INV_TYPE") — useTabLookupQueries 로 직접 조회
  //   (LookupCommon 콤보 브리지와 동일 원천, shipment-model-pic OPERATION_GROUP 선례와 동일 패턴).
  INVENTORY_TYPE: 'INV_TYPE',
} as const;

// Plan Date 콤보 미결(design/02_search-combo.md §2 주1 · §7)은 **해소됨**(ora.py 실측 2026-10-14):
//   SCM_ADM_CMBO_SQL_M 에 AS-IS 와 동명인 `PlanDateShip`(USE_YN='Y')이 실재하고 본문도
//   PLAN_START_YYYYMMDD 를 @divisionId 로 거르는 AS-IS 등가다 → COMBO.PLAN_DATE 로 배선했다.
//   설계 당시 "없음" 판정은 `PlanDateShipReq40_SCP`(원천 SSP_MST_SHIP_REQ, 별개 콤보)만 보고
//   내린 것으로, 동명 SQL_ID 를 놓친 오판이었다. 그 사이 화면은 콤보가 빈 목록·disabled 라
//   Plan Date 필수검증(handleSearch)에 걸려 조회 자체가 불가능했다.

// Footer 합계 대상 5컬럼(design/03_grid-columns.md §3 규칙#9 — SPECIAL_YN 다음 ~ CUSTOMER 이전).
//   SCM_MST_SHEET_COLUMNS 에는 집계 여부 자체가 없어(DB 메타는 컬럼 정의만) 화면에서 후처리로 얹는다.
export const AGGREGATE_COLUMNS = [
  'STOCK_QTY',
  'AVAILABLE_QTY',
  'HOLD_QTY',
  'LONG_QTY',
  'EXPIRATION_QTY',
] as const;

// i18n 코드 — SCM_ADM_MSG_M 문구 역조회 TO-BE 코드(lbl-dict 대조). AS-IS 번호 그대로 쓰지 말 것.
//   value = LBL 코드, 사용처는 t(LBL.KEY, '_Fallback').
export const LBL = {
  DIVISION: 'LBL00001', // Div.
  // From Site(=AS-IS 'Plant Site' 라벨 변경, 사용자 결정 2026-10-30) — 콤보 원천·동작
  //   (ShipmentRequestPlantSite_SCP/ShipmentPlanPlantSite_SCP)·필드(plantSiteIds)·SP 파라미터(p_plant_site)는
  //   Plant Site 그대로, **표시 라벨만 From Site** 로 바꾼다. DMF0045(shipment-request) 2026-10-29 선례와
  //   동일 규약(LBL00022='From Site', KO/EN 로케일 실측). 기존 LBL00005('Plant Site')에서 교체.
  FROM_SITE: 'LBL00022', // From Site
  INVENTORY_TYPE: 'LBL01087', // Inventory Type
  // Model/Nickname — 입력값이 ITEM_ID 와 NICK_NAME 양쪽에 매칭되므로 라벨도 둘을 모두 알린다.
  //   LBL00618 'Model/Nickname' — SCM_ADM_MSG_M KO/EN/CN 전건 등록·USE_YN='Y' 실측(ora.py 2026-10-14)
  //   이라 등록 요청 불요. 기존 LBL00669 는 'Model' 단독이라 교체(SSP0019 2026-10-14 선례와 동일 규약).
  MODEL_NICKNAME: 'LBL00618',
  PLAN_DATE: 'LBL00039', // Plan Date
  SEARCH: 'LBL00112', // 메인 상단 SearchArea 검색 버튼
  MEASURE: 'LBL00310', // Measure 버튼
} as const;

export const MSG = {
  // AS-IS DataUtil.checkRequiredOfSearch(cs:377) — "Plan-date*" 필수조건 공백 alert.
  //   SCM_ADM_MSG_M 역조회(ora.py, 2026-09-26): MSG00614 = "The {0} value is required."(EN, PASS).
  REQUIRE_PLAN_DATE: 'MSG00614',
} as const;
