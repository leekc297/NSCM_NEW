/**
 * DMF0040 MKT FCST Comparison — 조회조건 상태 (AS-IS Designer 실측 17 조건 — Cascade_Filter_전수.md §1).
 * Cell Qty(cboCellQty)는 AS-IS 에서 layoutControlItem10 Visibility=Never 로 화면 미노출 — TO-BE 제외.
 */
export interface SearchParams {
  divisionId: string; // Division* (단일)
  deptIds: string[]; // Team (다중)
  endCustomers: string[]; // End Customer (다중)
  bizTypes: string[]; // Biz Type (다중)
  salesSiteIds: string[]; // Sales Site (다중)
  plantSiteIds: string[]; // Plant Site (다중 — div40 disabled)
  projectCodes: string[]; // Project (검색 모달 — div40 disabled)
  itemIds: string[]; // Model/Nickname (검색 모달)
  itemTypes: string[]; // Item Type (다중)
  owners: string[]; // Owner (검색 모달)
  version: string; // Version* (readOnly — 모달 전용, 콤마 최대 2. 기본 = 최근 MF_W 2개)
  startYyyymmdd: string; // Period* from
  endYyyymmdd: string; // Period* to
  bucket: string; // Bucket (기본 MONTHLY)
  qty: string; // QTY 표시 스케일 (÷1/1e3/1e6/1e8 — FE 표시 변환)
  isSumChecked: boolean; // Sum — 상위 집계 컬럼 표시 (ONLY_WEEKLY 비활성)
  isDiffOnly: boolean; // Diff.Only — p_diff_only
}

/** 메인 커서 행 (동적 기간 컬럼 포함) */
export interface ComparisonRow {
  VERSION_NO: string;
  MEASURE: string;
  MEASURE_GROUP: string;
  [key: string]: string | number;
}

/** 동적 시간축 커서 행 (DMF0040_GET_SPREAD_TITLE o_rc1) */
export interface SpreadTitleRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  DAY_CODE: string;
  SORT_ORDER_NO: string | number;
  /** UM-04 — 소수 자릿수 (SP: 정적=SHEET_COLUMNS 값 / 기간 컬럼='' = 0자리·구분자 없음. SpreadInfo.cs L1433~1440) */
  DATA_SCALE_NUMBER?: string | number;
  /** UM-04 — 컬럼 폭 (SP: ONLY_WEEKLY 100 / 그 외 50) */
  COLUMN_WIDTH?: string | number;
  [key: string]: string | number | undefined;
}
