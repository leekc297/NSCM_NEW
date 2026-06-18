// AS-IS .cs DefColumns 의 13 컬럼 — Wijmo FlexGrid binding 용
export interface MainRow {
  DIVISION_ID: string;
  VER_SEQ: string;
  DEPARTMENT_ID: string;
  DEPT_ID: string;
  END_CUST_REPORT: string;
  SOLDTO_CUST_REPORT: string;
  PRODUCT_GROUP: string;
  DM_BIZ_TYPE: string;
  EDIT_FLAG: string;
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  // 동적 월별 컬럼 (Y#YYYYMM#OS_CORP_CD 패턴)
  [dynamicKey: string]: string | number | undefined;
}

export interface VersionRow {
  VER_SEQ: string;
  YYYY: string;
  VERSION_NM?: string;
  DESCRIPTION?: string;
  VALID_YN?: string;
  CODE?: string;
  NAME?: string;
  NAME2?: string;
}

export interface SalesRow {
  YYYYMM: string;
  DEPARTMENT_ID: string;
  DEPARTMENT_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  CUST_REPORT?: string;
  END_CUST_REPORT?: string;
  SOLDTO_CUST_REPORT?: string;
  SHIPTO_CODE?: string;
  PRODUCT_GROUP?: string;
  DM_BIZ_TYPE?: string;
  AMT?: number;
  EDIT_FLAG?: string;
}

export interface SearchCondition {
  yyyy: string; // usrYear 선택 년도
  verSeq: string; // usrYear 선택 verSeq
  his: 'Y' | 'N'; // usrHis
  dis: 'ALL' | 'N'; // usrDiscard (불일치 조회)
  chkYear: boolean; // chkYear (년도별 필터)
}

export interface ContributeRatePopupResult {
  divisionId: string;
  yyyymm: string;
  osCorpCd: string;
  contributionType: string;
  contributionRatio: string;
}
