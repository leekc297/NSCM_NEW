// SYS0013 화면 행/조회조건 타입 — procedures.d.ts SYS0013 엔트리와 필드 동일 (구조 호환).
// 조회조건: AS-IS Register 탭 Report Name / Description / Role (SCM0005 Designer L375/385/405).
export interface SearchCondition {
  reportName: string;
  description: string;
  role: string;
}

// SP `PKG_SYS0013.P_SYS0013_GET_QUERY_LIST` 반환 — SCM_ADM_DQ_LIST + GROUP LISTAGG.
// CRUD_TYPE 은 EditTracker/GridAction 이 마킹 (표준).
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

// EXECUTE 결과 — 동적 SELECT 컬럼 (쿼리마다 상이).
export type ResultRow = WijmoRowItem;

// SP `P_SYS0013_GET_COLUMNS` 반환 — SCM_ADM_DQ_COLUMN (SEQNO=ATTRIBUTE1 / AGGREGATE=ATTRIBUTE2).
export interface ColumnMetaRow extends WijmoRowItem {
  DQ_ID: number;
  COLUMN_NAME: string;
  VALUE_YN: string;
  VALUE_TYPE: string;
  VALID_YN: string;
  SEQNO: string;
  AGGREGATE: string;
}

// SP `P_SYS0013_GET_PARAMETERS` 반환 — SCM_ADM_DQ_PARAMETER (SEQNO=ATTRIBUTE1 / DEFAULT_VALUE=ATTRIBUTE2).
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

// P_SYS0013_VALIDATE_QUERY O_RC1 — DBMS_SQL.DESCRIBE_COLUMNS2 결과 (격차① 컬럼 자동추출).
export interface ValidateColumnRow {
  COLUMN_NAME: string;
  VALUE_TYPE: string;
  SEQNO: number;
}

// 편집 모달 OK 시 보관되는 Column/Condition 최종 상태 + 원본 스냅샷 — Save 시 diff(I/M/D) 계산 후
// 저장 체인 수행. 신규 행은 SAVE_QUERY_LIST 의 NEW_DQ_IDS(v3) 로 채번 ID 수신 (AS-IS sDB_ID 정합).
export interface PendingModalColumnRow {
  COLUMN_NAME: string;
  VALUE_TYPE: string;
  VALID_YN: string;
  SEQNO: string;
  AGGREGATE?: string;
}
export interface PendingModalConditionRow {
  PARAMETER_TYPE: string;
  PARAMETER_ID: string;
  VALID_YN: string;
  SEQNO: string;
  OPERATION_ID?: string;
  REP_YN?: string;
  DEFAULT_VALUE?: string;
}
export interface PendingQueryMeta {
  row: QueryRow;
  roles: string[];
  colsFinal: PendingModalColumnRow[];
  condsFinal: PendingModalConditionRow[];
  colsOriginal: PendingModalColumnRow[];
  condsOriginal: PendingModalConditionRow[];
}

// AS-IS siWhere OPORATOR 콤보 카탈로그 (SCM0005 L442-470 WHERE 조립 분기).
export const OPERATION_OPTIONS = ['=', '>', '<', 'IN', 'LIKE'] as const;
export type OperationCode = (typeof OPERATION_OPTIONS)[number];

// AS-IS AGGREGATE 콤보 (GetCommonDataByDB('AGGREGATE') — SUM 기본, String 타입은 'Group' 고정).
// 빈값 = 비집계(그룹) 컬럼. SCM_ADM_DQ_COLUMN.ATTRIBUTE2 영속화.
export const AGGREGATE_OPTIONS = ['', 'SUM', 'MAX', 'MIN', 'COUNT'] as const;
export type AggregateCode = (typeof AGGREGATE_OPTIONS)[number];
