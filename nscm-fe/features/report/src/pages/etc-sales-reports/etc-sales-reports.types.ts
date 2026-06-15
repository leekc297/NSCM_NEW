export interface SearchCondition {
  divisionId: string;
  deptIds: string[];           // T_DEPARTMENT_ID 매핑
  endCustomers: string[];
  scmSiteIds: string[];
  projectCode: string;
  itemId: string;
  bizTypes: string[];
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  versionType: string;
}

export type EtcSalesReportsRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  T_DEPARTMENT_ID?: string;
  T_DEPT_ID?: string;
  ETC_DESCR?: string;
  CELL_NAME?: string;
  MEASURE?: string;
  QTY?: number | string;
};
