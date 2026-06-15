export interface SearchCondition {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[];     // div=81 만 활성
  projectCode: string;        // div=81/82 만 활성
  itemId: string;
  startYyyymm: string;        // MonthRangePicker
  endYyyymm: string;
  versionType: string;        // default 'Current'
}

export type MetalLinkPriceRow = Record<string, unknown> & {
  DIVISION_ID?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  METAL_KIND_CODE?: string;
  CURRENCY?: string;
  PLAN_YYYYMM?: string;
  CONTRACT_UNIT_PRICE?: number | string;
  METAL_APPLY_UNIT_PRICE?: number | string;
  METAL_REQR_QTY?: number | string;
  ENERGY?: number | string;
};

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
}
