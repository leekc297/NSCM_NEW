// DESIGN §1.2 — Report Name / Description / Role (구 queryName/category 대체).
// setFilter 가 SP IN 파라미터로 매핑 — SP 입력명 정합 확인 의무(불일치 시 store 매핑, BE 무변경).
export interface SearchCondition {
  reportName: string;
  description: string;
  role: string;
}

// SP `PKG_SYS0013.P_SYS0013_GET_QUERY_LIST` 반환 컬럼 = SCM_ADM_DQ_LIST 원본 (DQ_ID / DQ_NAME / DQ_TEXT).
// WijmoRowItem (`Record<string, WijmoPrimitive>`) 제약 — 모든 필드 non-optional string.
export interface QueryRow extends WijmoRowItem {
  DQ_ID: string;
  DQ_NAME: string;
  DQ_TEXT: string;
  DESCRIPTION: string;
  DIVISION_ID: string;
  VALID_YN: string;
  ADMIN_ONLY_YN: string;
  GROUP_ID: string;
  GROUP_NAME: string;
  EDIT_YN: string;
  CREATED_BY: string;
  CREATION_DATE: string;
}

// Wijmo grid row 제약 (Record<string, WijmoPrimitive>) 만족.
export type ResultRow = WijmoRowItem;

// SP `P_SYS0013_GET_COLUMNS` 반환 — SCM_ADM_DQ_COLUMNS 원본.
// AGGREGATE = ATTRIBUTE2 영속화 (SUM/MAX/MIN/COUNT, 2026-06-26).
export interface ColumnMetaRow extends WijmoRowItem {
  DQ_ID: number;
  COLUMN_NAME: string;
  VALUE_YN: string;
  VALUE_TYPE: string;
  VALID_YN: string;
  SEQNO: string;
  AGGREGATE: string;
}

// SP `P_SYS0013_GET_PARAMETERS` 반환 — SCM_ADM_DQ_PARAMETER 원본.
// ATTRIBUTE1 = SEQNO / ATTRIBUTE2 = DEFAULT_VALUE (admin 등록 초기값).
export interface ParameterMetaRow extends WijmoRowItem {
  DQ_ID: number;
  PARAMETER_ID: string;
  PARAMETER_TYPE: string;
  OPERATION_ID: string;
  VALID_YN: string;
  REP_YN: string;
  SEQNO: string;
  DEFAULT_VALUE: string;
}

// AS-IS siWhere grid 의 OPORATOR 컬럼 dropdown 값 카탈로그.
// SCM0005_DynamicQueryList.cs L442-470 — Operation 값별 WHERE 조립 분기.
export const OPERATION_OPTIONS = ['=', '>', '<', 'IN', 'LIKE'] as const;
export type OperationCode = (typeof OPERATION_OPTIONS)[number];

// AS-IS AGGREGATE 콤보 (PKG_SYS0013 GET_ROLE_DATA P_NICKNAME='AGGREGATE' = SUM/MAX/MIN/COUNT).
// 빈값 = 비집계(그룹) 컬럼. SCM_ADM_DQ_COLUMN.ATTRIBUTE2 영속화.
export const AGGREGATE_OPTIONS = ['', 'SUM', 'MAX', 'MIN', 'COUNT'] as const;
export type AggregateCode = (typeof AGGREGATE_OPTIONS)[number];
