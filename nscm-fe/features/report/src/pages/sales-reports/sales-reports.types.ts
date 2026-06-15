export interface SearchCondition {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[];
  projectCode: string;
  itemId: string;
  bizTypes: string[];
  cutoffYyyymmdd: string;     // DMF0044 특수 — cutoff
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  versionType: string;
}

export type SalesReportsRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  MEASURE?: string;
  QTY?: number | string;
};

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
}
