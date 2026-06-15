export interface SearchCondition {
  queryName: string;
  category: string;
}

export interface QueryRow extends WijmoRowItem {
  QUERY_ID: string;
  QUERY_NAME: string;
  QUERY_CATEGORY: string;
  QUERY_SQL: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  USE_YN: string;
}

// Wijmo grid row 제약 (Record<string, WijmoPrimitive>) 만족.
export type ResultRow = WijmoRowItem;

export interface ColumnMetaRow extends WijmoRowItem {
  QUERY_ID: string;
  COL_NM: string;
  COL_HEADER: string;
  DATA_TYPE: string;
  WIDTH: number;
  SORT_ORD: number;
}

export interface ParameterMetaRow extends WijmoRowItem {
  QUERY_ID: string;
  PARAM_NM: string;
  PARAM_LABEL: string;
  DATA_TYPE: string;
  DEFAULT_VALUE: string;
  REQUIRED_YN: string;
  SORT_ORD: number;
}

export interface HistoryRow extends WijmoRowItem {
  HIST_ID: string;
  QUERY_ID: string;
  EXECUTED_BY: string;
  EXECUTED_AT: string;
  DURATION_MS: number;
  ROW_COUNT: number;
  STATUS: string;
}
