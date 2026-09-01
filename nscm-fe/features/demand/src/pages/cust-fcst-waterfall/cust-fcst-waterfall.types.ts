/**
 * DMF0053 Customer FCST Waterfall — 조회조건 상태 (#112 카탈로그 17행 — Cascade_Filter_전수.md §1).
 * Version(Date*) 칸은 AS-IS 숨김 + 카탈로그·Figma 부재로 미구현 (versionNo='' 고정 전달).
 */
export interface SearchParams {
  divisionId: string; // Div.* (단일)
  deptIds: string[]; // Team (다중)
  endCustomers: string[]; // End Customer (다중)
  bizTypes: string[]; // Biz. Type (다중)
  salesSiteIds: string[]; // Sales Site (다중)
  plantSiteIds: string[]; // Plant Site (다중 — div40 disabled)
  projectCodes: string[]; // PJT (검색 모달 — div40 disabled)
  itemIds: string[]; // Model/Nickname (검색 모달)
  itemTypes: string[]; // Item Type (다중)
  owners: string[]; // Owner (검색 모달)
  startYyyymmdd: string; // Period* from (기본 당월 1일 — AS-IS PR_GET_DAY_RANGE p_month=6)
  endYyyymmdd: string; // Period* to (+6개월 말일)
  fromCreateYyyymmdd: string; // Input Date* from (기본 당월 1일 — p_month=1)
  toCreateYyyymmdd: string; // Input Date* to (+1개월 말일)
  bucket: string; // Bucket (기본 MONTHLY)
  qty: string; // QTY 표시 스케일 (÷1/1e3/1e6/1e8 — FE 표시 변환)
  isSumChecked: boolean; // Sum — 상위 집계 컬럼 표시 (ONLY_WEEKLY 비활성)
}

/** 메인 커서 행 (동적 기간 컬럼 포함 — Measure 축 = MEASURE_GROUP/MEASURE) */
export interface WaterfallRow {
  MEASURE: string;
  MEASURE_GROUP: string;
  [key: string]: string | number;
}

/** 동적 시간축 커서 행 (P_DMF0053_GET_SPREAD_TITLE o_rc1) */
export interface SpreadTitleRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  DAY_CODE: string;
  SORT_ORDER_NO: string | number;
  /** UM-04 — 소수 자릿수 (SP: 정적=SHEET_COLUMNS 값 / 기간 컬럼=3. SpreadInfo.cs L1433~1440) */
  DATA_SCALE_NUMBER?: string | number;
  /** UM-04 — 컬럼 폭 (SP: 50) */
  COLUMN_WIDTH?: string | number;
  [key: string]: string | number | undefined;
}
