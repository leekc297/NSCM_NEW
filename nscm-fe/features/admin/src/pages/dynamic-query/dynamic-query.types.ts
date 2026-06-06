export interface SearchCondition {
  queryName: string;
  category: string;
}

export interface QueryRow {
  QUERY_ID: string;
  QUERY_NAME: string;
  QUERY_CATEGORY: string;
  QUERY_SQL: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  USE_YN: string;
}

export interface ResultRow {
  [key: string]: unknown;
}

export interface ColumnMetaRow {
  QUERY_ID: string;
  COL_NM: string;
  COL_HEADER: string;
  DATA_TYPE: string;
  WIDTH: number;
  SORT_ORD: number;
}

export interface ParameterMetaRow {
  QUERY_ID: string;
  PARAM_NM: string;
  PARAM_LABEL: string;
  DATA_TYPE: string;
  DEFAULT_VALUE: string;
  REQUIRED_YN: string;
  SORT_ORD: number;
}

export interface HistoryRow {
  HIST_ID: string;
  QUERY_ID: string;
  EXECUTED_BY: string;
  EXECUTED_AT: string;
  DURATION_MS: number;
  ROW_COUNT: number;
  STATUS: string;
}
