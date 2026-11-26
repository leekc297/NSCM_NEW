import type { BUCKET_TYPE } from './sales-price-model-group.constants';

// 조회조건 (설계서 [개요] 조회 조건 8칸). 다중 값은 배열로 두고 조회 때 '^' 로 잇는다(PKG_DMF0083 토큰 구분자).
export interface SearchParams {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  projectCodes: string[];
  mdlGrs: string[];
  fromYyyymmdd: string;
  toYyyymmdd: string;
  bucketType: BUCKET_TYPE;
}

// 메인 · 팝업 그리드 행. 조회 결과(고정 칸 + W_/M_ 기간 칸)에 화면 내부 칸(CRUD_TYPE, INSERT_GROUP_ID)이 더해진다.
export type ModelGroupRow = WijmoRowItem;

// main / SPREAD_TITLE_DATE 결과 — 조회 기간의 주 · 월 칸 뼈대.
export interface PeriodAxisRow {
  BASIS_START_DATE: string;
  BASIS_YYYYMM: string;
  WEEK_NAME: string;
  DATE_SHORT1_NAME: string;
  WEEK_COL_KEY: string;
  MONTH_COL_KEY: string;
}

// main · priceBatch / EXCHANGE_RATE 결과 (DM_MST_EXCHANGE_RATE 읽기 전용).
export interface ExchangeRateRow {
  YYYYMMDD: string;
  YYYYMM: string;
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  EXCHANGE_PRICE: string | number;
}

// main / SAVE 인자 (칸마다 '^' 로 이은 문자열, PROC_M 순서 1~13).
export interface SavePayload {
  activeFlag: string;
  divisionId: string;
  projectCode: string;
  scmSiteId: string;
  mdlGr: string;
  incoterms: string;
  fcstType: string;
  currency: string;
  yyyymmdd: string;
  measure: string;
  price: string;
  prcRpsn: string;
  fromYyyymmdd: string;
}
