// AS-IS DMF0048_SalesMonitoring.cs FindData() (L615~) — 15 search params:
//   division*(단일) / dept[] / endCustomer[] / scmSite[] / project / item / itemType[]
//   period* (yyyymmdd~yyyymmdd, ≤ 3년) / plantSite[] / bizType[] / owner
//   bucket* (D/W/M) / internalYn / cellQty? / nowDate (now=today auto)
export interface SearchCondition {
  divisionId: string;            // 필수 — clbDivision
  deptIds: string[];             // Team — clbTeam (^ delim)
  endCustomers: string[];        // clbCustomer (^ delim)
  scmSiteIds: string[];          // Sales Site — clbSalesSite
  plantSiteIds: string[];        // Plant Site — clbPlantSite (div=81/기타)
  projectCode: string;           // Project — txtProject + btnProject
  itemId: string;                // Model — txtItemId + btnItemId
  itemTypes: string[];           // Item Type — clbItemType
  bizTypes: string[];            // clbBizType
  owner: string;                 // Owner — txtOwner + btnOwner
  startYyyymmdd: string;         // Period.start (drpPeriod)
  endYyyymmdd: string;           // Period.end
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';  // cboBucketType (필수)
  internalYn: 'Y' | 'N';         // InternalYN checkbox
  showColor: boolean;            // chkColor (조회 후 셀 색상 표시)
  showSum: boolean;              // chkSum (조회 후 SUM 컬럼 표시)
}

// 메인 그리드 행 (P_DMF0048_GET_DM_PLN_SALES_MONITORING 결과 — wide format with dynamic time cols)
//   51 fixed cols + 동적 시간축 컬럼 (W_yyyymmdd 또는 M_yyyymm 또는 D_yyyymmdd)
//   조회 전용이므로 CRUD_TYPE 없음
export type SalesMonitoringRow = Record<string, unknown> & {
  MEASURE?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  YYYYMMDD?: string;
  QTY?: number | string;
};

// 메인 그리드 메타 (o_rc2) — ISO_WEEK / BASIS_DATE / BASIS_YYYYMM / THIS_YYYYMMWW / PRE_YYYYMMWW
//   AS-IS .cs L753~758 색상 표시용 (chkColor 옵션 시)
export interface SalesMonitoringMeta {
  ISO_WEEK: string;
  BASIS_DATE: string;
  BASIS_YYYYMM: string;
  THIS_YYYYMMWW: string;          // 현재 주 (W_ prefix 매칭)
  PRE_YYYYMMWW: string;            // 이전 주
}

// 동적 시간축 컬럼 메타 (P_DMF0048_GET_SPREAD_TITLE 결과)
//   AS-IS: BASIS_START_DATE / BASIS_START_DATE2 / MMDD / WEEK_NAME / YER+MON / BASIS_YYYYMM
//   To-Be: react FlexGrid <Col binding=BASIS_START_DATE2 header=MMDD> + 3단 group header
export interface SpreadTitleRow {
  BASIS_START_DATE: string;     // 시간키 (Tag)
  BASIS_START_DATE2: string;    // W_20260511 or M_202605 or D_20260511 (binding)
  MMDD: string;                 // Row2 header (예: '05/11')
  WEEK_NAME: string;            // Row1 header (예: 'W19')
  YER: string;                  // Row0 left (예: '2026')
  MON: string;                  // Row0 right (예: '2026-05')
  BASIS_YYYYMM: string;         // Row0 merge key (예: '202605')
}

// SP IN payload — BLOCK 4 PROC_M 매핑
//   P_USER_ID / P_MENU_ID 는 BE 자동 채움 (sesUserId / mnuId)
//   P_USERINFO / P_CREATED_BY / P_USER_DEPT_ID 도 BE 세션 정보로 자동 채움
//   multi-value 항목은 ^ 구분 join (deptIds/endCustomers/... ), 비어있으면 'ALL'
export interface SalesMonitoringMainPayload {
  divisionId: string;
  deptId: string;            // ^ delim or 'ALL'
  endCustomer: string;       // ^ delim or 'ALL'
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
  // createdBy / userinfo / userDeptId / sesUserId / mnuId 는 BE 자동 채움
}

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
}
