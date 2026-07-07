// AS-IS 14 Search Conditions (tobe_design.md §9.1 / analysis.md §18.1):
//   Division*  / Team[]    / EndCustomer[] / SalesSite[] / PlantSite[] (div=81)
//   Item[]     / Project[] / Period*       / BizType[]   / Owner[]
//   Bucket*    / SearchOverRange / ExcludeNoPrice / Version*
export interface SearchCondition {
  divisionId: string; // 필수 — clbDivisions
  deptIds: string[]; // Team — clbTeam (^ delim)
  endCustomers: string[]; // clbEndCustomer (^ delim)
  scmSiteIds: string[]; // Sales Site — clbSalesSite (^ delim)
  plantSiteIds: string[]; // Plant Site — clbPlantSite (div=81 전용)
  itemIds: string[]; // Model — umltModel / btnItemId popup
  nickName: string; // (umltModel 보조)
  projectCodes: string[]; // Project — umltProject / usrButton1 popup
  startYyyymmdd: string; // Period.start (drpDateTime)
  endYyyymmdd: string; // Period.end
  bizTypes: string[]; // clbBizType
  owners: string[]; // txtOwner / btnOwner popup
  bucketType: 'W' | 'M'; // cboBucketType (필수)
  searchOverRange: boolean; // usrDiscard ("Search over range")
  excludeNoPrice: boolean; // checkInvalidExec ("Price 미등록 제외")
  versionId: string; // txtVersion / btnSPVer popup (default = CURRENT)
}

// 메인 그리드 행 (P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과 — wide format)
//   28 fixed cols + 동적 시간축 컬럼 (W_yyyymmdd 또는 M_yyyymm)
//   CRUD_TYPE: 'I' (신규) / 'M' (수정) / 'D' (삭제)
//   INSERT_GROUP_ID: Insert 시 같은 grouping (4 measure 묶음) 식별자
export type FuturePriceRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
  DIVISION_ID?: string;
  CURRENCY?: string;
};

// 동적 시간축 컬럼 메타 (DMF0020_GET_SPREAD_TITLE_DATE 결과 기반)
//   AS-IS: BASIS_START_DATE / BASIS_START_DATE2 / MMDD / WEEK_NAME / YER+MON / BASIS_YYYYMM
//   To-Be: react FlexGrid <Col binding=BASIS_START_DATE2 header=MMDD> + 3단 group header
export interface SpreadTitleDateRow {
  BASIS_START_DATE: string; // 시간키 (Tag)
  BASIS_START_DATE2: string; // W_20260511 or M_202605 (binding)
  MMDD: string; // Row2 header
  WEEK_NAME: string; // Row1 header
  YER: string; // Row0 left
  MON: string; // Row0 right (= YYYY-MM)
  BASIS_YYYYMM: string; // Row0 merge key
}

// SP IN payload — BLOCK 4 PROC_M 매핑
//   P_START_YYYYMMDD → startYyyymmdd
//   P_END_YYYYMMDD   → endYyyymmdd
//   P_USER_ID        → sesUserId (BE 자동 채움)
//   P_MNU_ID         → mnuId     (BE 자동 채움)
export interface FuturePriceMainPayload {
  startYyyymmdd: string;
  endYyyymmdd: string;
  // sesUserId / mnuId 는 BE 자동 채움
}

// Exchange Rate Save SP IN payload (P_DMF0000_SAVE_EXCHANGE_POPUP_DATA 8 IN)
export interface ExchangeSavePayload {
  activeFlag: string;
  divisionId: string;
  yyyymmdd: string;
  currency: string;
  unitCurrency: string;
  exchangePrice: string; // VARCHAR (^delim 가능)
  createdBy: string;
  lastUpdatedBy: string;
}

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
}

