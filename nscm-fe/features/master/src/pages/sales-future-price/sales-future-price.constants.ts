/**
 * DMF0020 SalesFuturePrice — 상수 정의
 *
 * AS-IS 정본: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/
 *             DMF0020_SalesFuturePrice/DMF0020_SalesFuturePrice.cs (3,969 줄)
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/__asis-mapping__.md
 *
 * SHT_NM 값은 메타 등록 SQL `_dmf0020_artifacts/sql/20_DMF0020_Registration.sql` BLOCK 5
 * (SCM_ADM_MNU_BTN_MPG_M) 과 **대소문자 정확 일치** (룰 27 §D).
 */

export const MENU_ID = 'DMF0020' as const;
export type MENU_ID = typeof MENU_ID;

/** As-Is 호출 시트 — 메인 1 + 자체 modal 5 (Version 은 PKG_DMF0073 라우팅) */
export enum SHEETS {
  MAIN = 'main',
  EXCHANGE_RATE = 'exchangeRate',
  PRICE_RANGE = 'salesPriceRange',
  PRICE_BATCH = 'priceBatchInput',
  PRICE_TEMPLATE = 'salesPriceTemplate',
  PRICE_VERSION = 'salesPriceVersion',
}

/** TabWrapper 인덱스 — 사용자 요구: Tab1 FlexGrid(기존 PIVOT SP 결과) + Tab2 Wijmo PivotGrid */
export enum SHEET_INDEX {
  MAIN_FLEX = 0,
  MAIN_PIVOT = 1,
}

/** SP O_RC1 응답 키 (NSCM 표준) */
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;

/**
 * AS-IS 사업부 분기 코드 — DMF0020_SalesFuturePrice.cs 의 38건 사업부분기 보존
 * (룰 09 §10 — 통합 단일 로직화 금지, validation.md §16.1)
 */
export const DIVISION_CODE = {
  AUTOMOTIVE: '40',
  ESS: '81',
  POWER: '82',
} as const;
export type DivisionCode = (typeof DIVISION_CODE)[keyof typeof DIVISION_CODE];

/** Bucket Type — Weekly / Monthly (cboBucketType — AS-IS .cs:3817) */
export const BUCKET_TYPE = {
  WEEKLY: 'W',
  MONTHLY: 'M',
} as const;
export type BucketType = (typeof BUCKET_TYPE)[keyof typeof BUCKET_TYPE];

/**
 * AS-IS DefColumns 의 좌측 고정 11 컬럼 — analysis.md §4.5 + tobe_design.md §9.3
 * 동적 시간축 컬럼은 SP `DMF0020_GET_SPREAD_TITLE_DATE` 결과로 별도 부착.
 */
export const FROZEN_COLUMNS = [
  'DIVISION_ID',
  'TEAM_INCHARGE',
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'ITEM_ID',
  'INCOTERMS',
  'FCST_TYPE',
  'DOM_EXP',
  'CURRENCY',
  'MEASURE',
  'PRICE_EXIST',
] as const;

/** Measure 제외 그룹 키 (동시 선택용) — AS-IS Raw_CellClick (.cs:3707) */
export const GROUP_KEY_COLUMNS = [
  'DIVISION_ID',
  'TEAM_INCHARGE',
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'ITEM_ID',
  'INCOTERMS',
  'FCST_TYPE',
  'DOM_EXP',
  'CURRENCY',
] as const;

/** 동적 컬럼 binding prefix — bucketType 별 (룰 27 §C — Sheet 5종 매핑 패턴) */
export const PERIOD_COLUMN_PREFIX = {
  WEEKLY: 'W_',
  MONTHLY: 'M_',
} as const;
