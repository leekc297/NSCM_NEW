export interface SearchCondition {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[];
  projectCode: string;
  itemId: string;
  bizTypes: string[];
  itemTypes: string[];
  owner: string;
  startYyyymm: string;
  endYyyymm: string;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  showSum: boolean;
  showColor: boolean;
}

export type MktForecastAutoRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  EDIT_FLAG?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  PLAN_YYYYMM?: string;
  M3_CUST_FCST_QTY?: number | string;
  M3_MKT_FCST_QTY?: number | string;
  POPUP_STATUS?: 'MODIFY' | 'READ_OK' | 'READ_NONE';
};

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
}
