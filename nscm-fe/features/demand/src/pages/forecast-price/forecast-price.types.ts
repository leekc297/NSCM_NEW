import type { DateRangePickerValueType } from '@shared/lges';

import type { MENU_ID, SHEETS } from './forecast-price.constants';

/**
 * SearchArea Form 의 사용자 입력 상태.
 * BE PROC IN 으로 변환은 `useForecastPriceStore.setFilters` 가 담당.
 */
export interface SearchParamProps {
  divisionId: string;
  teamId: string;
  endCustomer: string;
  salesSite: string;
  bizType: string;
  itemId: string;
  period: DateRangePickerValueType;
  bucketType: string;
  versionType: string;
  qtyYn: boolean;
  sumYn: boolean;
}

/**
 * 메인 조회 SHEET 의 응답 row 타입 — `data?.fcstNPrice` literal cursor 이름으로 접근.
 */
export type ForecastPriceRow = ResponseData<MENU_ID, SHEETS.FCST_N_PRICE_40, 'fcstNPrice'>;

/**
 * 동적 컬럼 SHEET 의 응답 row 타입.
 */
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'o_rc'>;
