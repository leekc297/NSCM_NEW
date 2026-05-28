/**
 * DMF0020 SalesFuturePrice — 공용 타입
 *
 * AS-IS: Doc/_legacy_source/.../DMF0020_SalesFuturePrice.cs (3,969줄)
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/__asis-mapping__.md
 */

import type { BucketType } from './sales-future-price.constants';

/**
 * AS-IS DefColumns 의 32 컬럼 (analysis.md §4.5) + 동적 시간축.
 * 좌측 11 고정 (FROZEN_COLUMNS) + 우측 W_YYYYMMDD / M_YYYYMM (동적).
 * CRUD_TYPE / EDIT_FLAG 는 룰 12 GRID_COMMON 표준.
 */
export interface SalesFuturePriceRow {
  // 좌측 고정 (11) — analysis.md §4.5
  DIVISION_ID: string;
  TEAM_INCHARGE: string;
  END_CUSTOMER: string;
  SCM_SITE_ID: string;
  ITEM_ID: string;
  INCOTERMS: string;
  FCST_TYPE: string;
  DOM_EXP: string;
  CURRENCY: string;
  MEASURE: string;
  PRICE_EXIST: string;
  // 메타 (분석/표시용)
  PLANT_SITE_ID?: string;
  DEPT_ID?: string;
  UPPER_DEPT_ID?: string;
  DEPT_NAME?: string;
  END_CUSTOMER40?: string;
  PROJECT_CODE?: string;
  PROJECT_NAME?: string;
  ITEM_NAME?: string;
  ITEM_CLASS_NAME?: string;
  PROJECT_STATUS?: string;
  BIZ_TYPE?: string;
  BIZ_TYPE_NAME?: string;
  AUTHORITY_YN?: string;
  NICK_NAME?: string;
  NEW_FLAG?: string; // ESS NewFlag [C20200612-000174]
  // 표준 CRUD
  CRUD_TYPE?: string;
  EDIT_FLAG?: string;
  // 동적 시간축 (W_20260511 / M_202605)
  [key: `W_${string}`]: string | number | undefined;
  [key: `M_${string}`]: string | number | undefined;
}

/**
 * 동적 시간축 컬럼 정의 (SP `DMF0020_GET_SPREAD_TITLE_DATE` 결과).
 * analysis.md §18.2 + tobe_design.md §9.2 참조.
 */
export interface SalesFuturePriceDynamicColumn {
  /** Cell binding key — `W_20260511` 또는 `M_202605` */
  binding: string;
  /** Row 2 헤더 — `MMDD` (Weekly) 또는 `MM` (Monthly) */
  header: string;
  /** Row 1 헤더 — `WEEK_NAME` (Weekly 만) */
  weekName?: string;
  /** Row 0 머지 키 — `YYYY-MM` */
  basisYYYYMM: string;
  /** bucketType 에 따른 표시 여부 */
  visible: boolean;
}

/**
 * AS-IS 14 조회조건 필드 — analysis.md §18.1.
 * 사업부 분기 (40/81/82) 는 `divisionId` 단일 + JSX `{division === '40' && ...}` 분기.
 */
export interface SalesFuturePriceSearchParams {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[]; // ESS(81) 전용
  itemIds: string[];
  nickName: string;
  projectCodes: string[];
  periodFrom: string;
  periodTo: string;
  bizTypes: string[];
  owners: string[];
  bucketType: BucketType;
  searchOverRange: boolean;
  excludeNoPrice: boolean;
  versionId: string;
}

/**
 * Wijmo PivotGrid 입력용 — 클라이언트 unpivot 결과 (`utils/wideToLong.ts`).
 * AS-IS PIVOT SP 가 wide-format 으로 반환한 데이터를 long-format 으로 풀어 PivotEngine 에 입력.
 * 룰 27 §C — PivotGrid React 패턴.
 */
export interface SalesFuturePricePivotRow {
  DIVISION_ID: string;
  TEAM_INCHARGE: string;
  END_CUSTOMER: string;
  SCM_SITE_ID: string;
  ITEM_ID: string;
  INCOTERMS: string;
  FCST_TYPE: string;
  DOM_EXP: string;
  CURRENCY: string;
  MEASURE: string;
  /** 시간축 key (`W_20260511` / `M_202605` 의 원본 binding) */
  PERIOD: string;
  /** 시간축 표시용 라벨 (`2026-05-11` / `2026-05`) */
  PERIOD_LABEL: string;
  /** YYYY-MM (Row 0 그룹) */
  YEAR_MONTH: string;
  /** 가격 (PivotEngine value 필드) */
  PRICE: number;
}
