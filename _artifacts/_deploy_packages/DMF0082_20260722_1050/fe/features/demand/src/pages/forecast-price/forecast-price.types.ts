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

/**
 * GET drop4 (= O_RC5 실측) 배분 캘린더 row — 월(M_) 수량 일별 배분(#1)·M+4 규칙 입력.
 *   MONTH_DAY_CNT = 소속 월 전체 일수 / WEEK_DAY_CNT = 소속 ISO 주 일수 (AS-IS dtCalendarDetail Tables[4]).
 */
export interface CalendarRow {
  BASIS_YYYYMMDD?: string;
  MONTH_DAY_CNT?: number | string;
  WEEK_DAY_CNT?: number | string;
}

/**
 * GET drop1 (= O_RC2 실측) 월별 정보 row — M3_CUTOFF_DATE = M+3 기준일(ADD_MONTHS(첫월,3)).
 *   첫 행 M3_CUTOFF_DATE 앞 6자리 = M+4 잠금 경계월 (AS-IS dtWeek.Rows[0]["MONTH_NAME"], #4).
 */
export interface MonthInfoRow {
  BASIS_YYYYMM?: string;
  MONTH_END_DATE?: string;
  M3_CUTOFF_DATE?: string;
}
