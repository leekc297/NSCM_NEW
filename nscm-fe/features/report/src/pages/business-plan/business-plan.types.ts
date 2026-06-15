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
}

export type BizPlanRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  MEASURE?: string;
  QTY?: number | string;
};

export interface BizPlanMainPayload {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  scmSiteId: string;
  projectCode: string;
  itemId: string;
  bizType: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
  bucket: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  versionType: string;
}

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
}
