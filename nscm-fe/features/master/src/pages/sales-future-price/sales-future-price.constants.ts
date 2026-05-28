export const MENU_ID = 'DMF0020' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc',
}

/** As-Is DMF0020_SalesFuturePrice 의 사업부 분기 코드 (그대로 보존) */
export const DIVISION_CODE = {
  AUTOMOTIVE: '40',
  ESS: '81',
  POWER: '82',
} as const;
export type DivisionCode = (typeof DIVISION_CODE)[keyof typeof DIVISION_CODE];

/** Bucket Type: Weekly / Monthly */
export enum BUCKET_TYPE {
  WEEKLY = 'W',
  MONTHLY = 'M',
}

/** As-Is `DefColumns` — 11 좌측 고정 컬럼 + 시간축 동적 컬럼 */
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

/** 그룹 키 컬럼 (Measure 제외, 동시 선택용) — As-Is `Raw_CellClick` */
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
