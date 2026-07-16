import type { MENU_ID, SHEETS } from './forecast-price.constants';

/**
 * SearchArea Form 의 사용자 입력 상태 — AS-IS 체크리스트콤보(멀티)와 1:1 (clbTeam/clbCustomer/
 * clbBizType/clbSalesSite = 멀티, txtItemId/txtVersion = 텍스트+팝업, drpPeriod = 기간).
 * BE PROC IN 변환은 `useForecastPriceStore.setFilters` 담당 — ⚠️ DMF0082 SP 멀티 구분자 = 콤마
 * (PKG_DMF0082 REGEXP_SUBSTR '[^,]+' 실측 — DMF0003 의 '^' 와 다름).
 */
export interface SearchParamProps {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  salesSites: string[];
  bizTypes: string[];
  itemIds: string[];
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucketType: string; // 'D' | 'W' | 'M' (AS-IS cboBucketType Daily/Weekly/Monthly)
  versionType: string;
  qtyYn: boolean; // cboQty — Qty ≥ 0 만 조회
  sumYn: boolean; // chkSum — SUM 컬럼 표시
}

/**
 * 메인 조회 SHEET 의 응답 row 타입 — `data?.fcstNPrice` literal cursor 이름으로 접근.
 */
export type ForecastPriceRow = ResponseData<MENU_ID, SHEETS.FCST_N_PRICE_40, 'fcstNPrice'>;

/**
 * 동적 컬럼 SHEET 의 응답 row 타입.
 */
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'o_rc'>;

/**
 * GET 부가 커서 row (TO-BE PKG 실행 실측 2026-07-12) —
 *   drop1 = 주차 정보 / drop2 = 오늘(TODAY_DATE/TODAY_DAY/TODAY_TIME) /
 *   drop3 = measure 편집권한(MEASURE/EDIT_AUTH_YN/TODAY_LIMIT_YN/TODAY_DAY_LIST —
 *           AS-IS bEDIT_AUTH_* 원천. 행별 EDIT_FLAG 는 PKG 가 요일제한까지 종합 산출하므로
 *           FE 는 EDIT_AUTH_YN 을 measure 게이트로만 사용) / drop4 = 배분용 달력.
 */
export interface MeasureAuthRow {
  MEASURE?: string;
  EDIT_AUTH_YN?: string;
  TODAY_LIMIT_YN?: string;
  TODAY_DAY_LIST?: string;
}
