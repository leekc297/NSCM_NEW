// AS-IS .cs DefColumns — 15 컬럼
export interface SalesViewRow {
  YYYYMM: string;
  DIVISION_ID: string;
  VER_SEQ: string;
  COMPANY_ID: string;
  DEPARTMENT_ID: string;
  DEPARTMENT_NAME?: string;
  DEPT_ID: string;
  DEPT_NAME?: string;
  ATTRIBUTE2?: string;          // 고객군
  CUST_REPORT?: string;          // 고객 (END_CUST_REPORT)
  SOLDTO_CUST_REPORT?: string;
  SHIPTO_CODE?: string;
  CUST_GROUP_DTL?: string;       // 고객상세
  REPORT_GROUP3?: string;        // 제품군
  PRODUCT_GROUP?: string;
  DM_BIZ_TYPE?: string;
  CURRENCY?: string;
  EDIT_FLAG?: string;
  AMT?: number;
  [dynamicKey: string]: string | number | undefined;
}

export interface ViewSearchCondition {
  yyyy: string;
  verSeq: string;
  versionNo: string;
  divisionId: string;
  endCustReport: string;
  productGroup: string;
  bizType: string;
  millionYn: 'Y' | 'N';
  compatibilityYn: 'Y' | 'N';
}
