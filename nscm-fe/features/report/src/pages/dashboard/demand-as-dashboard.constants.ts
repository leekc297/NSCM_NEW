export const MENU_ID = 'DMD0001' as const;
export type MENU_ID = typeof MENU_ID;

// 조회조건 Div 콤보 — SCP0114(Line Master)와 동일 처리.
//   Division_SCP = 권한필터 변형(AS-IS Data_SCP.Common(Type.Division)). mnuId 필수.
//   base 'Division'(권한필터 없음·NAME 미반환) 재사용 금지 — convert-core §2.6.
export const COMBO = {
  DIVISION: 'Division_SCP',
  // Biz Type — SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='DM_BIZ_TYPE'), CODE/NAME = CELL/PACK/MODULE. 파라미터 없음.
  BIZ_TYPE: 'DM_BIZ_TYPE',
  // OEM(End Customer) — @divisionId 필터(@sesUserId 는 BE 주입). Div=81 고정 전달.
  END_CUSTOMER: 'EndCustomerByDivision',
  // 기준월 — SCP0055(shipment-allo-report)의 gap date 콤보를 재사용. @divisionId 필터(Div=81 고정 전달).
  //   CODE=PLAN_START_YYYYMMDD(기준 주차 시작일 8자리), NAME='YYYY-MM-DD (W##)'. 라벨은 '기준월' 유지하되
  //   값은 월(YYYY-MM)이 아니라 실 주차 시작일(YYYYMMDD)이다 — buildBaseFilters 가 그대로 P_YYYYMMDD 로 넘긴다.
  BASE_DATE: 'DATE_WEEKLY',
} as const;

// 플래그(사용자 결정 2026-11-24): 콤보 '옵션'은 데이터화(위 SP)했으나, 드롭다운이 proc 로 보내는
//   '값 토큰'(예 BizType=CELL vs proc 샘플 'Module')은 실 proc 필터 확정 시 재점검한다.
//   기준월은 '기준 주차 월요일'(주간)이라 SCP0055 gap date 콤보(COMBO.BASE_DATE=DATE_WEEKLY)로 연동했다.

// Division 후처리 필터 — AS-IS BLUtils.GetDivisionWithoutEE(ATTRIBUTE3 <> 'EE').
//   이관된 CMBO SQL 에는 없어 FE 클라 필터로 재현한다(SCP0114 와 동일).
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

// 임시: 현재 대시보드는 Div=81(Automotive Battery)로만 조회한다.
//   콤보는 라벨 표시용으로만 로드하고 선택은 비활성(disabled)한다.
//   다른 Div 조회를 지원하게 되면 이 고정값을 제거하고 콤보를 활성화한다.
export const FIXED_DIVISION = '81';

// 위젯별 조회 프로시저 sheetName — 등록 SHT_NM(SCM_ADM_API_URL_M)과 글자 그대로 일치해야
//   BE 라우팅(menuId/sheetName/call-proc)이 맞는다. PKG_DMD0001.P_DMD0001_GET_* 에 1:1 대응.
export const SHEETS = {
  KPI: 'kpi',
  PRODUCT_STATUS: 'productStatus',
  RISK_HEATMAP: 'riskHeatmap',
  EXCESS: 'excess',
  FORECAST_INFO: 'forecastInfo',
  DEMAND_TREND: 'demandTrend',
  INVENTORY_PROJECTION: 'inventoryProjection',
  COVER_TREND: 'coverTrend',
  MAPE: 'mape',
} as const;

// ----- 조회조건 헤더 옵션 -----
//   기준월·BizType·OEM 옵션은 모두 콤보 SP(COMBO.BASE_DATE·BIZ_TYPE·END_CUSTOMER)에서 로드한다(하드코딩 제거).
// 최근 업데이트 표시 — 현재는 고정 샘플. 후속으로 배치 실행시각(데이터) 연동.
export const LAST_UPDATED = '2025-05-12 08:30';
