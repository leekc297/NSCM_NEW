// 조회조건 — Version(팝업 주입) + Period(월 구간 yyyyMM)
export interface SearchCondition {
  versionNo: string;
  periodFrom: string; // yyyyMM
  periodTo: string; // yyyyMM
}

// 메인 그리드 행 — PKG_DMF0068.P_DMF0068_GET_ORDERLIST 의 o_rc1 (고정 14 + 월 M1..Mn)
export interface DemandManagerRow {
  PROJECT_NAME?: string;
  MEASURE?: string;
  ORDERSTART?: string;
  ORDEREND?: string;
  ORDERAPPROVAL?: string | number;
  ORDERNOW?: string | number;
  SRESULT?: number;
  SPLAN?: number;
  STOCK?: number;
  STOCK2?: number;
  KEYVALUE?: string; // ATTRIBUTE1 — 행 자신의 키
  KEYVALUE2?: string; // ATTRIBUTE2 — Measure 짝 그룹 키
  MEASURE2?: string; // 조인용 Measure 코드
  EDIT_YN?: string;
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string; // 신규 세트 임시 그룹 키 (저장 시 KEYVALUE2 로 승격)
  [key: string]: string | number | undefined; // M1..Mn
}

// 버전 팝업 행 — 그리드 바인딩 대상이므로 값에 undefined 를 두지 않는다
export interface VersionPopupRow {
  CODE: string;
  VERSION_NO: string;
  VERSION_DESCRIPTION: string;
  VERSION_TYPE: string;
  VER_CRE_SEQ: string;
  YYYYMMDD: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  EDIT_YN: string;
  [key: string]: string | number;
}

// Project 셀 콤보 행
export interface LookupProjectRow {
  CODE?: string;
  NAME?: string;
  [key: string]: string | number | undefined;
}

// 저장 payload 1행 (PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST_JSON 의 JSON 요소)
export interface SaveOrderRow {
  DIVISION_ID: string;
  PROJECT_CODE: string;
  YYYYMM_FROM: string;
  YYYYMM_TO: string;
  MEASURE: string;
  ORDER_APPROVAL: string;
  ORDER_NOW: string;
  ATTRIBUTE1: string;
  ATTRIBUTE2: string;
}

// 월 컬럼 메타 — 조회 기간에서 산출 (n번째 표시 월 = Mn)
export interface MonthColumnMeta {
  binding: string; // M1 · M2 · ...
  yyyymm: string; // 202601
  year: string; // 2026
  label: string; // 2026.01
}
