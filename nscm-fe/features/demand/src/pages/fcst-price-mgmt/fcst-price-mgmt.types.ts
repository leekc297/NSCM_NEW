export interface SearchCondition {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[];
  projectCode: string;
  itemId: string;
  bizTypes: string[];
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  versionType: string;
  qtyYn: 'Y' | 'N';            // DMF0082 특수 — QTY 표시 여부
}

// 권한 4 분기 — 행별 편집 가능/불가
export interface EditAuth {
  scmFcst: boolean;
  mktFcst: boolean;
  loc: boolean;
  vmiInReq: boolean;
}

export type FcstPriceMgmtRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  EDIT_FLAG?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  MEASURE?: string;
  CURRENCY?: string;
  QTY?: number | string;
  // 권한 분기 메타 (서버 결과)
  EDIT_YN?: 'Y' | 'N';
  AUTH_TYPE?: 'SCM_FCST' | 'MKT_FCST' | 'LOC' | 'VMI_IN_REQ';
};

// 메인 SP 6 ResultSet
export interface MainSpResult {
  o_rc1?: FcstPriceMgmtRow[];     // FCST
  o_rc2?: FcstPriceMgmtRow[];     // PRICE
  o_rc3?: unknown[];               // MEASURE
  o_rc4?: unknown[];               // CALENDAR
  o_rc5?: unknown[];               // WEEK
}

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
}
