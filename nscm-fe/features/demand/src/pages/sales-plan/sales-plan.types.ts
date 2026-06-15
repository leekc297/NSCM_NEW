// AS-IS DMF0021_SalesPlan FindData() — 15 search params (DMF0048 동일 패턴)
export interface SearchCondition {
  divisionId: string;            // 필수
  deptIds: string[];             // Team
  endCustomers: string[];
  scmSiteIds: string[];
  plantSiteIds: string[];
  projectCode: string;
  itemId: string;
  itemTypes: string[];
  bizTypes: string[];
  owner: string;
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  internalYn: 'Y' | 'N';
  showColor: boolean;
  showSum: boolean;
}

// 메인 그리드 행 — wide format with dynamic time cols
//   CRUD_TYPE: 'I' / 'U' / 'D' (Insert / Update / Delete — AS-IS EditFlag)
export type SalesPlanRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  EDIT_FLAG?: string;
  MEASURE?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  YYYYMMDD?: string;
  QTY?: number | string;
};

// 메타 (o_rc2 — DMF0048 동일 패턴)
export interface SalesPlanMeta {
  ISO_WEEK: string;
  BASIS_DATE: string;
  BASIS_YYYYMM: string;
  THIS_YYYYMMWW: string;
  PRE_YYYYMMWW: string;
}

// 동적 시간축 컬럼 메타 (DMF0048 동일)
export interface SpreadTitleRow {
  BASIS_START_DATE: string;
  BASIS_START_DATE2: string;
  MMDD: string;
  WEEK_NAME: string;
  YER: string;
  MON: string;
  BASIS_YYYYMM: string;
}

// SP IN payload
export interface SalesPlanMainPayload {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  scmSiteId: string;
  projectCode: string;
  itemId: string;
  itemType: string;
  fromYyyymmdd: string;
  nowYyyymmdd: string;
  toYyyymmdd: string;
  plantSiteId: string;
  biztype: string;
  owner: string;
  internalYn: 'Y' | 'N';
  bucket: 'DAILY' | 'WEEKLY' | 'MONTHLY';
}

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
}
